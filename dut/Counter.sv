module Counter #(
    parameter WIDTH = 4 // Default width of counter
)(
    input logic clk,
    input logic reset_n,
    input logic en,
    input [WIDTH-1:0]load,
    input stop,
    output logic [WIDTH-1:0] count,
    output logic done
);

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;
            done <= 0;
        end else if (en) begin
            if ((count == load - 1) && ~stop) begin
                count <= 0; // Reset count when max value is reached
                done <= 1;  // Signal that counting reached max value
            end else begin
                if(~stop) begin
                count <= count + 1;
                done <= 0;
                end
            end
        end
    end

endmodule
