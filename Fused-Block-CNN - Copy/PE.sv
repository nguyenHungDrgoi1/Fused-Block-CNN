module PE(
    input clk,
    input reset_n,
    input [7:0] IFM,
    input [7:0] Weight,
    output [7:0] OFM,
    input PE_restart,
    input PE_finish,
    output valid
);
    logic valid_c;
    logic [7:0] mul_IFM_Wei;
    //mul
    assign mul_IFM_Wei = IFM * Weight;
    logic [7:0] mul_sum_d;
    logic [7:0] mul_sum_q;
    logic [7:0] mul_sum;
    //sum
    assign mul_sum_d = mul_IFM_Wei + mul_sum ;
    // reg
    always@(posedge clk or negedge reset_n) begin
        //if(~reset_n || PE_restart=='b1) begin // must have a restarting signals to restart the OFM signal // add by thanhdo
        if(~reset_n) begin // must have a restarting signals to restart the OFM signal // for spec
            mul_sum_q <= 0;
        end
        else begin
            mul_sum_q <= mul_sum_d; 
        end
    end
    assign mul_sum = (PE_restart) ? 0 : mul_sum_q ;
    //reg for valid
    always@(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            valid_c <= 0;
        end
        else begin
            if(PE_finish == 1) valid_c <= 1; // PE_finish signal is the same meanning with valid_c ---> reduce 1 of 2 signals
            else
            valid_c <= 0;
        end
    end
    assign valid = valid_c;
    assign OFM = mul_sum_q;
endmodule