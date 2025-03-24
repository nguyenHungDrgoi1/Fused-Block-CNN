module CONV_256PE_xyz_tb();

    // IFM paramter for fused layer 
    parameter IFM_W     =   32;
    parameter IFM_H    =   IFM_W;
    parameter IFM_C     =   3;
    // kernel paramter for fused layer 
    parameter kernel_W  =   3;
    parameter kernel_H  =   kernel_W;

    // OFM paramter for fused layer 
    parameter OFM_W     =   32;
    parameter OFM_H     =   OFM_W;
    parameter OFM_C     =   2;
    
    parameter period = 4;
    parameter NUM_OF_PE = 256;
    parameter kernel_size = 3; // 3x3
    parameter kernel_channel = 3;
    parameter kernel_filter = 3;
    parameter x_size_of_ifm = 34; 
    parameter chanel_input_size = x_size_of_ifm * x_size_of_ifm; 
    parameter input_channel = 3;
    parameter input_size = chanel_input_size * input_channel;
    parameter weight_size = kernel_size * kernel_size * kernel_channel;
    parameter ifm_data_size = chanel_input_size * kernel_size * kernel_channel; 
    parameter num_of_tiles = chanel_input_size / NUM_OF_PE;
    parameter weight_data_size = kernel_size * kernel_size * num_of_tiles * kernel_channel; 
    parameter OFM_width = 32; // Giả sử OFM là 30x30 (sau padding)
    

    

    reg clk, rst;
    reg [256*8-1:0] input_feature;
    reg [7:0] weight;
    wire [256*8-1:0] output_feature;
    reg [NUM_OF_PE - 1: 0] PE_restart;
    reg [NUM_OF_PE - 1 : 0] PE_finish;
    wire [NUM_OF_PE - 1:0] valid;
    reg [7:0] fifo_input[ifm_data_size - 1 : 0];
    reg [7:0] fifo_weight[weight_data_size - 1 : 0];

    integer file_input, file_weight, file_out,file_debug_out, cycle_count = 0;
    integer i, j, k, index;
    integer t=0;  // 
    integer counter=1;
    integer x, y, z;
    integer PE_index;
    integer Cycles_total = weight_data_size/num_of_tiles;
    integer total_PE = NUM_OF_PE;
    
    always #(period/2) clk = ~clk;
    event event_1;

    CONV_256PE dut (
        .clk(clk),
        .reset_n(rst),
        .IFM(input_feature),
        .Weight(weight),
        .OFM(output_feature),
        .PE_restart(PE_restart),
        .PE_finish(PE_finish),
        .valid(valid)
    );

    initial begin
        clk = 0;
        input_feature = 0;
        weight = 0;
        PE_restart = 0;
        PE_finish = 0;

        file_input = $fopen("/home/thanhdo/questasim/PE/Fused-Block-CNN/in-out-weight/input_padding_32x32x3.hex", "r");
        file_weight = $fopen("/home/thanhdo/questasim/PE/Fused-Block-CNN/in-out-weight/weight_3x3x3x3_DUT.hex", "r");
        file_out = $fopen("/home/thanhdo/questasim/PE/Fused-Block-CNN/in-out-weight/output_32x32x3(xyz_formula).hex", "w");
        file_debug_out = $fopen("/home/thanhdo/questasim/PE/Fused-Block-CNN/in-out-weight/result(xyz_formula).hex", "w");

        if (file_input && file_weight) begin
            for (i = 0; i < ifm_data_size; i = i + 1) begin
                $fscanf(file_input, "%h", fifo_input[i]);
            end
            for (i = 0; i < weight_data_size; i = i + 1) begin
                $fscanf(file_weight, "%h", fifo_weight[i]);
            end
        end else begin
            $display("Error opening input files");
            $finish;
        end

        $fclose(file_input);
        $fclose(file_weight);
    end

    initial begin 
        rst = 0;
        #10;
        rst = 1;
        #15;
        
        forever begin
            @event_1 begin 
                PE_restart = {NUM_OF_PE{1'b1}};
                #10;
                PE_restart = {NUM_OF_PE{1'b0}};
            end
        end
    end

    initial begin
        #20;
        
        forever @(posedge clk) begin
            if (t == weight_data_size) begin
                @(negedge clk);
                for (k = 0; k < NUM_OF_PE; k = k + 1) begin
                    $fwrite(file_out, "%h\n", output_feature[k*8+:8]);
                end
                $fclose(file_out);
                $finish;
            end
            
            if ((t % (weight_data_size / num_of_tiles) == 0) && t != 0) begin
                @(negedge clk);
                for (k = 0; k < NUM_OF_PE; k = k + 1) begin
                    $fwrite(file_out, "%h\n", output_feature[k*8+:8]);
                end
                -> event_1;
            end

            if (PE_restart == 'b0) begin
                $fwrite(file_debug_out, "--------------counter:= %2.d --------------- \n", counter);
                for (PE_index = 0; PE_index < NUM_OF_PE; PE_index = PE_index +1) begin
                //for (PE_index = NUM_OF_PE-1; PE_index >=0; PE_index = PE_index -1) begin    
                    x = (counter + kernel_size - 1) % kernel_size + 
                        (PE_index + (counter / (Cycles_total + 1)) * (total_PE % OFM_width)) % OFM_width;

                    y = ((counter - 1) / kernel_size) % kernel_size + 
                        (   PE_index +  counter/ (Cycles_total + 1) * (total_PE - 1) + (counter / Cycles_total)  ) / OFM_width;

                    //z = ((t - 1) / (kernel_size * kernel_size)) % OFM_width;
                    z = ((counter - 1) / (kernel_size * kernel_size)) % IFM_C;

                    // Truy xuất dữ liệu dựa trên x, y, z
                    index = x + y * x_size_of_ifm + z * chanel_input_size;
                    input_feature[PE_index * 8+:8] <= fifo_input[index]; 
                    if( PE_index == 1 ) $display("PE_index = %d ; ( x,y,z ) =(%2.d, %2.d, %2.d) ;counter:= %2.d index = %d",PE_index,x,y,z,counter,index);
                    
                     $fwrite(file_debug_out, "PE_index = %d ; ( x,y,z ) =(%2.d, %2.d, %2.d) ;counter:= %2.d index = %d \n",PE_index,x,y,z,counter,index);
                end
                weight <= fifo_weight[t];
                t = t + 1;
                
                counter =counter+1;
                
            end

            cycle_count = cycle_count + 1;
        end
    end
endmodule
