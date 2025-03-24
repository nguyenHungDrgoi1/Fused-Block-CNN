`timescale 1ns / 1ps

module BRAM_tb;

    // Khai báo tín hiệu
    reg clk;
    reg we;
    reg [6:0] wr_addr;
    reg [13:0] rd_addr;
    reg [63:0] data_in;
    wire [127:0] data_out;

    // Kết nối module cần kiểm tra
    BRAM uut (
        .clk(clk),
        .we(we),
        .wr_addr(wr_addr),
        .rd_addr(rd_addr),
        .data_in(data_in),
        .data_out(data_out)
    );
    
    // Tạo clock 10ns (100MHz)
    always #5 clk = ~clk;

    initial begin
        // Khởi tạo tín hiệu
        clk = 0;
        we = 0;
        wr_addr = 0;
        rd_addr = 0;
        data_in = 0;

        // Reset
        file = $fopen("data_input.hex", "r");
        if 

        // Ghi dữ liệu vào BRAM
        we = 1;
        wr_addr = 7'd10;   data_in = 64'h123456789ABCDEF0;  #10;  // Ghi vào ô 10
        wr_addr = 7'd11;   data_in = 64'hFEDCBA9876543210;  #10;  // Ghi vào ô 11
        we = 0;

        // Chờ một chút
        #20;

        // Đọc dữ liệu từ BRAM
        rd_addr = 7'd10;  #10;   // Đọc từ ô 10 và 11
        $display("Time %0t: Read Address: %d, Data Out: %h", $time, rd_addr, data_out);

        // Kiểm tra dữ liệu có đúng không
        if (data_out == {64'hFEDCBA9876543210, 64'h123456789ABCDEF0})
            $display("✅ Test Passed: Data matched!");
        else
            $display("❌ Test Failed: Data mismatch!");

        #10;
        $finish;
    end
endmodule
