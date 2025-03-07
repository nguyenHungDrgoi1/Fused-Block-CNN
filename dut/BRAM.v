module BRAM(
    input wire clk,
    input wire we,                     // Write enable
    input wire [6:0] wr_addr,           // Write address (6-bit → 64 hàng)
    input wire [19:0] rd_addr,           // Read address (6-bit → 64 hàng)
    input wire [63:0] data_in,          // Dữ liệu đầu vào 64-bit
    output reg [512:0] data_out,      // Đầu ra 2048-bit (256*8 bit)
    //output reg [19:0] addr
);

    // Dùng 32 khối BRAM chạy song song, mỗi khối lưu 64-bit
    (* ram_style = "block" *) reg [63:0] bram [0:65536];  // Dùng 1 mảng một chiều

    //integer i;

    always @(posedge clk) begin
        if (we) begin
            bram[wr_addr] <= data_in;  // Ghi dữ liệu vào BRAM
        end
        else begin
        data_out[63:0] <= bram[ rd_addr >> 3 ];
        data_out[127:64] <= bram [ (rd_addr >> 3) + 1];
        data_out[127:64] <= bram [ (rd_addr >> 3) + 2];
        data_out[127:64] <= bram [ (rd_addr >> 3) + 3];
        data_out[127:64] <= bram [ (rd_addr >> 3) + 4];
        data_out[127:64] <= bram [ (rd_addr >> 3) + 5];
        data_out[127:64] <= bram [ (rd_addr >> 3) + 6];
        data_out[127:64] <= bram [ (rd_addr >> 3) + 7];
        // addr <= rd_addr; 
        end
    end

endmodule
