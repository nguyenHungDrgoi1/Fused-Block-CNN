`timescale 1ns/1ps

module PE_cluster_tb;
    // Khai báo tín hiệu testbench
    reg clk;
    reg reset_n;
    reg [31:0] Weigh [0:15];
    reg [31:0] IFM;
    reg [15:0] PE_en;
    reg [15:0] PE_finish;
    
    wire [7:0] OFM [0:15];
    wire [15:0] valid;

    // Instance của DUT (Device Under Test)
    PE_cluster uut (
        .clk(clk),
        .reset_n(reset_n),
        .Weigh_0(Weigh[0]), .Weigh_1(Weigh[1]), .Weigh_2(Weigh[2]), .Weigh_3(Weigh[3]),
        .Weigh_4(Weigh[4]), .Weigh_5(Weigh[5]), .Weigh_6(Weigh[6]), .Weigh_7(Weigh[7]),
        .Weigh_8(Weigh[8]), .Weigh_9(Weigh[9]), .Weigh_10(Weigh[10]), .Weigh_11(Weigh[11]),
        .Weigh_12(Weigh[12]), .Weigh_13(Weigh[13]), .Weigh_14(Weigh[14]), .Weigh_15(Weigh[15]),
        .IFM(IFM),
        .PE_en(PE_en),
        .PE_finish(PE_finish),
        .OFM_0(OFM[0]), .OFM_1(OFM[1]), .OFM_2(OFM[2]), .OFM_3(OFM[3]),
        .OFM_4(OFM[4]), .OFM_5(OFM[5]), .OFM_6(OFM[6]), .OFM_7(OFM[7]),
        .OFM_8(OFM[8]), .OFM_9(OFM[9]), .OFM_10(OFM[10]), .OFM_11(OFM[11]),
        .OFM_12(OFM[12]), .OFM_13(OFM[13]), .OFM_14(OFM[14]), .OFM_15(OFM[15]),
        .valid(valid)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Testbench logic
    initial begin
        // Khởi tạo tín hiệu
        clk = 0;
        reset_n = 0;
        PE_en = 16'hFFFF;
        PE_finish = 16'h0000;
        IFM = 32'h01020304;
        
        // Khởi tạo trọng số
        integer i;
        for (i = 0; i < 16; i = i + 1) begin
            Weigh[i] = 32'h11111111 * i;
        end

        // Reset hệ thống
        #10 reset_n = 1;

        // Chạy thử nghiệm với một số trường hợp
        #20;
        IFM = 32'h05060708;
        PE_en = 16'hAAAA; // Chỉ kích hoạt một số PE
        #20;
        IFM = 32'h0A0B0C0D;
        PE_en = 16'h5555;
        #20;
        PE_finish = 16'hFFFF; // Đánh dấu hoàn thành

        // Kết thúc mô phỏng
        #50;
        $stop;
    end

    // Monitor các tín hiệu đầu ra
    initial begin
        $monitor("Time: %t | OFM: %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h", 
                 $time, OFM[0], OFM[1], OFM[2], OFM[3], OFM[4], OFM[5], OFM[6], OFM[7],
                 OFM[8], OFM[9], OFM[10], OFM[11], OFM[12], OFM[13], OFM[14], OFM[15]);
    end
endmodule
