module PE_cluster(
    input  wire        clk,
    input  wire        reset_n,
    // 3 cặp IFM và Weight
    input  wire [31:0]  Weigh_0,
    input  wire [31:0]  Weigh_1,
    input  wire [31:0]  Weigh_2,
    input  wire [31:0]  Weigh_3,
    input  wire [31:0]  Weigh_4,
    input  wire [31:0]  Weigh_5,
    input  wire [31:0]  Weigh_6,
    input  wire [31:0]  Weigh_7,
    input  wire [31:0]  Weigh_8,
    input  wire [31:0]  Weigh_9,
    input  wire [31:0]  Weigh_10,
    input  wire [31:0]  Weigh_11,
    input  wire [31:0]  Weigh_12,
    input  wire [31:0]  Weigh_13,
    input  wire [31:0]  Weigh_14,
    input  wire [31:0]  Weigh_15,
    input  wire [31:0]  IFM,
    // Tín hiệu điều khiển
    input  wire  [15:0]    PE_en,      
    input  wire  [15:0]       PE_finish, 
    // Output
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
    output wire [7:0]  OFM_16,
    output wire  [15:0]      valid
);
    Quad_PE instant_0 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_0[7:0]),
        .Weigh2(Weigh_0[15:8]),
        .Weigh3(Weigh_0[23:16]),
        .Weigh3(Weigh_0[31:24]),
        .OFM(OFM_0)
    );
        Quad_PE instant_1 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_1[7:0]),
        .Weigh2(Weigh_1[15:8]),
        .Weigh3(Weigh_1[23:16]),
        .Weigh3(Weigh_1[31:24]),
        .OFM(OFM_1)
    );
        Quad_PE instant_2 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_2[7:0]),
        .Weigh2(Weigh_2[15:8]),
        .Weigh3(Weigh_2[23:16]),
        .Weigh3(Weigh_2[31:24]),
        .OFM(OFM_2)
    );
        Quad_PE instant_3 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_3[7:0]),
        .Weigh2(Weigh_3[15:8]),
        .Weigh3(Weigh_3[23:16]),
        .Weigh3(Weigh_3[31:24]),
        .OFM(OFM_3)
    );
        Quad_PE instant_4 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_4[7:0]),
        .Weigh2(Weigh_4[15:8]),
        .Weigh3(Weigh_4[23:16]),
        .Weigh3(Weigh_4[31:24]),
        .OFM(OFM_4)
    );
        Quad_PE instant_5 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_5[7:0]),
        .Weigh2(Weigh_5[15:8]),
        .Weigh3(Weigh_5[23:16]),
        .Weigh3(Weigh_5[31:24]),
        .OFM(OFM_5)
    );
        Quad_PE instant_6 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_6[7:0]),
        .Weigh2(Weigh_6[15:8]),
        .Weigh3(Weigh_6[23:16]),
        .Weigh3(Weigh_6[31:24]),
        .OFM(OFM_6)
    );
        Quad_PE instant_7 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_7[7:0]),
        .Weigh2(Weigh_7[15:8]),
        .Weigh3(Weigh_7[23:16]),
        .Weigh3(Weigh_7[31:24]),
        .OFM(OFM_7)
    );
        Quad_PE instant_8 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_8[7:0]),
        .Weigh2(Weigh_8[15:8]),
        .Weigh3(Weigh_8[23:16]),
        .Weigh3(Weigh_8[31:24]),
        .OFM(OFM_8)
    );
        Quad_PE instant_9 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_9[7:0]),
        .Weigh2(Weigh_9[15:8]),
        .Weigh3(Weigh_9[23:16]),
        .Weigh3(Weigh_9[31:24]),
        .OFM(OFM_9)
    );
        Quad_PE instant_10 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_10[7:0]),
        .Weigh2(Weigh_10[15:8]),
        .Weigh3(Weigh_10[23:16]),
        .Weigh3(Weigh_10[31:24]),
        .OFM(OFM_10)
    );
        Quad_PE instant_11 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_11[7:0]),
        .Weigh2(Weigh_11[15:8]),
        .Weigh3(Weigh_11[23:16]),
        .Weigh3(Weigh_11[31:24]),
        .OFM(OFM_11)
    );
        Quad_PE instant_12 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_12[7:0]),
        .Weigh2(Weigh_12[15:8]),
        .Weigh3(Weigh_12[23:16]),
        .Weigh3(Weigh_12[31:24]),
        .OFM(OFM_12)
    );
           Quad_PE instant_13 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_13[7:0]),
        .Weigh2(Weigh_13[15:8]),
        .Weigh3(Weigh_13[23:16]),
        .Weigh3(Weigh_13[31:24]),
        .OFM(OFM_13)
    );
            Quad_PE instant_14 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_14[7:0]),
        .Weigh2(Weigh_14[15:8]),
        .Weigh3(Weigh_14[23:16]),
        .Weigh3(Weigh_14[31:24]),
        .OFM(OFM_14)
    );
            Quad_PE instant_15 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weigh1(Weigh_15[7:0]),
        .Weigh2(Weigh_15[15:8]),
        .Weigh3(Weigh_15[23:16]),
        .Weigh3(Weigh_15[31:24]),
        .OFM(OFM_15s)
    );

endmodule