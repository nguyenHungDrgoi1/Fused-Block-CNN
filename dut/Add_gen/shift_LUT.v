module shift_LUT#(
    parameter INPUT_WIDTH = 16,
    parameter OUTPUT_WIDTH = 9
)(
    input wire [INPUT_WIDTH-1:0] in,
    output reg [OUTPUT_WIDTH-1:0] out
);
always @(*) begin
    case (in)
        'd1 : begin
            out = 'h0;
        end
        'd2 : begin
            out = 'h1;
        end
        'd4: begin
            out = 'h2;
        end
        'd8: begin
            out = 'h3;
        end
        'd16: begin
            out = 'h4;
        end
        'd32: begin
            out = 'h5;
        end
        'd64: begin
            out = 'h6;
        end
        'd128: begin
            out = 'h7;
        end
        'd256: begin
            out = 'h8;
        end
        default : 
            out = 'h2;
    endcase
end


endmodule