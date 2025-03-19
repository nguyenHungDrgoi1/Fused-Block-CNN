module counter_45(
    input clk,
    input rst_n,
    output reg [5:0] counter
);
    always@(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
        counter <= 0;
       end
        else if (counter == 44)begin
        counter <= 0;
       end
       else begin 
        counter <= counter + 1;
       end
    end
endmodule
