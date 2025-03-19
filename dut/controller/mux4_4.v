module mux4_4(
    input a,b,c,d
    input control_1, control_2, control_3, control_4,
    output result
);
    always @(*) begin
       if (control_1) begin
            result = a;
       end
       else if (control_2) begin
            result = b;
       end
       else if (control_3) begin
            result = c;
       end
       else begin
            result = d;
       end
    end
endmodule