module Register_for_pipeline(
    input clk,
    input reset_n,
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
    output reg [7:0]  data_out_0,
    output reg [7:0] data_out_1,
    output reg [7:0] data_out_2,
    output reg [7:0] data_out_3,
    output reg [7:0] data_out_4,
    output reg [7:0] data_out_5,
    output reg [7:0] data_out_6,
    output reg [7:0] data_out_7,
    output reg [7:0] data_out_8,
    output reg [7:0] data_out_9,
    output reg [7:0] data_out_10,
    output reg [7:0] data_out_11,
    output reg [7:0] data_out_12,
    output reg [7:0] data_out_13,
    output reg [7:0] data_out_14,
    output reg [7:0] data_out_15
);
    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            data_out_0 <= 0;
            data_out_1 <= 0;
            data_out_2 <= 0;
            data_out_3 <= 0;
            data_out_4 <= 0;
            data_out_5 <= 0;
            data_out_6 <= 0;
            data_out_7 <= 0;
            data_out_8 <= 0;
            data_out_9 <= 0;
            data_out_10 <= 0;
            data_out_11 <= 0;
            data_out_12 <= 0;
            data_out_13 <= 0;
            data_out_14 <= 0;
            data_out_15 <= 0;
        end
        else begin
            if(valid_data[0]) data_out_0 <= data_in_0;
            if(valid_data[1]) data_out_1 <= data_in_1;
            if(valid_data[2]) data_out_2 <= data_in_2;
            if(valid_data[3]) data_out_3 <= data_in_3;
            if(valid_data[4]) data_out_4 <= data_in_4;
            if(valid_data[5]) data_out_5 <= data_in_5;
            if(valid_data[6]) data_out_6 <= data_in_6;
            if(valid_data[7]) data_out_7 <= data_in_7;
            if(valid_data[8]) data_out_8 <= data_in_8;
            if(valid_data[9]) data_out_9 <= data_in_9;
            if(valid_data[10]) data_out_10 <= data_in_10;
            if(valid_data[11]) data_out_11 <= data_in_11;
            if(valid_data[12]) data_out_12 <= data_in_12;
            if(valid_data[13]) data_out_13 <= data_in_13;
            if(valid_data[14]) data_out_14 <= data_in_14;
            if(valid_data[15]) data_out_15 <= data_in_15;   
        end
    end
endmodule