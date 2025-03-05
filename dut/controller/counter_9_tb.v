`timescale 1ns / 1ps

module tb_counter_9;

    // Khai báo tín hiệu testbench
    reg clk;
    reg rst_n;
    wire [3:0] counter;

    // Kết nối với module cần kiểm tra
    counter_9 uut (
        .clk(clk),
        .rst_n(rst_n),
        .counter(counter)
    );

    // Tạo clock 10ns (100MHz)
    always #5 clk = ~clk;

    initial begin
        // Khởi tạo tín hiệu
        clk = 0;
        rst_n = 0;

        // Reset bộ đếm
        #10 rst_n = 1;

        // Chạy 20 chu kỳ để quan sát bộ đếm lặp lại từ 0 -> 8
        #200;

        // Kết thúc mô phỏng
        $finish;
    end

    // Monitor để in giá trị counter
    always @(posedge clk) begin
        $display("Time: %0t | Counter: %0d", $time, counter);
    end
endmodule
