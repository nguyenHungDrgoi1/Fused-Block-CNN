module CONV_1x1_controller(
    input clk,
    input reset_n,
    input valid,
    input [7:0] weight_c,
    input [7:0] num_filter,
    input cal_start,
    output logic [31:0] addr_ifm,
    output logic [31:0] addr_weight,
    output logic [3:0] PE_en,
    output logic [3:0] PE_finish
);
reg [2:0] curr_state, next_state;
parameter IDLE = 3'b000;
parameter START_PIXEL = 3'b001;
parameter DEEP_FETCH = 3'b010;
parameter END_PIXEL = 3'b100;

// value for count
reg [7:0] valid_count;
reg [7:0] count_deep_pixel;
reg [7:0] count_filter;
reg next_filter;
//value for mode of uart
// reg [6:0] end_bit;
// reg [3:0] bit_num;
// reg [3:0] bit_to_end;
// reg [3:0] sum_of_bit;
//calculate value for mode of uart
//assign end_bit = 24 + stop_bit_num * 16;
always_comb begin
    // case(data_bit_num)
    //     2'b00: bit_num = 5;
    //     2'b01: bit_num = 6;
    //     2'b10: bit_num = 7;
    //     2'b11: bit_num = 8;
    //     default : bit_num = 8;
    // endcase
    // bit_to_end = bit_num + parity_en;
    // sum_of_bit = b[0] + b[1] + b[2] + b[3] + b[4] + b[5] + b[6] + b[7] ;
end
// alwayff change state
always_ff@(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        curr_state <= 0;
    end
    else begin
        curr_state <= next_state;
    end
end

// alwaycomb to caculate the next_state
always_comb begin
    unique case(curr_state)
        
        // ST_IDLE to ...
        IDLE : begin
            if(cal_start == 1) next_state = START_PIXEL;
            else next_state = IDLE ;
        end

        // ST_START_BIT
        START_PIXEL : begin
            if((valid_count >= weight_c - 8) || (next_filter) ) begin
                next_state =  DEEP_FETCH;
            end
            else next_state =  START_PIXEL;
        end

        // ST_DATA_BIT
        DEEP_FETCH : begin
            if(count_deep_pixel < weight_c - 4) begin
                next_state = DEEP_FETCH ;
            end
            else begin
                if(count_filter < num_filter - 4) next_state =  START_PIXEL;
                else next_state =  END_PIXEL;
            end
        end

        // ST_END_TRAN 
        END_PIXEL : begin
            next_state = START_PIXEL ;
        end
    endcase
end

//always_ff for output
    always_ff@(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            valid_count <= 0;
            count_deep_pixel <= 0;
            count_filter <= 0;
            addr_ifm <= 0;
            addr_weight <= 0;
            next_filter <= 0;
        end
        else begin
            unique case(curr_state)

            IDLE: begin
                if(next_state == START_PIXEL) begin
                    addr_ifm <= 0 ;
                    addr_weight <= 0 ;
                end
            end
            START_PIXEL:begin
                if(next_state == START_PIXEL) begin
                    if(valid == 1) valid_count <= valid_count + 16;
                end
                if(next_state == DEEP_FETCH) begin
                    addr_ifm <= addr_ifm + 4 ;
                    addr_weight <= addr_weight + 4 ;
                    valid_count <= 0;
                    count_deep_pixel <= count_deep_pixel + 4;
                end
            end
            DEEP_FETCH: begin
                if(next_state == DEEP_FETCH) begin
                    addr_ifm <= addr_ifm + 4 ;
                    addr_weight <= addr_weight + 4 ;
                    count_deep_pixel <= count_deep_pixel + 4;
                end

                if(next_state == START_PIXEL) begin
                    addr_ifm <= addr_ifm - 124 ;
                    addr_weight <= addr_weight + 4 ;
                    count_deep_pixel <= 0;
                    count_filter <= count_filter + 4;
                    next_filter <= 1;
                end

                if(next_state == END_PIXEL) begin
                    // addr_ifm <= addr_ifm + 4 ;
                    // addr_weight <= addr_weight + 4 ;
                    count_deep_pixel <= 0;
                    count_filter <= 0;
                end
            end
            END_PIXEL: begin
                if(next_state == START_PIXEL) begin
                    addr_ifm <= addr_ifm + 4 ;
                    addr_weight <= 0 ;
                    next_filter <= 0;
                end
            end
        endcase
    end
end
endmodule