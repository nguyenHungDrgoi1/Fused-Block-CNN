module PE_cluster_1x1 (
    input  wire        clk,
    input  wire        reset_n,
    // 3 cặp IFM và Weightt
    input  wire [31:0]  Weight_0,
    input  wire [31:0]  Weight_1,
    input  wire [31:0]  Weight_2,
    input  wire [31:0]  Weight_3,
    input  wire [31:0]  IFM,
    // Tín hiệu điều khiển
    input  wire  [3:0] PE_reset,      
    input  wire  [3:0] PE_finish, 
    // Output
    output wire [7:0]  OFM_0,
    output wire [7:0]  OFM_1,
    output wire [7:0]  OFM_2,
    output wire [7:0]  OFM_3,
    output wire  [3:0]      valid
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
        .PE_reset(PE_reset[0]),
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
        .PE_reset(PE_reset[1]),
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
        .PE_reset(PE_reset[2]),
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
        .PE_reset(PE_reset[3]),
        .PE_finish(PE_finish[3]),
        .valid(valid[3]),
        .OFM(OFM_3)
    );
endmodule