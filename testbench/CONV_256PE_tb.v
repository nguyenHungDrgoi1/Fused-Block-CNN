module CONV_256PE_tb();
    parameter NUM_OF_PE = 256;
    parameter kernel_size_1channel = 9; // 3x3
    parameter kernel_channel = 3;
    parameter kernel_filter = 3;
    parameter input_size_1channel = 1024; // 32x32
    parameter input_channel = 3;
    parameter input_size = input_size_1channel * input_channel;
    parameter kernel_size = kernel_size_1channel * kernel_channel * kernel_filter;
    parameter operation = input_size * kernel_size_1channel * input_channel;

    reg clk, rst;
    reg [256*8-1:0] input_feature;
    reg [7:0] weight;
    wire [256*8-1:0] output_feature;
    reg [NUM_OF_PE - 1: 0] PE_en;
    reg [NUM_OF_PE - 1 : 0] PE_finish;
    wire [NUM_OF_PE - 1:0] valid;
    reg [7:0] fifo_input[operation - 1 : 0];
    reg [7:0] fifo_weight[operation - 1 : 0];
    
    integer file_input, file_weight, file_out, cycle_count = 0;
    integer i = 0;
    integer j = 0;
    integer k = 0;
    integer h = 0;
    integer m = 0;
    always #5 clk = ~clk;

    CONV_256PE dut (
        .clk(clk),
        .reset_n(rst),
        .IFM(input_feature),
        .Weight(weight),
        .OFM(output_feature),
        .PE_en(PE_en),
        .PE_finish(PE_finish),
        .valid(valid)
    );

    initial begin
        clk = 0;
        input_feature = 0;
        weight = 0;
        PE_en = 0;
        PE_finish = 0;
        
        file_input = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/input_DUT.hex", "r");
        file_weight = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/weight_DUT.hex", "r");
        file_out = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/output.hex", "w");
        //in-out-weight/input_32x32_DUT.hex

        if (file_input && file_weight) begin
            for (i = 0; i < operation; i = i + 1) begin
                $fscanf(file_input, "%h", fifo_input[i]);
            end
            for (i = 0; i < operation; i = i + 1) begin
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
            PE_en = {NUM_OF_PE{1'b1}};
            #10;
            PE_en = {NUM_OF_PE{1'b0}};
            #260;
            PE_finish = {NUM_OF_PE{1'b1}};
            #10;
            PE_finish = {NUM_OF_PE{1'b0}};
        end
    end

    initial begin
        #20;
        forever @(posedge clk) begin
            for (h = 0; h < input_size / NUM_OF_PE; h = h + 1)begin
                if (j < kernel_size_1channel * kernel_channel) begin
                    for (k = 0; k < NUM_OF_PE; k = k + 1) begin

                    input_feature[k*8+:8 ] <= fifo_input[kernel_size_1channel * kernel_channel * NUM_OF_PE * h + k * kernel_size_1channel * kernel_channel + j];
                    end
                    weight <= fifo_weight[j];
                    cycle_count <= cycle_count + 1;
                    j <= j + 1;
                end else begin
                    if (j % (kernel_size_1channel * kernel_channel) == 0) begin
                        #5;
                        j = 0;
                        for (m = 0; m < NUM_OF_PE; m = m + 1) begin
                            $fwrite(file_out, "%h\n", output_feature[m*8+:8 ]);
                        end
                    end
                end
                if ( cycle_count == (input_size / NUM_OF_PE ) * kernel_channel * kernel_size_1channel - 1) begin
                    $fclose(file_out);
                    $finish;
                end
            end
        end
    end

    always @(negedge clk) begin
        if (|valid) begin
           // $fwrite(file_out, "%h\n", output_feature);
        end
    end
endmodule
