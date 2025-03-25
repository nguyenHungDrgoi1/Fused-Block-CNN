module Sub_top_CONV(
    input clk,
    input reset,
    input [31:0] addr,
    input we_IFM,
    input we_weight,
    input cal_start,
    input [31:0] data_in_IFM,
    input [31:0] data_in_Weight_0,
    input [31:0] data_in_Weight_1,
    input [31:0] data_in_Weight_2,
    input [31:0] data_in_Weight_3,
    input [31:0] data_in_Weight_4,
    input [31:0] data_in_Weight_5,
    input [31:0] data_in_Weight_6,
    input [31:0] data_in_Weight_7,
    input [31:0] data_in_Weight_8,
    input [31:0] data_in_Weight_9,
    input [31:0] data_in_Weight_10,
    input [31:0] data_in_Weight_11,
    input [31:0] data_in_Weight_12,
    input [31:0] data_in_Weight_13,
    input [31:0] data_in_Weight_14,
    input [31:0] data_in_Weight_15,

    //control signal 
    input wire [15:0] PE_reset,
    input wire [15:0] PE_finish,
    output wire [15:0] valid,
    //output wire [15:0] done_window,
    

    output [31:0] OFM,


    output wire [7:0]  OFM_active_0,
    output wire [7:0]  OFM_active_1,
    output wire [7:0]  OFM_active_2,
    output wire [7:0]  OFM_active_3,
    output wire [7:0]  OFM_active_4,
    output wire [7:0]  OFM_active_5,
    output wire [7:0]  OFM_active_6,
    output wire [7:0]  OFM_active_7,
    output wire [7:0]  OFM_active_8,
    output wire [7:0]  OFM_active_9,
    output wire [7:0]  OFM_active_10,
    output wire [7:0]  OFM_active_11,
    output wire [7:0]  OFM_active_12,
    output wire [7:0]  OFM_active_13,
    output wire [7:0]  OFM_active_14,
    output wire [7:0]  OFM_active_15,
    output wire [7:0]  OFM_active_16
);
    wire [7:0]  OFM_0,
    wire [7:0]  OFM_1,
    wire [7:0]  OFM_3,
    wire [7:0]  OFM_4,
    wire [7:0]  OFM_5,
    wire [7:0]  OFM_2,
    wire [7:0]  OFM_6,
    wire [7:0]  OFM_7,
    wire [7:0]  OFM_8,
    wire [7:0]  OFM_9,
    wire [7:0]  OFM_10,
    wire [7:0]  OFM_11,
    wire [7:0]  OFM_12,
    wire [7:0]  OFM_13,
    wire [7:0]  OFM_14,
    wire [7:0]  OFM_15,
    wire [7:0]  OFM_16
    logic [31:0] addr_IFM;
    logic [19:0] addr_w;
    logic [31:0] IFM_data;
    logic [31:0] Weight_0;
    logic [31:0] Weight_1;
    logic [31:0] Weight_2;
    logic [31:0] Weight_3;
    logic [31:0] Weight_4;
    logic [31:0] Weight_5;
    logic [31:0] Weight_6;
    logic [31:0] Weight_7;
    logic [31:0] Weight_8;
    logic [31:0] Weight_9;
    logic [31:0] Weight_10;
    logic [31:0] Weight_11;
    logic [31:0] Weight_12;
    logic [31:0] Weight_13;
    logic [31:0] Weight_14;
    logic [31:0] Weight_15;
    wire [15:0] done_window_for_PE_cluster;
    wire        done_window_one_bit;
    BRAM_IFM IFM_BRAM(
        .clk(clk),
        .rd_addr(addr_IFM),
        .wr_addr(addr),
        .we(we_IFM),
        .data_in(data_in_IFM),
        .data_out(IFM_data)
    );
    BRAM IFM_Weight_0(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_0),
        .data_out(Weight_0)
    );
    BRAM IFM_Weight_1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_1),
        .data_out(Weight_1)
    );
    BRAM IFM_Weight_2(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_2),
        .data_out(Weight_2)
    );
    BRAM IFM_Weight_3(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_3),
        .data_out(Weight_3)
    );
    BRAM IFM_Weight_4(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_4),
        .data_out(Weight_4)
    );
    BRAM IFM_Weight_5(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_5),
        .data_out(Weight_5)
    );
    BRAM IFM_Weight_6(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_6),
        .data_out(Weight_6)
    );
    BRAM IFM_Weight_7(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_7),
        .data_out(Weight_7)
    );
    BRAM IFM_Weight_8(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_8),
        .data_out(Weight_8)
    );
    BRAM IFM_Weight_9(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_9),
        .data_out(Weight_9)
    );
    BRAM IFM_Weight_10(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_10),
        .data_out(Weight_10)
    );
    BRAM IFM_Weight_11(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_11),
        .data_out(Weight_11)
    );
    BRAM IFM_Weight_12(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_12),
        .data_out(Weight_12)
    );
    BRAM IFM_Weight_13(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_13),
        .data_out(Weight_13)
    );
    BRAM IFM_Weight_14(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_14),
        .data_out(Weight_14)
    );
    BRAM IFM_Weight_15(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(addr),
        .we(we_weight),
        .data_in(data_in_Weight_15),
        .data_out(Weight_15)
    );
    
    PE_cluster cluster(
        .clk(clk),
        .reset_n(reset),
        .PE_reset(PE_reset),
        .PE_finish(PE_finish),
        .valid(valid),
        .IFM(IFM_data),
        .Weight_0(Weight_0),
        .Weight_1(Weight_1),
        .Weight_2(Weight_2),
        .Weight_3(Weight_3),
        .Weight_4(Weight_4),
        .Weight_5(Weight_5),
        .Weight_6(Weight_6),
        .Weight_7(Weight_7),
        .Weight_8(Weight_8),
        .Weight_9(Weight_9),
        .Weight_10(Weight_10),
        .Weight_11(Weight_11),
        .Weight_12(Weight_12),
        .Weight_13(Weight_13),
        .Weight_14(Weight_14),
        .Weight_15(Weight_15),
        .OFM_0(OFM_0),
        .OFM_1(OFM_1),
        .OFM_2(OFM_2),
        .OFM_3(OFM_3),
        .OFM_4(OFM_4),
        .OFM_5(OFM_5),
        .OFM_6(OFM_6),
        .OFM_7(OFM_7),
        .OFM_8(OFM_8),
        .OFM_9(OFM_9),
        .OFM_10(OFM_10),
        .OFM_11(OFM_11),
        .OFM_12(OFM_12),
        .OFM_13(OFM_13),
        .OFM_14(OFM_14),
        .OFM_15(OFM_15)

    );
    
    ReLu6 active0(
        .OFM(OFM_0),
        OFM_active(OFM_active_0)
    );
    ReLu6 active1(
        .OFM(OFM_1),
        OFM_active(OFM_active_1)
    );
    ReLu6 active2(
        .OFM(OFM_2),
        OFM_active(OFM_active_2)
    );
    ReLu6 active3(
        .OFM(OFM_0),
        OFM_active(OFM_active_3)
    );
    ReLu6 active4(
        .OFM(OFM_4),
        OFM_active(OFM_active_4)
    );
    ReLu6 active5(
        .OFM(OFM_0),
        OFM_active(OFM_active_5)
    );
    ReLu6 active6(
        .OFM(OFM_6),
        OFM_active(OFM_active_6)
    );
    ReLu6 active7(
        .OFM(OFM_7),
        OFM_active(OFM_active_7)
    );
    ReLu6 active8(
        .OFM(OFM_8),
        OFM_active(OFM_active_8)
    );
    ReLu6 active9(
        .OFM(OFM_9),
        OFM_active(OFM_active_9)
    );
    ReLu6 active10(
        .OFM(OFM_10),
        OFM_active(OFM_active_10)
    );
    ReLu6 active11(
        .OFM(OFM_11),
        OFM_active(OFM_active_11)
    );
    ReLu6 active12(
        .OFM(OFM_12),
        OFM_active(OFM_active_12)
    );
    ReLu6 active13(
        .OFM(OFM_13),
        OFM_active(OFM_active_13)
    );
    ReLu6 active14(
        .OFM(OFM_14),
        OFM_active(OFM_active_14)
    );
    ReLu6 active15(
        .OFM(OFM_15),
        OFM_active(OFM_active_14)
    );
    
    address_generator addr_gen(
        .clk(clk),
        .rst_n(reset),
        .KERNEL_W(3),
        .OFM_W(54),
        .OFM_C(32),
        .IFM_C(16),
        .IFM_W(56),
        .stride(1),
        .ready(cal_start),
        .addr_in(0),
        .req_addr_out_filter(addr_w),
        .req_addr_out_ifm(addr_IFM),
        .done_window(done_window_one_bit)
    );
    assign done_window_for_PE_cluster = {16{done_window_one_bit}};
endmodule