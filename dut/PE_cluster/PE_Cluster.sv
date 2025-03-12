module PE_cluster(
    input  wire        clk,
    input  wire        reset_n,
    // 3 cặp IFM và Weight
    input  wire [31:0]  Weigh_1,
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

   

endmodule