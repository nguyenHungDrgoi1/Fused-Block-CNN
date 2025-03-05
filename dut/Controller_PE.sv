module Controller_PE(
    input clk,
    input reset_n, 
    input en,
    input valid,
    input [12:0] start_addr,
    //address
    output [12:0]  addr
);
    //define addr signal
    logic [12:0] base_addr_d;
    logic [12:0] base_addr_q;
    logic signed [12:0] add_value;
    //signal for counter
    logic count_3; // co the thay 3 bang parameter
    logic count_9;
    logic count_45;
    logic default_set;
    //instance counter
    Counter #(.WIDTH(2)) counter_3
    (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .done(count_3),
        .stop(~valid),
        .load(3)
    );
    Counter #(.WIDTH(4)) counter_9
    (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .done(count_9),
        .stop(~valid),
        .load(9)
    );
    Counter #(.WIDTH(6)) counter_45
    (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .done(count_45),
        .stop(~valid),
        .load(45)
    );
    //Signal 
    assign default_set = ~count_3 && ~count_9 && ~count_45;

    //Adder
    assign base_addr_d = base_addr_q + add_value;

    //Mux
    always_comb begin
        case({default_set,count_3,count_9,count_45})
            4'b1000 : add_value = 1;
            4'b0100 : add_value = 5;
            4'b0110 : add_value = 33;
            4'b0111 : add_value = -190;
            default : add_value = 0;
        endcase
    end

    //Flip flop
    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            base_addr_q <= -1;
        end
        else begin
            if(~en) begin
                base_addr_q <= start_addr;
            end
            else begin
                if(valid) begin
                    base_addr_q <= base_addr_d;
                end
            end
        end
    end

    assign addr = base_addr_q ;
endmodule