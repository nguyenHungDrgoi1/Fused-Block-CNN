module depthwise_tb();

    parameter input_size = 1024;
    parameter weight_size = 2048;

    reg clk, rst;
    reg [7:0] input_feature;
    reg [7:0] weight;
    wire [15:0] output_feature;
    reg [7:0] fifo_input[input_size - 1 : 0];
    reg [7:0] fifo_weight[weight_size - 1 : 0];
    integer i, file_input, file_weight, file_out;

    always #5 clk = ~clk;

    depthwise dut (
        .input_feature(input_feature),
        .weight(weight),
        .output_feature(output_feature)
    );

    initial begin
        clk = 0;
        input_feature = 0;
        weight = 0;

        // Đọc dữ liệu đầu vào từ file hex
        file_input = $fopen("input.hex", "r");
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

    always @(posedge clk) begin
        if (i < input_size) begin
            input_feature <= fifo_input[i];
            weight <= fifo_weight[i % weight_size];
            i = i + 1;
        end else begin
            $fclose(file_out);
            $finish;
        end
    end

    always @(negedge clk) begin
        $fwrite(file_out, "%h\n", output_feature);
    end
endmodule