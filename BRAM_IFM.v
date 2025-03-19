module ifm_bram #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 128
)(
    input clk,
    input [ADDRESS_WIDTH-1:0] ifm_address,  // 8-bit address
    input [DATA_WIDTH-1:0] data_in,
    input write_en,
    // input read_en,
    input ifm_address_valid,
    output reg [DATA_WIDTH-1:0] ifm_out
);

reg [DATA_WIDTH-1:0] bram [0:255]; 

initial begin 
    $readmemh(/home/thanhdo/questasim/PE/Fused-Block-CNN/in-out-weight/addresses_ifm.hex", "w", bram);
    $fopen("/home/thanhdo/questasim/PE/Fused-Block-CNN/in-out-weight/addresses_ifm.hex", "w");
end

always @(posedge clk) begin
    if (ifm_address_valid) begin
        if (write_en) begin
            bram[ifm_address >> 4] <= data_in;
        end else begin
            ifm_out <= bram[ifm_address >> 4];
        end
    end
end
endmodule