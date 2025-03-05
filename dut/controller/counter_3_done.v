module counter_3_done(
    input clk,
    input rst_n,
    output done
);
    reg [1:0] counter;
    always@(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
        counter <= 0;
        done <= 0;
       end
        else if (counter == 2)begin
        counter <= 0;
        done <= 1;
       end
       else begin 
        counter <= counter + 1;
       end
    end
endmodule
