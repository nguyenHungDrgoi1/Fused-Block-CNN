module MUX_pipeline(
    input [1:0] control,

    input [7:0] data_in_0,
    input [7:0] data_in_1,
    input [7:0] data_in_2,
    input [7:0] data_in_3,
    input [7:0] data_in_4,
    input [7:0] data_in_5,
    input [7:0] data_in_6,
    input [7:0] data_in_7,
    input [7:0] data_in_8,
    input [7:0] data_in_9,
    input [7:0] data_in_10,
    input [7:0] data_in_11,
    input [7:0] data_in_12,
    input [7:0] data_in_13,
    input [7:0] data_in_14,
    input [7:0] data_in_15,

    output reg [31:0] data_out
);
    always_comb begin 
        case (control)
            2'd0 : data_out = {data_in_0,data_in_1,data_in_2,data_in_3} ;
            2'd1 : data_out = {data_in_4,data_in_5,data_in_6,data_in_7} ;
            2'd2 : data_out = {data_in_8,data_in_9,data_in_10,data_in_11} ;
            2'd3 : data_out = {data_in_12,data_in_13,data_in_14,data_in_15} ;
            default: data_out =0;
        endcase
    end
endmodule