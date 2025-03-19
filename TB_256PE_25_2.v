module CONV_256PE_32x32_tb();
    parameter period =10;
    parameter NUM_OF_PE = 256;
    parameter one_chanel_kernel_size = 9; // 3x3
    parameter kernel_channel = 3;
    parameter kernel_filter = 3;
    parameter filter_size = 3;
    parameter x_size_of_ifm = 32; 
    parameter chanel_input_size = x_size_of_ifm*x_size_of_ifm; 
    parameter input_channel = 3;
    parameter input_size = chanel_input_size * input_channel;
    parameter weight_size = one_chanel_kernel_size * kernel_channel * kernel_filter;
    parameter operation = input_size * one_chanel_kernel_size * input_channel;
    parameter ifm_data_size = chanel_input_size*one_chanel_kernel_size*kernel_channel; // Total data to save into the ifm_fifo
    parameter num_of_tiles= chanel_input_size/NUM_OF_PE;
    parameter weight_data_size = one_chanel_kernel_size*num_of_tiles*kernel_channel; // Total data to save into the ifm_fifo

    reg clk, rst;
    reg [256*8-1:0] input_feature;
    reg [7:0] weight;
    wire [256*8-1:0] output_feature;
    reg [NUM_OF_PE - 1: 0] PE_restart;
    reg [NUM_OF_PE - 1 : 0] PE_finish;
    wire [NUM_OF_PE - 1:0] valid;
    reg [7:0] fifo_input[ifm_data_size - 1 : 0];
    reg [7:0] fifo_weight[weight_data_size - 1 : 0];
    
    integer file_input, file_weight, file_out, cycle_count = 0;
    integer i = 0;
    integer j = 0;
    integer k = 0;
    integer c = 0;
    integer m = 0;
    integer t = 0;
    integer index = 0;
    integer channel_index =0;
    integer tile_index =0;
    integer pixel_index =0;
    integer check_point =0;
    always #(period/2) clk = ~clk;
    event event_1;

    real time_in_s ; // s
    real bw_ifm ; // GB/s
    real bw_weight ; // GB/s
    real bw_ofm ; // GB/s

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
        
        file_input = $fopen("/home/thanhdo/questasim/PE/Fused-Block-CNN/in-out-weight/input_32x32x3_DUT.hex", "r");
        file_weight = $fopen("/home/thanhdo/questasim/PE/Fused-Block-CNN/in-out-weight/weight_3x3x3x1_DUT.hex", "r");
        file_out = $fopen("/home/thanhdo/questasim/PE/Fused-Block-CNN/in-out-weight/output_32x32x1(DUT).hex", "w");
        //in-out-weight/input_32x32_DUT.hex

        if (file_input && file_weight) begin
            for (i = 0; i < ifm_data_size ; i = i + 1) begin
                $fscanf(file_input, "%h", fifo_input[i]);
            end
            for (i = 0; i <weight_data_size ; i = i + 1) begin
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
        //----------------------------------------------
        
        PE_finish = {NUM_OF_PE{1'b1}};
        #10;
        PE_finish = {NUM_OF_PE{1'b0}};
        //----------------------------------------------
        PE_restart = {NUM_OF_PE{1'b1}};
        #10;
        PE_restart = {NUM_OF_PE{1'b0}};
        #265;
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
        
        // weight_data_size = one_chanel_kernel_size*num_of_tiles*kernel_channel; 
        forever @(posedge clk) begin
            if ( 1 )  begin
                if (t==weight_data_size) begin
                    @(negedge clk)
                    for (m = 0; m < NUM_OF_PE; m = m + 1) begin
                        $fwrite(file_out, "%h\n", output_feature[m*8+:8 ]);
                    end
                    //$fwrite(file_out, "OPS: %d\n", (weight_data_size*2) / (period *cycle_count* (10^-9) ));

                    $fwrite(file_out, "GOPS: %d\n", (weight_data_size * 2 * 1e3) / (period * cycle_count));
                    $display("GOPS: %d\n", (weight_data_size*2) *  (10**3)/ (period *cycle_count)  );

                    // band-width
                    time_in_s = period * cycle_count * 1e-9; // s
                    bw_ifm = (ifm_data_size * 1.0) / time_in_s / 1e9; // GB/s
                    bw_weight = (weight_data_size * 1.0) / time_in_s / 1e9; // GB/s
                    bw_ofm = (NUM_OF_PE * 8 * num_of_tiles * 1.0) / time_in_s / 1e9; // GB/s

                    $fwrite(file_out, "BW IFM: %f GB/s\n", bw_ifm);
                    $fwrite(file_out, "BW Weight: %f GB/s\n", bw_weight);
                    $fwrite(file_out, "BW OFM: %f GB/s\n", bw_ofm);


                    $fclose(file_out); 
                    $finish;
                    end
                if ((t % (weight_data_size/ num_of_tiles) ==0) && t!=0) begin
                    @(negedge clk)
                    for (m = 0; m < NUM_OF_PE; m = m + 1) begin
                        $fwrite(file_out, "%h\n", output_feature[m*8+:8 ]);
                    end
                    -> event_1 ;
                end 

                
                begin
                    if (PE_restart =='b0) begin
                        pixel_index = t % one_chanel_kernel_size ;
                        channel_index = (t/one_chanel_kernel_size) % kernel_filter;
                        tile_index = t/(one_chanel_kernel_size*kernel_filter);
                        t <= t + 1;
                        weight <= fifo_weight[t];
                        
                    end
                end
            end
                cycle_count <= cycle_count + 1;
                for (k = 0; k < NUM_OF_PE; k = k + 1) begin  
                    index =k*one_chanel_kernel_size+(pixel_index) + (chanel_input_size*one_chanel_kernel_size)*(channel_index) + (NUM_OF_PE*one_chanel_kernel_size) * tile_index;
                    input_feature[k*8+:8 ] <= fifo_input[ index ]; 
                    check_point =   index-255*9;       
                end
                
                
                
            // begin
            //     if (t ==(weight_data_size) ) begin
            //         @(negedge clk)
            //         for (m = 0; m < NUM_OF_PE; m = m + 1) begin
            //             $fwrite(file_out, "%h\n", output_feature[m*8+:8 ]);
            //         end
            //         $fclose(file_out);
            //         $finish;
            //     end
            // end
            //weight <= fifo_weight[t];
            //t <= t + 1;
        end
    end

    always @(negedge clk) begin
        if (|valid) begin
           // $fwrite(file_out, "%h\n", output_feature);
        end
    end
endmodule
