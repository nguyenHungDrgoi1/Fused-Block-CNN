module top_module(
    input clk,
    input reset_n,
    input en,
    //input [15:0] valid,
    // đầu vào cho BRAM
    input we,
    input [6:0] wr_addr,
    input [12:0] rd_addr,
    input [63:0] data_in,

    output reg [7:0] data_1,
    output reg [7:0] data_2,
    output reg [7:0] data_3,
    output reg [7:0] data_4,
    output reg [7:0] data_5,
    output reg [7:0] data_6,
    output reg [7:0] data_7,
    output reg [7:0] data_8,
    output reg [7:0] data_9,
    output reg [7:0] data_10,
    output reg [7:0] data_11,
    output reg [7:0] data_12,
    output reg [7:0] data_13,
    output reg [7:0] data_14,
    output reg [7:0] data_15,
    output reg [7:0] data_16,

    output reg [15:0] valid_out
);

    wire [12:0] addr_1, addr_2, addr_3, addr_4, addr_5, addr_6, addr_7, addr_8;
    wire [12:0] addr_9, addr_10, addr_11, addr_12, addr_13, addr_14, addr_15, addr_16;
    wire [127:0] data_to_router;
    wire [12:0] address_to_router;
    

    Controller controller_main(
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid_out),

        .addr_1(addr_1),
        .addr_2(addr_2),
        .addr_3(addr_3),
        .addr_4(addr_4),
        .addr_5(addr_5),
        .addr_6(addr_6),
        .addr_7(addr_7),
        .addr_8(addr_8),
        .addr_9(addr_9),
        .addr_10(addr_10),
        .addr_11(addr_11),
        .addr_12(addr_12),
        .addr_13(addr_13),
        .addr_14(addr_14),
        .addr_15(addr_15),
        .addr_16(addr_16)
    );
    Router router_main (
        .addr(address_to_router),
        .data_in(data_to_router),

        .en(en),
        .addr_1(addr_1),
        .addr_2(addr_2),
        .addr_3(addr_3),
        .addr_4(addr_4),
        .addr_5(addr_5),
        .addr_6(addr_6),
        .addr_7(addr_7),
        .addr_8(addr_8),
        .addr_9(addr_9),
        .addr_10(addr_10),
        .addr_11(addr_11),
        .addr_12(addr_12),
        .addr_13(addr_13),
        .addr_14(addr_14),
        .addr_15(addr_15),
        .addr_16(addr_16),

        .data_1(data_1),
        .data_2(data_2),
        .data_3(data_3),
        .data_4(data_4),
        .data_5(data_5),
        .data_6(data_6),
        .data_7(data_7),
        .data_8(data_8),
        .data_9(data_9),
        .data_10(data_10),
        .data_11(data_11),
        .data_12(data_12),
        .data_13(data_13),
        .data_14(data_14),
        .data_15(data_15),
        .data_16(data_16),
        
        .valid(valid_out)

    );
    BRAM bram(
        .clk(clk),
        .we(we),
        .wr_addr(wr_addr),
        .rd_addr(rd_addr),
        .data_in(data_in),
        .data_out(data_to_router),
        .addr(address_to_router)
    );
endmodule