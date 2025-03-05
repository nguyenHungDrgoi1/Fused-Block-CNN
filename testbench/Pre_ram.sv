module Pre_ram(
    input clk,
    input reset_n,
    input [63:0] data_in,
    input read_req,
    input we,
    input [7:0] addr,
    output reg [64*32 - 1 : 0] data_out
);
    
    // Định nghĩa bộ nhớ RAM 512 hàng, mỗi hàng 64-bit
    reg [63:0] ram [511:0]; 
    
    integer i;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Xóa bộ nhớ khi reset
            for (i = 0; i < 512; i = i + 1) begin
                ram[i] <= 64'b0;
            end
            data_out <= 0;
        end else begin
            if (we) begin
                // Ghi dữ liệu vào RAM
                ram[addr] <= data_in;
            end
            if (read_req) begin
                // Xuất dữ liệu ra khi read_req được bật (32 từ 64-bit -> 2048-bit)
               data_out <= {
                ram[addr],
                 ram[addr+1],
                ram[addr+2],
                ram[addr+3],
                ram[addr+4],
                ram[addr+5],
                ram[addr+6],
                ram[addr+7],
                ram[addr+8],
                ram[addr+9],
                ram[addr+10],
                ram[addr+11],
                ram[addr+12],
                ram[addr+13],
                ram[addr+14],
                ram[addr+15],
                ram[addr+16],
                ram[addr+17],
                ram[addr+18],
                ram[addr+19],
                ram[addr+20],
                ram[addr+21],
                ram[addr+22],
                ram[addr+23],
                ram[addr+24],
                ram[addr+25],
                ram[addr+26],
                ram[addr+27],
                ram[addr+28],
                ram[addr+29],
                ram[addr+30],
                ram[addr+30],
                ram[addr+31]
               };
            end
        end
    end
    
endmodule
