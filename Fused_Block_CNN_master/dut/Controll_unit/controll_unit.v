module control_unit #(
    parameter TOTAL_PE  =16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [3:0]   KERNEL_W,
    input  wire [7:0]   OFM_W,
    input  wire [7:0]   OFM_C,
    input  wire [7:0]   IFM_C,
    input  wire [7:0]   IFM_W,
    input  wire [1:0]   stride,

    input  wire         cal_start,
    input  wire         wr_rd_req,
    
    input  wire [31:0]  base_addr,
    
)