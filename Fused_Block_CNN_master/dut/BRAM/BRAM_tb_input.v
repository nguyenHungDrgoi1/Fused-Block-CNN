`timescale 1ns / 1ps

module tb_BRAM;

    // Kích thước bộ nhớ
    parameter WIDTH = 64;      // 64-bit mỗi phần tử
    parameter DEPTH = 128;     // 128 entries trong BRAM
    parameter BYTES_PER_ENTRY = WIDTH / 8;  // 8 bytes mỗi entry (64-bit)

    // Tín hiệu testbench
    reg clk;
    reg we;
    reg [6:0] wr_addr;
    reg [6:0] rd_addr;
    reg [7:0] data_in_8bit;  // Dữ liệu đầu vào 8-bit từ file
    reg [63:0] data_in;      // Dữ liệu ghép 64-bit để ghi vào BRAM
    wire [63:0] data_out;    // Dữ liệu đọc từ BRAM

    integer file, i, j, scan_result;

    // Kết nối với module BRAM
    BRAM uut (
        .clk(clk),
        .we(we),
        .wr_addr(wr_addr),
        .rd_addr(rd_addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock 10ns (100MHz)
    always #5 clk = ~clk;

    initial begin
        // Khởi tạo tín hiệu
        clk = 0;
        we = 0;
        wr_addr = 0;
        rd_addr = 0;
        data_in = 0;

        // Mở file HEX chứa dữ liệu đầu vào
        file = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/input_7x7x5.hex", "r");
        if (file == 0) begin
            $display("❌ Lỗi: Không thể mở file data_input.hex!");
            $finish;
        end

        // Đọc dữ liệu từ file và ghi vào BRAM
        for (i = 0; i < DEPTH; i = i + 1) begin
            data_in = 0;
            for (j = 0; j < BYTES_PER_ENTRY; j = j + 1) begin
                scan_result = $fscanf(file, "%h\n", data_in_8bit);  // Đọc 8-bit HEX từ file
                if (scan_result == 1) begin
                    data_in = data_in | (data_in_8bit << (j * 8));  // Ghép thành 64-bit
                end
            end
            we = 1;
            wr_addr = i;
            #10;  // Chờ 1 chu kỳ clock để ghi vào BRAM
        end
        we = 0;
        $fclose(file);

        // Đọc lại dữ liệu từ BRAM
        $display("✅ Đọc dữ liệu từ BRAM:");
        for (i = 0; i < DEPTH; i = i + 1) begin
            rd_addr = i;
            #10;
            $display("Addr %3d: Data = %h", rd_addr, data_out);
        end

        // Kết thúc mô phỏng
        #20;
        $finish;
    end

endmodule
