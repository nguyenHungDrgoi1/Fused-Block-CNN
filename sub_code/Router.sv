module Router(
    //signal from BRAM
    input [12:0] addr,
    input [127:0] data_in,
    input en,
    // addr for transmit to fifo
    input [12:0]  addr_1,
    input [12:0] addr_2,
    input [12:0] addr_3,
    input [12:0] addr_4,
    input [12:0] addr_5,
    input [12:0] addr_6,
    input [12:0] addr_7,
    input [12:0] addr_8,
    input [12:0] addr_9,
    input [12:0] addr_10,
    input [12:0] addr_11,
    input [12:0] addr_12,
    input [12:0] addr_13,
    input [12:0] addr_14,
    input [12:0] addr_15,
    input [12:0] addr_16,

    // data out to PE
    output reg [7:0] data_1,
    output reg [7:0] data_2,
    output reg [7:0] data_3,
    output reg [7:0] data_4,
    output reg [7:0] data_5,
    output reg [7:0] data_6,
    output reg [7:0] data_7,
    output reg [7:0] data_8,
    output reg [7:0] data_9,
    output reg [7:0] data_10,
    output reg [7:0] data_11,
    output reg [7:0] data_12,
    output reg [7:0] data_13,
    output reg [7:0] data_14,
    output reg [7:0] data_15,
    output reg [7:0] data_16,

    //valid
    output reg [15:0] valid
);
    always_comb begin
        // data_1
        if((addr <= addr_1) && (addr_1 < addr + 16) && en) begin
            valid[0] = 1;
            data_1 = data_in >> ((addr_1 - addr)<<3) ;
        end
        else begin
            valid[0] = 0;
            data_1 = 0;
        end
        // data_2
        if((addr <= addr_2) && (addr_2 < addr + 16) && en) begin
            valid[1] = 1;
            data_2 = data_in >> ((addr_2 - addr)<<3) ;
        end
        else begin
            valid[1] = 0;
            data_2 = 0;
        end

        if((addr <= addr_3) && (addr_3 < addr + 16) && en) begin
            valid[2] = 1;
            data_3 = data_in >> ((addr_3 - addr)<<3) ;
        end
        else begin
            valid[2] = 0;
            data_3 = 0;
        end

        if((addr <= addr_4) && (addr_4 < addr + 16) && en) begin
            valid[3] = 1;
            data_4 = data_in >> ((addr_4 - addr)<<3) ;
        end
        else begin
            valid[3] = 0;
            data_4 = 0;
        end

        if((addr <= addr_5) && (addr_5 < addr + 16) && en) begin
            valid[4] = 1;
            data_5 = data_in >> ((addr_5 - addr)<<3) ;
        end
        else begin
            valid[4] = 0;
            data_5 = 0;
        end
        
        if((addr <= addr_6) && (addr_6 < addr + 16)&& en) begin
            valid[5] = 1;
            data_6 = data_in >> ((addr_6 - addr)<<3) ;
        end
        else begin
            valid[5] = 0;
            data_6 = 0;
        end

        if((addr <= addr_7) && (addr_7 < addr + 16)&& en) begin
            valid[6] = 1;
            data_7 = data_in >> ((addr_7 - addr)<<3) ;
        end
        else begin
            valid[6] = 0;
            data_7 = 0;
        end
        if((addr <= addr_8) && (addr_8 < addr + 16)&& en) begin
            valid[7] = 1;
            data_8 = data_in >> ((addr_8 - addr)<<3) ;
        end
        else begin
            valid[7] = 0;
            data_8 = 0;
        end

        if((addr <= addr_9) && (addr_9 < addr + 16)&& en) begin
            valid[8] = 1;
            data_9 = data_in >> ((addr_9 - addr)<<3) ;
        end
        else begin
            valid[8] = 0;
            data_9 = 0;
        end

        if((addr <= addr_10) && (addr_10 < addr + 16)&& en) begin
            valid[9] = 1;
            data_10 = data_in >> ((addr_10 - addr)<<3) ;
        end
        else begin
            valid[9] = 0;
            data_10 = 0;
        end

        if((addr <= addr_11) && (addr_11 < addr + 16)&& en) begin
            valid[10] = 1;
            data_11 = data_in >> ((addr_11 - addr)<<3) ;
        end
        else begin
            valid[10] = 0;
            data_11 = 0;
        end

        if((addr <= addr_12) && (addr_12 < addr + 16)&& en) begin
            valid[11] = 1;
            data_12 = data_in >> ((addr_12 - addr)<<3) ;
        end
        else begin
            valid[11] = 0;
            data_12 = 0;
        end

        if((addr <= addr_13) && (addr_13 < addr + 16)&& en) begin
            valid[12] = 1;
            data_13 = data_in >> ((addr_13 - addr)<<3) ;
        end
        else begin
            valid[12] = 0;
            data_13 = 0;
        end

        if((addr <= addr_14) && (addr_14 < addr + 16)&& en) begin
            valid[13] = 1;
            data_14 = data_in >> ((addr_14 - addr)<<3) ;
        end
        else begin
            valid[13] = 0;
            data_14 = 0;
        end

        if((addr <= addr_15) && (addr_15 < addr + 16)&& en) begin
            valid[14] = 1;
            data_15 = data_in >> ((addr_15 - addr)<<3) ;
        end
        else begin
            valid[14] = 0;
            data_15 = 0;
        end

        if((addr <= addr_16) && (addr_16 < addr + 16)&& en) begin
            valid[15] = 1;
            data_16 = data_in >> ((addr_16 - addr)<<3) ;
        end
        else begin
            valid[15] = 0;
            data_16 = 0;
        end
        
    end

endmodule