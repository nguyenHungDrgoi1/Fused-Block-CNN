module ReLU6(
    input  [7:0] OFM,
    output [7:0] OFM_active
);
    wire [7:0] tmp;

    assign tmp = OFM[7] ? 0 : OFM;
    assign OFM_active = OFM;

endmodule