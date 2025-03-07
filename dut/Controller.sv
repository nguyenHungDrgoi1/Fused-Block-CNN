module Controller(
    input clk,
    input reset_n, 
    input en,
    input [15:0] valid, // 16-bit valid signal
    output [12:0] addr_1, addr_2, addr_3, addr_4, addr_5, addr_6, addr_7, addr_8,
    output [12:0] addr_9, addr_10, addr_11, addr_12, addr_13, addr_14, addr_15, addr_16,
    input [8:0] end_OFM,
    input [8:0] change_row,
    input [8:0] change_channel
);
    // Declare wires to connect each Controller_PE instance
    wire [12:0] addr_1_pe, addr_2_pe, addr_3_pe, addr_4_pe, addr_5_pe, addr_6_pe, addr_7_pe, addr_8_pe;
    wire [12:0] addr_9_pe, addr_10_pe, addr_11_pe, addr_12_pe, addr_13_pe, addr_14_pe, addr_15_pe, addr_16_pe;

    // Instantiate 16 Controller_PE modules
    Controller_PE controller_1 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[0]),
        .start_addr(0),
        .change_row(change_row),
        .change_channel(change_channel),
        .end_OFM(end_OFM),
        .addr(addr_1_pe)
    );

    Controller_PE controller_2 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[1]),
        .start_addr(1),
        .addr(addr_2_pe)
    );

    Controller_PE controller_3 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[2]),
        .start_addr(2),
        .addr(addr_3_pe)
    );

    Controller_PE controller_4 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[3]),
        .start_addr(3),
        .addr(addr_4_pe)
    );

    Controller_PE controller_5 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[4]),
        .start_addr(4),
        .addr(addr_5_pe)
    );

    Controller_PE controller_6 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[5]),
        .start_addr(7),
        .addr(addr_6_pe)
    );

    Controller_PE controller_7 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[6]),
        .start_addr(8),
        .addr(addr_7_pe)
    );

    Controller_PE controller_8 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[7]),
        .start_addr(9),
        .addr(addr_8_pe)
    );

    Controller_PE controller_9 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[8]),
         .start_addr(10),
        .addr(addr_9_pe)
    );

    Controller_PE controller_10 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[9]),
        .start_addr(11),
        .addr(addr_10_pe)
    );

    Controller_PE controller_11 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[10]),
        .start_addr(14),
        .addr(addr_11_pe)
    );

    Controller_PE controller_12 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[11]),
        .start_addr(15),
        .addr(addr_12_pe)
    );

    Controller_PE controller_13 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[12]),
        .start_addr(16),
        .addr(addr_13_pe)
    );

    Controller_PE controller_14 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[13]),
        .start_addr(17),
        .addr(addr_14_pe)
    );

    Controller_PE controller_15 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[14]),
        .start_addr(18),
        .addr(addr_15_pe)
    );

    Controller_PE controller_16 (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid[15]),
        .start_addr(21),
        .addr(addr_16_pe)
    );

    // Assign the output addresses
    assign addr_1 = addr_1_pe;
    assign addr_2 = addr_2_pe;
    assign addr_3 = addr_3_pe;
    assign addr_4 = addr_4_pe;
    assign addr_5 = addr_5_pe;
    assign addr_6 = addr_6_pe;
    assign addr_7 = addr_7_pe;
    assign addr_8 = addr_8_pe;
    assign addr_9 = addr_9_pe;
    assign addr_10 = addr_10_pe;
    assign addr_11 = addr_11_pe;
    assign addr_12 = addr_12_pe;
    assign addr_13 = addr_13_pe;
    assign addr_14 = addr_14_pe;
    assign addr_15 = addr_15_pe;
    assign addr_16 = addr_16_pe;

endmodule
