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
    wire [15:0] output_feature;

    reg [7:0] fifo_input[input_size - 1 : 0];
    reg [7:0] fifo_weight[weight_size - 1 : 0];
    
    integer file_input, file_weight, file_out, cycle_count;
    integer i = 0;

    always #5 clk = ~clk;

    PE dut (
        .clk(clk),
        .reset_n(rst),
        .IFM(input_feature) ,
        .Weight(weight),
        .OFM(output_feature)
    );

    initial begin
        clk = 0;
        input_feature = 0;
        weight = 0;
        // Đọc dữ liệu đầu vào từ file hex
        file_input = $fopen("input.hex", "r"); // chinh sua duong dan
        file_weight = $fopen("weight.hex", "r");
        file_out = $fopen("output.hex", "w");

        if (file_input && file_weight) begin
            for (i = 0; i < input_size; i = i + 1) begin
                $fscanf(file_input, "%h", fifo_input[i]);
            end
            for (i = 0; i < weight_size; i = i + 1) begin
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
    forever clk = ~clk;
    end
    always @(posedge clk) begin
        if (i < operation) begin
            input_feature <= fifo_input[i];
            weight <= fifo_weight[i];
            cycle_count <= cycle_count + 1;
            i <= i + 1;
        end else begin
            $fclose(file_out);
            $finish;
        end
    end

    always @(negedge clk) begin
        if(cycle_count % weight_size == 0) begin
            $fwrite(file_out, "%h\n", output_feature);
        end
    end
endmodule