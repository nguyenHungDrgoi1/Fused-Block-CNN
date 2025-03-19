`timescale 1ns/1ps

module PE_cluster_tb;
    // Khai báo tín hiệu testbench
    reg clk;
    reg reset_n;
    reg [31:0] Weight [0:15];
    reg [31:0] IFM;
    reg [15:0] PE_en;
    reg [15:0] PE_finish;
    
    wire [7:0] OFM [0:15];
    wire [15:0] valid;
            int i;
    // Instance của DUT (Device Under Test)
    PE_cluster uut (
        .clk(clk),
        .reset_n(reset_n),
        .Weight_0(Weight[0]), .Weight_1(Weight[1]), .Weight_2(Weight[2]), .Weight_3(Weight[3]),
        .Weight_4(Weight[4]), .Weight_5(Weight[5]), .Weight_6(Weight[6]), .Weight_7(Weight[7]),
        .Weight_8(Weight[8]), .Weight_9(Weight[9]), .Weight_10(Weight[10]), .Weight_11(Weight[11]),
        .Weight_12(Weight[12]), .Weight_13(Weight[13]), .Weight_14(Weight[14]), .Weight_15(Weight[15]),
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
        #10;
        PE_en = 16'h0;
        reset_n = 1;
        PE_finish = 16'h0000;
        IFM = 32'h01020304;
        for(i = 0 ; i< 16 ; i++) begin
            Weight[i] = i;
        end
        #10000;
    $finish();
        //int i;
        // Khởi tạo trọng số
    end
    // Monitor các tín hiệu đầu ra
    initial begin
        $monitor("Time: %t | OFM: %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h", 
                 $time, OFM[0], OFM[1], OFM[2], OFM[3], OFM[4], OFM[5], OFM[6], OFM[7],
                 OFM[8], OFM[9], OFM[10], OFM[11], OFM[12], OFM[13], OFM[14], OFM[15]);
    end
endmodule
