`timescale 1ns/1ps

module new_PE_tb;
    // Tín hiệu điều khiển
    reg clk;
    reg reset_n;
    reg PE_en;
    reg PE_finish;

    // Tín hiệu dữ liệu
    reg  [7:0] IFM1, IFM2, IFM3;
    reg  [7:0] Weight1, Weight2, Weight3;
    wire [7:0] OFM;
    wire       valid;

    // Khởi tạo module PE
    new_PE uut (
        .clk      (clk),
        .reset_n  (reset_n),
        .IFM1     (IFM1),
        .IFM2     (IFM2),
        .IFM3     (IFM3),
        .Weight1  (Weight1),
        .Weight2  (Weight2),
        .Weight3  (Weight3),
        .PE_en    (PE_en),
        .PE_finish(PE_finish),
        .OFM      (OFM),
        .valid    (valid)
    );

    // ---- Tạo clock ----
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Chu kỳ clock = 10 ns
    end

    // ---- Kịch bản mô phỏng ----
    initial begin
        // Ban đầu reset active (0), PE_en = 0, PE_finish = 0, dữ liệu = 0
        reset_n   = 0;
        PE_en     = 0;
        PE_finish = 0;
        IFM1 = 0; IFM2 = 0; IFM3 = 0;
        Weight1 = 0; Weight2 = 0; Weight3 = 0;

        // Sau 20 ns thả reset
        #20;
        reset_n = 1;

        // Chờ thêm 20 ns để mạch ổn định
        #20;

        // --- Test Case 1 ---
        // Bắt đầu 1 “lượt” tính (set PE_en=1 để reset sum_q=0 bên trong)
        PE_en = 1;
        #10;
        PE_en = 0;  // tắt enable => mạch bắt đầu cộng dồn (accumulate)

        // Gán dữ liệu đầu vào
        IFM1 = 8'd3;  Weight1 = 8'd2;
        IFM2 = 8'd4;  Weight2 = 8'd1;
        IFM3 = 8'd5;  Weight3 = 8'd3;
        #50;  // đợi vài chu kỳ để mạch nhân + cộng dồn

        // --- Test Case 2 ---
        IFM1 = 8'd1;  Weight1 = 8'd2;
        IFM2 = 8'd2;  Weight2 = 8'd3;
        IFM3 = 8'd3;  Weight3 = 8'd1;
        #50;

        // Ra tín hiệu PE_finish => valid=1 trong 1 chu kỳ
        PE_finish = 1;
        #10;
        PE_finish = 0;
        #30;

        // --- Test Case 3: Tiếp tục 1 lượt mới ---
        PE_en = 1;
        #10;
        PE_en = 0;

        IFM1 = 8'd10; Weight1 = 8'd1;
        IFM2 = 8'd20; Weight2 = 8'd1;
        IFM3 = 8'd30; Weight3 = 8'd1;
        #50;

        // Lại báo finish
        PE_finish = 1;
        #10;
        PE_finish = 0;

        // Dừng mô phỏng
        #50;
        $stop;
    end

    // ---- In ra kết quả mỗi chu kỳ ----
    initial begin
        $monitor("Time=%0t | IFM1=%d Weight1=%d | IFM2=%d Weight2=%d | IFM3=%d Weight3=%d | OFM=%d | valid=%b",
                  $time, IFM1, Weight1, IFM2, Weight2, IFM3, Weight3, OFM, valid);
    end

endmodule
