`timescale 1ns / 1ps

module Quad_PE_tb;
    // Tín hiệu testbench
    reg clk;
    reg reset_n;
    reg [7:0] IFM1, IFM2, IFM3, IFM4;
    reg [7:0] Weight1, Weight2, Weight3, Weight4;
    reg PE_en;
    reg PE_finish;
    wire [7:0] OFM;
    wire valid;

    // Khởi tạo DUT (Device Under Test)
    Quad_PE uut (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM1), .IFM2(IFM2), .IFM3(IFM3), .IFM4(IFM4),
        .Weight1(Weight1), .Weight2(Weight2), .Weight3(Weight3), .Weight4(Weight4),
        .PE_en(PE_en),
        .PE_finish(PE_finish),
        .OFM(OFM),
        .valid(valid)
    );

    // Tạo xung clock
    always #5 clk = ~clk;

    initial begin
        // Khởi tạo tín hiệu
        clk = 0;
        reset_n = 0;
        PE_en = 0;
        PE_finish = 0;
        IFM1 = 0; IFM2 = 0; IFM3 = 0; IFM4 = 0;
        Weight1 = 0; Weight2 = 0; Weight3 = 0; Weight4 = 0;
        
        // Reset hệ thống
        #10 reset_n = 1;
        
        // Cấu hình dữ liệu đầu vào
        #10;
        IFM1 = 8'd2; IFM2 = 8'd3; IFM3 = 8'd4; IFM4 = 8'd5;
        Weight1 = 8'd1; Weight2 = 8'd2; Weight3 = 8'd3; Weight4 = 8'd4;
        PE_en = 1;
        
        // Chạy quá trình tính toán
        #10 PE_en = 0;
        
        // Chờ vài chu kỳ và kiểm tra kết quả
        #20 PE_finish = 1;
        #10 PE_finish = 0;
        
        // Kiểm tra thêm trường hợp khác
        #20;
        IFM1 = 8'd10; IFM2 = 8'd20; IFM3 = 8'd30; IFM4 = 8'd40;
        Weight1 = 8'd1; Weight2 = 8'd1; Weight3 = 8'd1; Weight4 = 8'd1;
        PE_en = 1;
        
        #10 PE_en = 0;
        #20 PE_finish = 1;
        #10 PE_finish = 0;

        // Kết thúc mô phỏng
        #50;
        $finish;
    end

    // Theo dõi tín hiệu
    initial begin
        $dumpfile("Quad_PE_tb.vcd");
        $dumpvars(0, Quad_PE_tb);
        $monitor("Time=%0t | OFM=%d | valid=%b", $time, OFM, valid);
    end
endmodule