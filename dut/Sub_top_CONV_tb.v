`timescale 1ns / 1ps

module Sub_top_CONV_tb;
    reg clk;
    reg reset;
    reg we;
    reg [6:0] addr;
    reg [63:0] data_in_IFM;
    reg [63:0] data_in_Weight_0;
    reg [63:0] data_in_Weight_1;
    reg [63:0] data_in_Weight_2;
    reg [63:0] data_in_Weight_3;
    reg [63:0] data_in_Weight_4;
    reg [63:0] data_in_Weight_5;
    reg [63:0] data_in_Weight_6;
    reg [63:0] data_in_Weight_7;
    reg [63:0] data_in_Weight_8;
    reg [63:0] data_in_Weight_9;
    reg [63:0] data_in_Weight_10;
    reg [63:0] data_in_Weight_11;
    reg [63:0] data_in_Weight_12;
    reg [63:0] data_in_Weight_13;
    reg [63:0] data_in_Weight_14;
    reg [63:0] data_in_Weight_15;

    reg [19:0] addr_w[15:0];
    reg [15:0] PE_en;
    reg [15:0] PE_finish;
    
    wire [31:0] OFM;
    wire [7:0] OFM_out[15:0];
    
    integer i;
    reg [7:0] input_data_mem [0:53823]; // BRAM input data
    reg [7:0] input_data_mem1 [0:287];
    reg [7:0] input_data_mem2 [0:287];
    reg [7:0] input_data_mem3 [0:287];
    reg [7:0] input_data_mem4 [0:287];
    reg [7:0] input_data_mem5 [0:287];
    reg [7:0] input_data_mem6 [0:287];
    reg [7:0] input_data_mem7 [0:287];
    reg [7:0] input_data_mem8 [0:287];
    reg [7:0] input_data_mem9 [0:287];
    reg [7:0] input_data_mem10 [0:287];
    reg [7:0] input_data_mem11 [0:287];
    reg [7:0] input_data_mem12 [0:287];
    reg [7:0] input_data_mem13 [0:287];
    reg [7:0] input_data_mem14 [0:287];
    reg [7:0] input_data_mem15 [0:287];
    reg [7:0] input_data_mem16 [0:287];
    Sub_top_CONV uut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .we(we),
        .data_in_IFM(data_in_IFM),
        .data_in_Weight_0(data_in_Weight_0),
        .data_in_Weight_1(data_in_Weight_1),
        .data_in_Weight_2(data_in_Weight_2),
        .data_in_Weight_3(data_in_Weight_3),
        .data_in_Weight_4(data_in_Weight_4),
        .data_in_Weight_5(data_in_Weight_5),
        .data_in_Weight_6(data_in_Weight_6),
        .data_in_Weight_7(data_in_Weight_7),
        .data_in_Weight_8(data_in_Weight_8),
        .data_in_Weight_9(data_in_Weight_9),
        .data_in_Weight_10(data_in_Weight_10),
        .data_in_Weight_11(data_in_Weight_11),
        .data_in_Weight_12(data_in_Weight_12),
        .data_in_Weight_13(data_in_Weight_13),
        .data_in_Weight_14(data_in_Weight_14),
        .data_in_Weight_15(data_in_Weight_15),
        .OFM(OFM),
        .PE_en(PE_en),
        .PE_finish(PE_finish),
        .addr_w0(addr_w[0]), .addr_w1(addr_w[1]), .addr_w2(addr_w[2]), .addr_w3(addr_w[3]),
        .addr_w4(addr_w[4]), .addr_w5(addr_w[5]), .addr_w6(addr_w[6]), .addr_w7(addr_w[7]),
        .addr_w8(addr_w[8]), .addr_w9(addr_w[9]), .addr_w10(addr_w[10]), .addr_w11(addr_w[11]),
        .addr_w12(addr_w[12]), .addr_w13(addr_w[13]), .addr_w14(addr_w[14]), .addr_w15(addr_w[15]),
        .OFM_0(OFM_out[0]), .OFM_1(OFM_out[1]), .OFM_2(OFM_out[2]), .OFM_3(OFM_out[3]),
        .OFM_4(OFM_out[4]), .OFM_5(OFM_out[5]), .OFM_6(OFM_out[6]), .OFM_7(OFM_out[7]),
        .OFM_8(OFM_out[8]), .OFM_9(OFM_out[9]), .OFM_10(OFM_out[10]), .OFM_11(OFM_out[11]),
        .OFM_12(OFM_out[12]), .OFM_13(OFM_out[13]), .OFM_14(OFM_out[14]), .OFM_15(OFM_out[15])
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        // Reset phase
        reset = 1;
        we = 0;
        addr = 0;
        data_in_IFM = 0;
        data_in_Weight_0 = 0;
        data_in_Weight_1 = 0;
        data_in_Weight_2 = 0;
        data_in_Weight_3 = 0;
        data_in_Weight_4 = 0;
        data_in_Weight_5 = 0;
        data_in_Weight_6 = 0;
        data_in_Weight_7 = 0;
        data_in_Weight_8 = 0;
        data_in_Weight_9 = 0;
        data_in_Weight_10 = 0;
        data_in_Weight_11 = 0;
        data_in_Weight_12 = 0;
        data_in_Weight_13 = 0;
        data_in_Weight_14 = 0;
        data_in_Weight_15 = 0;
        #20 reset = 0;
        
        // Load input data from file (example: input_data.hex)
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/input_56x56x16_pad.hex", input_data_mem);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE0.hex", input_data_mem1);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE1.hex", input_data_mem2);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE2.hex", input_data_mem3);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE3.hex", input_data_mem4);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE4.hex", input_data_mem5);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE5.hex", input_data_mem6);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE6.hex", input_data_mem7);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE7.hex", input_data_mem8);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE8.hex", input_data_mem9);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE9.hex", input_data_mem10);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE10.hex", input_data_mem11);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE11.hex", input_data_mem12);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE12.hex", input_data_mem13);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE13.hex", input_data_mem14);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE14.hex", input_data_mem15);
        $readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE15.hex", input_data_mem16);

        
        
        // Write data into BRAM
        for (i = 0; i < 50176; i = i + 4) begin
            addr = i >> 2;  // Chia 4 vì mỗi lần lưu 32-bit
            data_in_IFM = {input_data_mem[i], input_data_mem[i+1], input_data_mem[i+2], input_data_mem[i+3]};
            data_in_Weight_0 = {input_data_mem1[i], input_data_mem1[i+1], input_data_mem1[i+2], input_data_mem1[i+3]};
            data_in_Weight_1 = {input_data_mem2[i], input_data_mem2[i+1], input_data_mem2[i+2], input_data_mem2[i+3]};
            data_in_Weight_2 = {input_data_mem3[i], input_data_mem3[i+1], input_data_mem3[i+2], input_data_mem3[i+3]};
            data_in_Weight_3 = {input_data_mem4[i], input_data_mem4[i+1], input_data_mem4[i+2], input_data_mem4[i+3]};
            data_in_Weight_4 = {input_data_mem5[i], input_data_mem5[i+1], input_data_mem5[i+2], input_data_mem5[i+3]};
            data_in_Weight_5 = {input_data_mem6[i], input_data_mem6[i+1], input_data_mem6[i+2], input_data_mem6[i+3]};
            data_in_Weight_6 = {input_data_mem7[i], input_data_mem7[i+1], input_data_mem7[i+2], input_data_mem7[i+3]};
            data_in_Weight_7 = {input_data_mem8[i], input_data_mem8[i+1], input_data_mem8[i+2], input_data_mem8[i+3]};
            data_in_Weight_8 = {input_data_mem9[i], input_data_mem9[i+1], input_data_mem9[i+2], input_data_mem9[i+3]};
            data_in_Weight_9 = {input_data_mem10[i], input_data_mem10[i+1], input_data_mem10[i+2], input_data_mem10[i+3]};
            data_in_Weight_10 = {input_data_mem11[i], input_data_mem11[i+1], input_data_mem11[i+2], input_data_mem11[i+3]};
            data_in_Weight_11 = {input_data_mem12[i], input_data_mem12[i+1], input_data_mem12[i+2], input_data_mem12[i+3]};
            data_in_Weight_12 = {input_data_mem13[i], input_data_mem13[i+1], input_data_mem13[i+2], input_data_mem13[i+3]};
            data_in_Weight_13 = {input_data_mem14[i], input_data_mem14[i+1], input_data_mem14[i+2], input_data_mem14[i+3]};
            data_in_Weight_14 = {input_data_mem15[i], input_data_mem15[i+1], input_data_mem15[i+2], input_data_mem15[i+3]};
            data_in_Weight_15 = {input_data_mem16[i], input_data_mem16[i+1], input_data_mem16[i+2], input_data_mem16[i+3]};
            we = 1;
            #10;
        end
    
        we = 0;
        #50;
        
        $stop;
    end

endmodule
