module PE_tb();

    parameter kernel_size_1channel = 9; // 3x3
    parameter kernel_channel = 3;
    parameter kernel_filter = 3;
    parameter input_size_1channel = 1024; // 32x32
    parameter input_channel = 3;
    parameter input_size = input_size_1channel * input_channel;
    parameter weight_size = kernel_size_1channel * kernel_channel * kernel_filter;
    parameter operation = input_size * kernel_size_1channel * input_channel;


    reg clk, rst;
    reg [7:0] input_feature;
    reg [7:0] weight;
    wire [7:0] output_feature;
    reg PE_en;
    reg PE_finish;
    wire valid;
    reg [7:0] fifo_input[operation - 1 : 0];
    reg [7:0] fifo_weight[operation - 1 : 0];
    
    integer file_input, file_weight, file_out, cycle_count = 0;
    integer i = 0;
    integer j = 0;
    always #5 clk = ~clk;

    PE dut (
        .clk(clk),
        .reset_n(rst),
        .IFM(input_feature) ,
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
        // Đọc dữ liệu đầu vào từ file hex
        file_input = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/input_DUT.hex", "r"); // chinh sua duong dan
        file_weight = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/weight_DUT.hex", "r");
        file_out = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/output.hex", "w");

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
        //PE_en = 0;
        //#10;
        #15
        PE_en = 1 ;
        #10;
        PE_en = 0;
        #260;
        PE_finish = 1;
        #10
        PE_finish = 0;
        forever begin
        PE_en = 1 ;
        #10;
        PE_en = 0 ;
        #250;
        PE_finish = 1;
        #10
        PE_finish = 0;
        end
    end
    initial begin
    #20;
    forever @(posedge clk) begin
        if (j < operation) begin
            input_feature <= fifo_input[j];
            weight <= fifo_weight[j];
            cycle_count <= cycle_count + 1;
            j <= j + 1;
        end else begin
            $fclose(file_out);
            $finish;
        end
    end
    end
    always @(negedge clk) begin
        if(valid == 1) begin
            $fwrite(file_out, "%h\n", output_feature);
        end
    end
endmodule