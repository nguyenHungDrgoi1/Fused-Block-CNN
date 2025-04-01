`timescale 1ns / 1ps
// input 58x58x16
// kernel 3x3x16x32
// OFM 56x56x32
module Sub_top_2_CONV_tb;

    int input_size = 58*58*16;
    int weight_size = 3*3*16;
    int tile = 2;

    reg clk;
    reg reset;
    reg wr_rd_en_IFM;
    reg wr_rd_en_Weight;
    reg [31:0] addr;
    reg [31:0] data_in_IFM;
    reg [31:0] data_in_Weight_0;
    reg [31:0] data_in_Weight_1;
    reg [31:0] data_in_Weight_2;
    reg [31:0] data_in_Weight_3;
    reg [31:0] data_in_Weight_4;
    reg [31:0] data_in_Weight_5;
    reg [31:0] data_in_Weight_6;
    reg [31:0] data_in_Weight_7;
    reg [31:0] data_in_Weight_8;
    reg [31:0] data_in_Weight_9;
    reg [31:0] data_in_Weight_10;
    reg [31:0] data_in_Weight_11;
    reg [31:0] data_in_Weight_12;
    reg [31:0] data_in_Weight_13;
    reg [31:0] data_in_Weight_14;
    reg [31:0] data_in_Weight_15;
    reg [19:0] addr_w[15:0];
    reg [19:0] addr_IFM;
    reg [15:0] PE_reset;
    reg [15:0] PE_finish;
    
    wire [31:0] OFM;
   
    wire [7:0] OFM_out[15:0];
    reg wr_en_next;
    reg [31:0] addr_ram_next_rd;
    reg [31:0] addr_ram_next_wr;
    wire [31:0] out_BRAM_CONV;
    reg [1:0] control_mux;
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

    reg [31:0] addr_w_n_state,
    wire [7:0] OFM_1_n_state,
    wire [7:0] OFM_2_n_state,
    wire [7:0] OFM_3_n_state,
    wire [7:0] OFM_4_n_state,
    reg [3:0] PE_reset_n_state


    integer ofm_file[15:0];  // Mảng để lưu các file handle
    integer k;
    reg [31:0] ofm_data;
    //CAL START
    reg cal_start;
    wire [15:0] valid ;
    reg [7:0] ofm_data_byte;

    Sub_top_2_CONV uut (
        .clk(clk),
        .reset(reset),
        .wr_rd_en_IFM(wr_rd_en_IFM),
        .wr_rd_en_Weight(wr_rd_en_Weight),
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
        .addr(addr),
        .cal_start(cal_start),
        // .addr_IFM(addr_IFM),
        //.OFM(OFM_active),
        .PE_reset(PE_reset),
        .PE_finish(PE_finish),
        .valid(valid),
        .wr_en_next(wr_en_next),
        .addr_ram_next_rd(addr_ram_next_rd),
        .addr_ram_next_wr(addr_ram_next_wr),
        .out_BRAM_CONV(out_BRAM_CONV),
        .control_mux(control_mux)
        // .addr_w0(addr_w[0]), .addr_w1(addr_w[1]), .addr_w2(addr_w[2]), .addr_w3(addr_w[3]),
        // .addr_w4(addr_w[4]), .addr_w5(addr_w[5]), .addr_w6(addr_w[6]), .addr_w7(addr_w[7]),
        // .addr_w8(addr_w[8]), .addr_w9(addr_w[9]), .addr_w10(addr_w[10]), .addr_w11(addr_w[11]),
        // .addr_w12(addr_w[12]), .addr_w13(addr_w[13]), .addr_w14(addr_w[14]), .addr_w15(addr_w[15]),
<<<<<<< HEAD
        .OFM_n_CONV_0(OFM_out[0]), .OFM_n_CONV_1(OFM_out[1]), .OFM_n_CONV_2(OFM_out[2]), .OFM_n_CONV_3(OFM_out[3]),
        .OFM_n_CONV_4(OFM_out[4]), .OFM_n_CONV_5(OFM_out[5]), .OFM_n_CONV_6(OFM_out[6]), .OFM_n_CONV_7(OFM_out[7]),
        .OFM_n_CONV_8(OFM_out[8]), .OFM_n_CONV_9(OFM_out[9]), .OFM_n_CONV_10(OFM_out[10]), .OFM_n_CONV_11(OFM_out[11]),
        .addr_w_n_state(addr_w_n_state), .OFM_0_n_state(OFM_0_n_state), .OFM_1_n_state(OFM_1_n_state), .OFM_2_n_state(OFM_2_n_state) ,.OFM_3_n_state(OFM_3_n_state),
        .OFM_n_CONV_12(OFM_out[12]), .OFM_n_CONV_13(OFM_out[13]), .OFM_n_CONV_14(OFM_out[14]), .OFM_n_CONV_15(OFM_out[15])
=======
        // .OFM_n_CONV_0(OFM_out[0]), .OFM_n_CONV_1(OFM_out[1]), .OFM_n_CONV_2(OFM_out[2]), .OFM_n_CONV_3(OFM_out[3]),
        // .OFM_n_CONV_4(OFM_out[4]), .OFM_n_CONV_5(OFM_out[5]), .OFM_n_CONV_6(OFM_out[6]), .OFM_n_CONV_7(OFM_out[7]),
        // .OFM_n_CONV_8(OFM_out[8]), .OFM_n_CONV_9(OFM_out[9]), .OFM_n_CONV_10(OFM_out[10]), .OFM_n_CONV_11(OFM_out[11]),
        // .OFM_n_CONV_12(OFM_out[12]), .OFM_n_CONV_13(OFM_out[13]), .OFM_n_CONV_14(OFM_out[14]), .OFM_n_CONV_15(OFM_out[15])
>>>>>>> 4f388184e78c06bc44d7984633963ff8bcec8287
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        ////////////////////////////////////LOAD PHASE//////////////////////////////////////////////////
        // Reset phase
        reset = 0;
        PE_reset = 0;
        #30
        reset = 1;
        wr_rd_en_IFM = 0;
        wr_rd_en_Weight = 0;
        addr = 0;
        cal_start = 0;
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
        addr_ram_next_rd = 0;
        addr_ram_next_wr = -1;
        wr_en_next = 0;
        // Load input data from file (example: input_data.hex)
       //$readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/../Fused-Block-CNN/address/input_56x56x16_pad.hex", input_data_mem);
        $readmemh("../Fused-Block-CNN/address/ifm.hex", input_data_mem);

        //$readmemh("../Fused-Block-CNN/address/ifm_padded.hex", input_data_mem);

        $readmemh("../Fused-Block-CNN/address/weight_PE0.hex", input_data_mem1);
        $readmemh("../Fused-Block-CNN/address/weight_PE1.hex", input_data_mem2);
        $readmemh("../Fused-Block-CNN/address/weight_PE2.hex", input_data_mem3);
        $readmemh("../Fused-Block-CNN/address/weight_PE3.hex", input_data_mem4);
        $readmemh("../Fused-Block-CNN/address/weight_PE4.hex", input_data_mem5);
        $readmemh("../Fused-Block-CNN/address/weight_PE5.hex", input_data_mem6);
        $readmemh("../Fused-Block-CNN/address/weight_PE6.hex", input_data_mem7);
        $readmemh("../Fused-Block-CNN/address/weight_PE7.hex", input_data_mem8);
        $readmemh("../Fused-Block-CNN/address/weight_PE8.hex", input_data_mem9);
        $readmemh("../Fused-Block-CNN/address/weight_PE9.hex", input_data_mem10);
        $readmemh("../Fused-Block-CNN/address/weight_PE10.hex", input_data_mem11);
        $readmemh("../Fused-Block-CNN/address/weight_PE11.hex", input_data_mem12);
        $readmemh("../Fused-Block-CNN/address/weight_PE12.hex", input_data_mem13);
        $readmemh("../Fused-Block-CNN/address/weight_PE13.hex", input_data_mem14);
        $readmemh("../Fused-Block-CNN/address/weight_PE14.hex", input_data_mem15);
        $readmemh("../Fused-Block-CNN/address/weight_PE15.hex", input_data_mem16);

        //@ ( posedge clk );
        //wait( clk == 1);
        #5
        // Write data into BRAM
        for (i = 0; i < input_size; i = i + 4) begin
            addr = i >> 2;  // Chia 4 vì mỗi lần lưu 32-bit
            data_in_IFM = {input_data_mem[i], input_data_mem[i+1], input_data_mem[i+2], input_data_mem[i+3]};
            wr_rd_en_IFM = 1;
            #10;
        end

        wr_rd_en_IFM = 0;
        for (i = 0; i < 288; i = i + 4) begin

            addr = i >> 2;  // Chia 4 vì mỗi lần lưu 32-bit
            //data_in_IFM = {input_data_mem[i], input_data_mem[i+1], input_data_mem[i+2], input_data_mem[i+3]};
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
            wr_rd_en_Weight = 1;
            #10;
        end
        wr_rd_en_Weight = 0;
    
        #5000;
        #5
        ////////////////////////////////////CAL PHASE//////////////////////////////////////////////////

        cal_start = 1; // ready phari leen o canh duong va sau do it nhat 3 chu ki thi PE_reset ( PE_reset ) phai kich hoat
        #15 // 3 chu ki
        repeat (3000) begin
        //#20
        PE_reset <= 16'hFFFF;
        PE_finish <= 0;
        #10 // one cyvles
        PE_reset <= 16'b0;
        #340 // 36 -2 cyvles for one pixel in OFM = num_of_tiles * kernel_W
        PE_finish <= 16'hFFFF;
        #10;
        end
        PE_finish = 0;
        #10000;
        repeat (10000) begin
            @(posedge clk) begin
            addr_ram_next_rd = addr_ram_next_rd + 4;
            #10;
            end
        end
        $finish;
    end
    initial begin
    // Mở các file hex để lưu OFM (sẽ tạo các file nếu chưa tồn tại)
    for (k = 0; k < 16; k = k + 1) begin
        // Mở file để ghi (nếu file chưa có, sẽ được tạo ra)
         //ofm_file[k]  = $fopen("/home/manhung/Hung/CNN/Fused-Block-CNN/dut/OFM_PE_check.hex", "w");
        ofm_file[k] = $fopen($sformatf("../Fused-Block-CNN/address/OFM_PE%0d_DUT.hex", k), "w");
        if (ofm_file[k] == 0) begin
            $display("Error opening file OFM_PE%d.hex", k); // Nếu không mở được file, in thông báo lỗi
            $finish;  // Dừng mô phỏng nếu không mở được file
        end
    end
end
    initial begin
        forever begin
        @ ( posedge clk ) begin
            if(valid == 16'hFFFF) begin
            //#10
            control_mux <= 0;
            addr_ram_next_wr <= addr_ram_next_wr + 1;
            wr_en_next <= 1;
            @ ( posedge clk )
            control_mux <= 1;
            addr_ram_next_wr <= addr_ram_next_wr + 1;
            @ ( posedge clk )
            control_mux <= 2;
            addr_ram_next_wr <= addr_ram_next_wr + 1;
            @ ( posedge clk )
            control_mux <= 3;
            addr_ram_next_wr <= addr_ram_next_wr + 1;
            @ ( posedge clk ) 
            wr_en_next <= 0;
            end
        end
        end
    end
always @(posedge clk) begin
    if (valid == 16'hFFFF) begin
        // Lưu giá trị OFM vào các file tương ứng
        for (k = 0; k < 16; k = k + 1) begin
            ofm_data = OFM_out[k];  // Lấy giá trị OFM từ output
            // Ghi từng byte của OFM vào các file
            ofm_data_byte = ofm_data;
            //$display("%h",ofm_data);
            //if (ofm_file[1] != 0) begin
            //$display("check");
                $fwrite(ofm_file[k], "%h\n", ofm_data_byte);  // Ghi giá trị từng byte vào file
           // end
            ofm_data = ofm_data >> 8;  // Dịch 8 bit cho đến khi hết 32-bit
        end
    end
end

endmodule