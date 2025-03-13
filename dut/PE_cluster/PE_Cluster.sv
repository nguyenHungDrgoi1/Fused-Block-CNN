module PE_cluster(
    input  wire        clk,
    input  wire        reset_n,
    // 3 cặp IFM và Weightt
    input  wire [31:0]  Weight_0,
    input  wire [31:0]  Weight_1,
    input  wire [31:0]  Weight_2,
    input  wire [31:0]  Weight_3,
    input  wire [31:0]  Weight_4,
    input  wire [31:0]  Weight_5,
    input  wire [31:0]  Weight_6,
    input  wire [31:0]  Weight_7,
    input  wire [31:0]  Weight_8,
    input  wire [31:0]  Weight_9,
    input  wire [31:0]  Weight_10,
    input  wire [31:0]  Weight_11,
    input  wire [31:0]  Weight_12,
    input  wire [31:0]  Weight_13,
    input  wire [31:0]  Weight_14,
    input  wire [31:0]  Weight_15,
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
        .Weight1(Weight_0[7:0]),
        .Weight2(Weight_0[15:8]),
        .Weight3(Weight_0[23:16]),
        .Weight4(Weight_0[31:24]),
        .PE_en(PE_en[0]),
        .PE_finish(PE_finish[0]),
        .valid(valid[0]),
        .OFM(OFM_0)
    );
        Quad_PE instant_1 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_1[7:0]),
        .Weight2(Weight_1[15:8]),
        .Weight3(Weight_1[23:16]),
        .Weight4(Weight_1[31:24]),
        .PE_en(PE_en[1]),
        .PE_finish(PE_finish[1]),
        .valid(valid[1]),
        .OFM(OFM_1)
    );
        Quad_PE instant_2 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_2[7:0]),
        .Weight2(Weight_2[15:8]),
        .Weight3(Weight_2[23:16]),
        .Weight4(Weight_2[31:24]),
        .PE_en(PE_en[2]),
        .PE_finish(PE_finish[2]),
        .valid(valid[2]),
        .OFM(OFM_2)
    );
        Quad_PE instant_3 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_3[7:0]),
        .Weight2(Weight_3[15:8]),
        .Weight3(Weight_3[23:16]),
        .Weight4(Weight_3[31:24]),
        .PE_en(PE_en[3]),
        .PE_finish(PE_finish[3]),
        .valid(valid[3]),
        .OFM(OFM_3)
    );
        Quad_PE instant_4 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_4[7:0]),
        .Weight2(Weight_4[15:8]),
        .Weight3(Weight_4[23:16]),
        .Weight4(Weight_4[31:24]),
        .PE_en(PE_en[4]),
        .PE_finish(PE_finish[4]),
        .valid(valid[4]),
        .OFM(OFM_4)
    );
        Quad_PE instant_5 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_5[7:0]),
        .Weight2(Weight_5[15:8]),
        .Weight3(Weight_5[23:16]),
        .Weight4(Weight_5[31:24]),
        .PE_en(PE_en[5]),
        .PE_finish(PE_finish[5]),
        .valid(valid[5]),
        .OFM(OFM_5)
    );
        Quad_PE instant_6 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_6[7:0]),
        .Weight2(Weight_6[15:8]),
        .Weight3(Weight_6[23:16]),
        .Weight4(Weight_6[31:24]),
        .PE_en(PE_en[6]),
        .PE_finish(PE_finish[6]),
        .valid(valid[6]),
        .OFM(OFM_6)
    );
        Quad_PE instant_7 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_7[7:0]),
        .Weight2(Weight_7[15:8]),
        .Weight3(Weight_7[23:16]),
        .Weight4(Weight_7[31:24]),
        .PE_en(PE_en[7]),
        .PE_finish(PE_finish[7]),
        .valid(valid[7]),
        .OFM(OFM_7)
    );
        Quad_PE instant_8 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_8[7:0]),
        .Weight2(Weight_8[15:8]),
        .Weight3(Weight_8[23:16]),
        .Weight4(Weight_8[31:24]),
        .PE_en(PE_en[8]),
        .PE_finish(PE_finish[8]),
        .valid(valid[8]),
        .OFM(OFM_8)
    );
        Quad_PE instant_9 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_9[7:0]),
        .Weight2(Weight_9[15:8]),
        .Weight3(Weight_9[23:16]),
        .Weight4(Weight_9[31:24]),
        .PE_en(PE_en[9]),
        .PE_finish(PE_finish[9]),
        .valid(valid[9]),
        .OFM(OFM_9)
    );
        Quad_PE instant_10 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_10[7:0]),
        .Weight2(Weight_10[15:8]),
        .Weight3(Weight_10[23:16]),
        .Weight4(Weight_10[31:24]),
        .PE_en(PE_en[10]),
        .PE_finish(PE_finish[10]),
        .valid(valid[10]),
        .OFM(OFM_10)
    );
        Quad_PE instant_11 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_11[7:0]),
        .Weight2(Weight_11[15:8]),
        .Weight3(Weight_11[23:16]),
        .Weight4(Weight_11[31:24]),
        .PE_en(PE_en[11]),
        .PE_finish(PE_finish[11]),
        .valid(valid[11]),
        .OFM(OFM_11)
    );
        Quad_PE instant_12 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_12[7:0]),
        .Weight2(Weight_12[15:8]),
        .Weight3(Weight_12[23:16]),
        .Weight4(Weight_12[31:24]),
        .PE_en(PE_en[12]),
        .PE_finish(PE_finish[12]),
        .valid(valid[12]),
        .OFM(OFM_12)
    );
           Quad_PE instant_13 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_13[7:0]),
        .Weight2(Weight_13[15:8]),
        .Weight3(Weight_13[23:16]),
        .Weight4(Weight_13[31:24]),
        .PE_en(PE_en[13]),
        .PE_finish(PE_finish[13]),
        .valid(valid[13]),
        .OFM(OFM_13)
    );
            Quad_PE instant_14 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_14[7:0]),
        .Weight2(Weight_14[15:8]),
        .Weight3(Weight_14[23:16]),
        .Weight4(Weight_14[31:24]),
        .PE_en(PE_en[14]),
        .PE_finish(PE_finish[14]),
        .valid(valid[14]),
        .OFM(OFM_14)
    );
            Quad_PE instant_15 (
        .clk(clk),
        .reset_n(reset_n),
        .IFM1(IFM[7:0]),
        .IFM2(IFM[15:8]),
        .IFM3(IFM[23:16]),
        .IFM4(IFM[31:24]),
        .Weight1(Weight_15[7:0]),
        .Weight2(Weight_15[15:8]),
        .Weight3(Weight_15[23:16]),
        .Weight4(Weight_15[31:24]),
        .PE_en(PE_en[15]),
        .PE_finish(PE_finish[15]),
        .valid(valid[15]),
        .OFM(OFM_15)
    );

endmodule