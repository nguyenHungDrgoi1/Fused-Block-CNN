module PE(
    input clk,
    input reset_n,
    input [7:0] IFM,
    input [7:0] Weight,
    output [7:0] OFM,
    input PE_en,
    input PE_finish,
    output valid
);
    logic valid_c;
    logic [7:0] mul_IFM_Wei;
    //mul
    assign mul_IFM_Wei = IFM * Weight;
    logic [7:0] mul_sum_d;
    logic [7:0] mul_sum_q;
    //sum
    assign mul_sum_d = mul_IFM_Wei + mul_sum_q ;
    // reg
    always@(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            mul_sum_q <= 0;
        end
        else begin
            if(PE_en == 1) mul_sum_q <= 0 ;
            else
            mul_sum_q <= mul_sum_d; 
        end
    end
    //reg for valid
    always@(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            valid_c <= 0;
        end
        else begin
            if(PE_finish == 1) valid_c <= 1;
            else
            valid_c <= 0;
        end
    end
    assign valid = valid_c;
    assign OFM = mul_sum_q;
endmodule