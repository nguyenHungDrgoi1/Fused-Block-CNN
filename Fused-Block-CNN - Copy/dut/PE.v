module PE(
    input clk;
    input reset_n;
    input [7:0] IFM,
    input [7:0] Weight,
    output [7:0] OFM
);
    wire [7:0] mul_IFM_Wei;
    //mul
    assign mul_IFM_Wei = IFM * Weight;
    reg [7:0] mul_sum_d;
    reg [7:0] mul_sum_q;
    //sum
    mul_sum_d = mul_IFM_Wei + mul_sum_q ;
    // reg
    always(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            mul_sum_q <= 0;
        end
        else begin
            mul_sum_q <= mul_sum_d;
        end
    end
endmodule