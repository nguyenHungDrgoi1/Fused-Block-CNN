module Register_for_pipeline(
    input clk,
    input reset_n,4
    input [15:0] valid_data,
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
    output [7:0] data_out_0,
    output [7:0] data_out_1,
    output [7:0] data_out_2,
    output [7:0] data_out_3,
    output [7:0] data_out_4,
    output [7:0] data_out_5,
    output [7:0] data_out_6,
    output [7:0] data_out_7,
    output [7:0] data_out,
    output [7:0] data_out,
    output [7:0] data_out,
    output [7:0] data_out,
    output [7:0] data_out,
    output [7:0] data_out,
);
    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            data_out <= 0;
        end
        else begin
            if(valid_data) data_out <= data_in;
        end
    end
endmodule