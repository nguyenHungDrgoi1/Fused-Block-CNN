module Sub_top_CONV_tb;
    reg clk;
    reg reset;
    reg [6:0] addr;
    reg we;
    reg [63:0] data_in;
    wire [31:0] OFM;

    reg [15:0] PE_en;
    reg [15:0] PE_finish;
    reg [19:0] addr_w[15:0];

    wire [7:0] OFM_out[15:0];

    Sub_top_CONV uut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .we(we),
        .data_in(data_in),
        .OFM(OFM),
        .PE_en(PE_en),
        .PE_finish(PE_finish),
        .addr_w0(addr_w[0]),
        .addr_w1(addr_w[1]),
        .addr_w2(addr_w[2]),
        .addr_w3(addr_w[3]),
        .addr_w4(addr_w[4]),
        .addr_w5(addr_w[5]),
        .addr_w6(addr_w[6]),
        .addr_w7(addr_w[7]),
        .addr_w8(addr_w[8]),
        .addr_w9(addr_w[9]),
        .addr_w10(addr_w[10]),
        .addr_w11(addr_w[11]),
        .addr_w12(addr_w[12]),
        .addr_w13(addr_w[13]),
        .addr_w14(addr_w[14]),
        .addr_w15(addr_w[15]),
        .OFM_0(OFM_out[0]),
        .OFM_1(OFM_out[1]),
        .OFM_2(OFM_out[2]),
        .OFM_3(OFM_out[3]),
        .OFM_4(OFM_out[4]),
        .OFM_5(OFM_out[5]),
        .OFM_6(OFM_out[6]),
        .OFM_7(OFM_out[7]),
        .OFM_8(OFM_out[8]),
        .OFM_9(OFM_out[9]),
        .OFM_10(OFM_out[10]),
        .OFM_11(OFM_out[11]),
        .OFM_12(OFM_out[12]),
        .OFM_13(OFM_out[13]),
        .OFM_14(OFM_out[14]),
        .OFM_15(OFM_out[15])
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #10 reset = 0;
        addr = 7'h3A;
        we = 1;
        data_in = 64'hDEADBEEF;
        #10 we = 0;
        #100 $stop;
    end

endmodule
