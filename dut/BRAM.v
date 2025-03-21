module BRAM(
    input wire clk,
    input wire we,                     // Write enable
    input wire [6:0] wr_addr,           // Write address (6-bit → 64 hàng)
    input wire [19:0] rd_addr,           // Read address (6-bit → 64 hàng)
    input wire [31:0] data_in,          // Dữ liệu đầu vào 64-bit
    output reg [31:0] data_out      // Đầu ra 2048-bit (256*8 bit)
    //output reg [19:0] addr
);

    // Dùng 32 khối BRAM chạy song song, mỗi khối lưu 64-bit
    (* ram_style = "block" *) reg [31:0] bram [0:65535];  // Dùng 1 mảng một chiều
    
    //integer i;
    always @(posedge clk) begin
        if (we) begin
            bram[wr_addr] <= data_in;  // Ghi dữ liệu vào BRAM
            data_out <= 0;
        end
        else begin
        data_out <= bram[ rd_addr >> 2 ];
        
        // addr <= rd_addr; 
        end
    end

endmodule
