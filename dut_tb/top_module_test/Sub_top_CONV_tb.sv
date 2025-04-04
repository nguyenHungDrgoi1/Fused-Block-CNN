`timescale 1ns / 1ps
// input 9x9x16
// kernel 3x3x16x32
// OFM 56x56x32

`define GOL1 0

`define IFM_W_para 58
`define IFM_C_para 32
`define KERNEL_W_para 3
`define OFM_C_para 128
`define Stride_para 1

`define OFM_C_layer2_para 128

`define Num_of_PE_para 16

module Sub_top_CONV_tb;

    

    reg clk;
    reg reset;
    reg wr_rd_en_IFM;
    reg wr_rd_en_Weight;
    reg wr_rd_en_Weight_lay2;


    reg [3:0] KERNEL_W;
    reg [7:0] OFM_C;
    reg [7:0] OFM_W;
    reg [7:0] IFM_C;
    reg [7:0] IFM_W;
    reg [1:0] stride;


    reg [31:0] addr, addr_lay2;
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

    reg [31:0] data_in_Weight_0_n_state;
    reg [31:0] data_in_Weight_1_n_state;
    reg [31:0] data_in_Weight_2_n_state;
    reg [31:0] data_in_Weight_3_n_state;

    //reg [1:0] control_mux;
    //reg       wr_en_next;
    reg [31:0] addr_ram_next_rd;
    //reg [31:0] addr_ram_next_wr;

    wire [3:0] PE_finish_PE_cluster1x1_wire;

    //reg [3:0] PE_next_valid;
    int count_for_layer_1 =0 ;
    int count_for_layer_2 =0;
    
    reg [19:0] addr_w[15:0];
    reg [19:0] addr_IFM;
    reg [15:0] PE_reset;
    reg [15:0] PE_finish;
    wire       done_compute;

    reg       run;
    reg [3:0] instrution;
    wire        wr_rd_req_IFM_for_tb;
    wire [31:0] wr_addr_IFM_for_tb;
    wire        wr_rd_req_Weight_for_tb;
    wire [31:0] wr_addr_Weight_for_tb;
    reg [31:0] addr_w_n_state;
    wire [7:0] OFM_n_state [3:0];
    reg [3:0] PE_reset_n_state;
    reg [3:0] PE_reset_n_state_1;

    
    wire [31:0] OFM;
   
    wire [7:0] OFM_out[15:0];
    
    integer i,j,k,m,k1=0;
    integer ofm_file[15:0];  // Mảng để lưu các file handle
    integer ofm_file_2[3:0];
    int link_inital;

    reg [7:0] input_data_mem [0:107648]; // BRAM input data
    reg [7:0] input_data_mem0 [0:2303];
    reg [7:0] input_data_mem1 [0:2303];
    reg [7:0] input_data_mem2 [0:2303];
    reg [7:0] input_data_mem3 [0:2303];
    reg [7:0] input_data_mem4 [0:2303];
    reg [7:0] input_data_mem5 [0:2303];
    reg [7:0] input_data_mem6 [0:2303];
    reg [7:0] input_data_mem7 [0:2303];
    reg [7:0] input_data_mem8 [0:2303];
    reg [7:0] input_data_mem9 [0:2303];
    reg [7:0] input_data_mem10 [0:2303];
    reg [7:0] input_data_mem11 [0:2303];
    reg [7:0] input_data_mem12 [0:2303];
    reg [7:0] input_data_mem13 [0:2303];
    reg [7:0] input_data_mem14 [0:2303];
    reg [7:0] input_data_mem15 [0:2303];

    reg [7:0] input_data_mem0_n_state [0:53823]; // BRAM input data
    reg [7:0] input_data_mem1_n_state [0:2303];
    reg [7:0] input_data_mem2_n_state [0:2303];
    reg [7:0] input_data_mem3_n_state [0:2303];


    reg [31:0] ofm_data;
    reg [31:0] ofm_data_2;
    //CAL START
    reg cal_start;
    wire [15:0] valid ;
    reg [7:0] ofm_data_byte;
    reg [7:0] ofm_data_byte_2;
    int count_valid;
    Sub_top_CONV uut (
        .clk(clk),
        .reset(reset),
        .wr_rd_en_IFM(wr_rd_en_IFM),
        .wr_rd_en_Weight(wr_rd_en_Weight_lay2),
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

        //control signal layer 1
        .PE_reset(PE_reset),
        .PE_finish(PE_finish),
        .PE_finish_PE_cluster1x1(PE_finish_PE_cluster1x1_wire),

        .KERNEL_W(KERNEL_W),
        .OFM_C(OFM_C),
        .OFM_W(OFM_W),
        .IFM_C(IFM_C),
        .IFM_W(IFM_W),
        .stride(stride),
        .valid(valid),
        .done_compute(done_compute),

        //layer2
        .OFM_C_layer2(`OFM_C_layer2_para),

        // for Control_unit
        .run(run),
        .instrution(instrution),
        .wr_rd_req_IFM_for_tb(wr_rd_req_IFM_for_tb),
        .wr_addr_IFM_for_tb(wr_addr_IFM_for_tb),
        .wr_rd_req_Weight_for_tb(wr_rd_req_Weight_for_tb),
        .wr_addr_Weight_for_tb(wr_addr_Weight_for_tb),
        
        
        .OFM_active_0(OFM_out[0]), .OFM_active_1(OFM_out[1]), .OFM_active_2(OFM_out[2]), .OFM_active_3(OFM_out[3]),
        .OFM_active_4(OFM_out[4]), .OFM_active_5(OFM_out[5]), .OFM_active_6(OFM_out[6]), .OFM_active_7(OFM_out[7]),
        .OFM_active_8(OFM_out[8]), .OFM_active_9(OFM_out[9]), .OFM_active_10(OFM_out[10]), .OFM_active_11(OFM_out[11]),
        .OFM_active_12(OFM_out[12]), .OFM_active_13(OFM_out[13]), .OFM_active_14(OFM_out[14]), .OFM_active_15(OFM_out[15]),

        .data_in_Weight_0_n_state(data_in_Weight_0_n_state),    // layer 2
        .data_in_Weight_1_n_state(data_in_Weight_1_n_state),    // layer 2
        .data_in_Weight_2_n_state(data_in_Weight_2_n_state),    // layer 2
        .data_in_Weight_3_n_state(data_in_Weight_3_n_state),    // layer 2
        .control_mux(control_mux),                              // controll  layer1_2

        .PE_reset_n_state(PE_reset_n_state),
       //.addr_w_n_state(addr_w_n_state),
        .OFM_0_n_state(OFM_n_state[0]), .OFM_1_n_state(OFM_n_state[1]), .OFM_2_n_state(OFM_n_state[2]) ,.OFM_3_n_state(OFM_n_state[3])

    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    int input_size = `IFM_W_para*`IFM_W_para*`IFM_C_para;
    int tile = `OFM_C_para/`Num_of_PE_para;
    initial begin
        ////////////////////////////////////LOAD PHASE//////////////////////////////////////////////////
        // Reset phase
        reset       = 0;
        PE_reset    = 0;
        run         =   1;
        #3000
        reset = 1;
        wr_rd_en_IFM = 0;
        wr_rd_en_Weight = 0;
        wr_rd_en_Weight_lay2=0;
        addr = 0;

        KERNEL_W = `KERNEL_W_para ;
        OFM_W = ((`IFM_W_para+ 2*0 -`KERNEL_W_para)/ `Stride_para )+1;
        OFM_C = `OFM_C_para;
        IFM_C = `IFM_C_para;
        IFM_W = `IFM_W_para;


        stride = `Stride_para;

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

        data_in_Weight_0_n_state=0;
        data_in_Weight_1_n_state=0;
        data_in_Weight_2_n_state=0;
        data_in_Weight_3_n_state=0;
        
        //addr_ram_next_wr = -1;
        //wr_en_next = 0;

        // Load input data from file (example: input_data.hex)
       //$readmemh("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/input_56x56x16_pad.hex", input_data_mem);
        //
        if(`GOL1) begin
        $readmemh("../Fused-Block-CNN/address/ifm_padded.hex", input_data_mem);

        $readmemh("../Fused-Block-CNN/address/weight_PE0.hex", input_data_mem0);
        $readmemh("../Fused-Block-CNN/address/weight_PE1.hex", input_data_mem1);
        $readmemh("../Fused-Block-CNN/address/weight_PE2.hex", input_data_mem2);
        $readmemh("../Fused-Block-CNN/address/weight_PE3.hex", input_data_mem3);
        $readmemh("../Fused-Block-CNN/address/weight_PE4.hex", input_data_mem4);
        $readmemh("../Fused-Block-CNN/address/weight_PE5.hex", input_data_mem5);
        $readmemh("../Fused-Block-CNN/address/weight_PE6.hex", input_data_mem6);
        $readmemh("../Fused-Block-CNN/address/weight_PE7.hex", input_data_mem7);
        $readmemh("../Fused-Block-CNN/address/weight_PE8.hex", input_data_mem8);
        $readmemh("../Fused-Block-CNN/address/weight_PE9.hex", input_data_mem9);
        $readmemh("../Fused-Block-CNN/address/weight_PE10.hex", input_data_mem10);
        $readmemh("../Fused-Block-CNN/address/weight_PE11.hex", input_data_mem11);
        $readmemh("../Fused-Block-CNN/address/weight_PE12.hex", input_data_mem12);
        $readmemh("../Fused-Block-CNN/address/weight_PE13.hex", input_data_mem13);
        $readmemh("../Fused-Block-CNN/address/weight_PE14.hex", input_data_mem14);
        $readmemh("../Fused-Block-CNN/address/weight_PE15.hex", input_data_mem15);
        end
        else begin
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/ifm.hex", input_data_mem);

        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE0.hex", input_data_mem0);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE1.hex", input_data_mem1);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE2.hex", input_data_mem2);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE3.hex", input_data_mem3);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE4.hex", input_data_mem4);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE5.hex", input_data_mem5);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE6.hex", input_data_mem6);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE7.hex", input_data_mem7);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE8.hex", input_data_mem8);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE9.hex", input_data_mem9);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE10.hex", input_data_mem10);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE11.hex", input_data_mem11);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE12.hex", input_data_mem12);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE13.hex", input_data_mem13);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE14.hex", input_data_mem14);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1_PE15.hex", input_data_mem15);

        end
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight2_PE0.hex", input_data_mem0_n_state);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight2_PE1.hex", input_data_mem1_n_state);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight2_PE2.hex", input_data_mem2_n_state);
        $readmemh("../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight2_PE3.hex", input_data_mem3_n_state);

        run         =   1;
        instrution  =   1;
        fork
            begin
                // Write data into BRAM
                for (i = 0; i < input_size+1; i = i + 4) begin
                    //addr = i >> 2;  // Chia 4 vì mỗi lần lưu 32-bit
                    data_in_IFM = {input_data_mem[wr_addr_IFM_for_tb*4], input_data_mem[wr_addr_IFM_for_tb*4+1], input_data_mem[wr_addr_IFM_for_tb*4+2], input_data_mem[wr_addr_IFM_for_tb*4+3]};

                    #10;
                end
                wr_rd_en_IFM = 0;
            end
            begin
                for (j = 0; j < IFM_C*KERNEL_W*KERNEL_W*tile +1; j = j + 4) begin

                    addr <= j >> 2;  // Chia 4 vì mỗi lần lưu 32-bit
                    data_in_Weight_0 = {input_data_mem0 [addr*4], input_data_mem0[addr*4+1], input_data_mem0[addr*4+2], input_data_mem0[addr*4+3]};
                    data_in_Weight_1 = {input_data_mem1 [addr*4], input_data_mem1[addr*4+1], input_data_mem1[addr*4+2], input_data_mem1[addr*4+3]};
                    data_in_Weight_2 = {input_data_mem2 [addr*4], input_data_mem2[addr*4+1], input_data_mem2[addr*4+2], input_data_mem2[addr*4+3]};
                    data_in_Weight_3 = {input_data_mem3 [addr*4], input_data_mem3[addr*4+1], input_data_mem3[addr*4+2], input_data_mem3[addr*4+3]};
                    data_in_Weight_4 = {input_data_mem4 [addr*4], input_data_mem4[addr*4+1], input_data_mem4[addr*4+2], input_data_mem4[addr*4+3]};
                    data_in_Weight_5 = {input_data_mem5 [addr*4], input_data_mem5[addr*4+1], input_data_mem5[addr*4+2], input_data_mem5[addr*4+3]};
                    data_in_Weight_6 = {input_data_mem6 [addr*4], input_data_mem6[addr*4+1], input_data_mem6[addr*4+2], input_data_mem6[addr*4+3]};
                    data_in_Weight_7 = {input_data_mem7 [addr*4], input_data_mem7[addr*4+1], input_data_mem7[addr*4+2], input_data_mem7[addr*4+3]};
                    data_in_Weight_8 = {input_data_mem8 [addr*4], input_data_mem8[addr*4+1], input_data_mem8[addr*4+2], input_data_mem8[addr*4+3]};
                    data_in_Weight_9 = {input_data_mem9 [addr*4], input_data_mem9[addr*4+1], input_data_mem9[addr*4+2], input_data_mem9[addr*4+3]};
                    data_in_Weight_10 = {input_data_mem10[addr*4], input_data_mem10[addr*4+1], input_data_mem10[addr*4+2], input_data_mem10[addr*4+3]};
                    data_in_Weight_11 = {input_data_mem11[addr*4], input_data_mem11[addr*4+1], input_data_mem11[addr*4+2], input_data_mem11[addr*4+3]};
                    data_in_Weight_12 = {input_data_mem12[addr*4], input_data_mem12[addr*4+1], input_data_mem12[addr*4+2], input_data_mem12[addr*4+3]};
                    data_in_Weight_13 = {input_data_mem13[addr*4], input_data_mem13[addr*4+1], input_data_mem13[addr*4+2], input_data_mem13[addr*4+3]};
                    data_in_Weight_14 = {input_data_mem14[addr*4], input_data_mem14[addr*4+1], input_data_mem14[addr*4+2], input_data_mem14[addr*4+3]};
                    data_in_Weight_15 = {input_data_mem15[addr*4], input_data_mem15[addr*4+1], input_data_mem15[addr*4+2], input_data_mem15[addr*4+3]};

                    wr_rd_en_Weight = 1;
                    #10;
                end
                wr_rd_en_Weight = 0;
            end
            begin
                for (k = 0; k < IFM_C*KERNEL_W*KERNEL_W*tile +1; k = k + 4) begin

                    addr <= k >> 2;  // Chia 4 vì mỗi lần lưu 32-bit
                    data_in_Weight_0_n_state = {input_data_mem0_n_state[i], input_data_mem0_n_state[i+1], input_data_mem0_n_state[i+2], input_data_mem0_n_state[i+3]};
                    data_in_Weight_1_n_state = {input_data_mem1_n_state[i], input_data_mem1_n_state[i+1], input_data_mem1_n_state[i+2], input_data_mem1_n_state[i+3]};
                    data_in_Weight_2_n_state = {input_data_mem2_n_state[i], input_data_mem2_n_state[i+1], input_data_mem2_n_state[i+2], input_data_mem2_n_state[i+3]};
                    data_in_Weight_3_n_state = {input_data_mem3_n_state[i], input_data_mem3_n_state[i+1], input_data_mem3_n_state[i+2], input_data_mem3_n_state[i+3]};
                    wr_rd_en_Weight_lay2 = 1;
                    #10;
                end
                wr_rd_en_Weight_lay2 = 0;
            end
        join

        @(posedge done_compute);
        PE_finish = 0;
    #100000;
        $finish;
    end
    initial begin
        for (k = 0; k < 16; k = k + 1) begin
            if (`GOL1) ofm_file[k] = $fopen($sformatf("../Fused-Block-CNN/address/OFM_PE%0d_DUT.hex", k), "w");
            else    ofm_file[k] = $fopen($sformatf("../Fused-Block-CNN/golden_out_fused_block/output_hex_folder/OFM1_PE%0d_DUT.hex", k), "w");
            if (ofm_file[k] == 0) begin
                $display("Error opening file OFM_PE%d.hex", k); 
                $finish;  
            end
        end

         for (m = 0; m < 4; m = m + 1) begin
             ofm_file_2[m] = $fopen($sformatf("../Fused-Block-CNN/golden_out_fused_block/output_hex_folder/OFM2_PE%0d_DUT.hex", m), "w");
             if (ofm_file_2[m] == 0) begin
                 $display("Error opening file OFM_PE%d.hex", k);
                 $finish;  
             end
         end
    end
   
    

always @(posedge clk) begin
    if (valid == 16'hFFFF) begin
        // Lưu giá trị OFM vào các file tương ứng
        count_for_layer_1 = count_for_layer_1 + 1;
        for (k = 0; k < 16; k = k + 1) begin
            ofm_data = OFM_out[k];  // Lấy giá trị OFM từ output
            // Ghi từng byte của OFM vào các file
            ofm_data_byte = ofm_data;
            //if (ofm_file[1] != 0) begin
            //$display("check");
                $fwrite(ofm_file[k], "%h\n", ofm_data_byte);  // Ghi giá trị từng byte vào file
                
           // end
            ofm_data = ofm_data >> 8;  // Dịch 8 bit cho đến khi hết 32-bit
        end
    end
end
always @(posedge clk) begin
    if (PE_finish_PE_cluster1x1_wire == 15) begin
        // Lưu giá trị OFM vào các file tương ứng
        count_for_layer_2 = count_for_layer_2 + 1;
        for (k1 = 0; k1 < 4; k1 = k1 + 1) begin
            ofm_data_2 = OFM_n_state[k1];  // Lấy giá trị OFM từ output
            // Ghi từng byte của OFM vào các file
            ofm_data_byte_2 = ofm_data_2;
            //if (ofm_file[1] != 0) begin
            //$display("check");
                $fwrite(ofm_file_2[k1], "%h\n", ofm_data_byte_2);  // Ghi giá trị từng byte vào file
                //$display("check");
                
           // end
            ofm_data_2 = ofm_data_2 >> 8;  // Dịch 8 bit cho đến khi hết 32-bit
        end
    end
end
endmodule