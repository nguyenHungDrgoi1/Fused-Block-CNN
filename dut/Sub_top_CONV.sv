module Sub_top_CONV(
    input clk,
    input reset,
    input [6:0] addr,
    input we,
    input [63:0] data_in,
    output [31:0] OFM,
    
    input  wire  [15:0]    PE_en,      
    input  wire  [15:0]       PE_finish, 
    input [19:0] addr_w0,
    input [19:0] addr_w1,
    input [19:0] addr_w2,
    input [19:0] addr_w3,
    input [19:0] addr_w4,
    input [19:0] addr_w5,
    input [19:0] addr_w6,
    input [19:0] addr_w7,
    input [19:0] addr_w8,
    input [19:0] addr_w9,
    input [19:0] addr_w10,
    input [19:0] addr_w11,
    input [19:0] addr_w12,
    input [19:0] addr_w13,
    input [19:0] addr_w14,
    input [19:0] addr_w15,

    output wire [7:0]  OFM_0,
    output wire [7:0]  OFM_1,
    output wire [7:0]  OFM_2,
    output wire [7:0]  OFM_3,
    output wire [7:0]  OFM_4,
    output wire [7:0]  OFM_5,
    output wire [7:0]  OFM_6,
    output wire [7:0]  OFM_7,
    output wire [7:0]  OFM_8,
    output wire [7:0]  OFM_9,
    output wire [7:0]  OFM_10,
    output wire [7:0]  OFM_11,
    output wire [7:0]  OFM_12,
    output wire [7:0]  OFM_13,
    output wire [7:0]  OFM_14,
    output wire [7:0]  OFM_15,
    output wire [7:0]  OFM_16
);
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
    BRAM IFM_BRAM(
        .clk(clk),
        .rd_addr(addr),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(IFM_data)
    );
    BRAM IFM_Weight_0(
        .clk(clk),
        .rd_addr(addr_w0),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_0)
    );
    BRAM IFM_Weight_1(
        .clk(clk),
        .rd_addr(addr_w1),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_1)
    );
    BRAM IFM_Weight_2(
        .clk(clk),
        .rd_addr(addr_w2),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_2)
    );
    BRAM IFM_Weight_3(
        .clk(clk),
        .rd_addr(addr_w3),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_3)
    );
    BRAM IFM_Weight_4(
        .clk(clk),
        .rd_addr(addr_w4),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_4)
    );
    BRAM IFM_Weight_5(
        .clk(clk),
        .rd_addr(addr_w5),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_5)
    );
    BRAM IFM_Weight_6(
        .clk(clk),
        .rd_addr(addr_w6),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_6)
    );
    BRAM IFM_Weight_7(
        .clk(clk),
        .rd_addr(addr_w7),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_7)
    );
    BRAM IFM_Weight_8(
        .clk(clk),
        .rd_addr(addr_w8),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_8)
    );
    BRAM IFM_Weight_9(
        .clk(clk),
        .rd_addr(addr_w9),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_9)
    );
    BRAM IFM_Weight_10(
        .clk(clk),
        .rd_addr(addr_w10),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_10)
    );
    BRAM IFM_Weight_11(
        .clk(clk),
        .rd_addr(addr_w11),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_11)
    );
    BRAM IFM_Weight_12(
        .clk(clk),
        .rd_addr(addr_w12),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_12)
    );
    BRAM IFM_Weight_13(
        .clk(clk),
        .rd_addr(addr_w13),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_13)
    );
    BRAM IFM_Weight_14(
        .clk(clk),
        .rd_addr(addr_w14),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_14)
    );
    BRAM IFM_Weight_15(
        .clk(clk),
        .rd_addr(addr_w15),
        .wr_addr(addr),
        .we(we),
        .data_in(data_in),
        .data_out(Weight_15)
    );
    
    PE_cluster cluster(
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
    
endmodule