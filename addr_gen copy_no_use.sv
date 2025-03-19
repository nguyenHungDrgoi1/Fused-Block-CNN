module address_generator #(
    parameter TOTAL_PE   = 16,
    parameter DATA_WIDTH = 32
)(
    input   logic clk,
    input   logic rst_n,
    input   logic [7:0] counter,     
    input   logic [3:0] KERNEL_W, 
    input   logic [3:0] PE_index,  
    input   logic [7:0] OFM_W,   
    input   logic [7:0] IFM_C,      
    input   logic [7:0] IFM_W,  
    input   logic [1:0] stride,    
    input   logic done_compute,
    input   logic ready,
    input   logic [31:0] addr_in,

    output  logic [31:0] req_addr_out,
    output  logic addr_valid
);
wire in_progess;
reg [7:0] row_index_KERNEL;
reg [7:0] col_index_KERNEL;
reg [7:0] row_index_OFM;
reg [7:0] col_index_OFM;
reg [7:0] row_index_KERNEL_count;
reg [7:0] num_of_windows_in_Row_count;
reg [7:0] num_of_tiles_count;
reg [7:0] row_index_OFM;
reg [31:0] addr_fetch;
reg [31:0] window_start_addr;


wire [7:0] num_of_tiles = IFM_C >> 4;
wire [7:0] data_width_value = DATA_WIDTH;

typedef enum logic [2:0] {
    IDLE                = 3'b000,  
    FETCH_WINDOW_ROW    = 3'b001,  
    FETCH_WINDOW_COL    = 3'b010,  
    FETCH_OFM_ROW       = 3'b11,
    FETCH_OFM_COL       = 3'b100;
} state_t;

state_t current_state, next_state;


// FSM State Register
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        current_state <= IDLE;
        addr_fetch      <= addr_in;
    else
        current_state <= next_state;
end

// FSM Next State Logic
always_comb begin
    case (current_state)
        IDLE: 
            next_state = in_progess? FETCH_WINDOW_ROW : IDLE;
        FETCH_WINDOW_ROW: 
            next_state = (row_index_KERNEL  == KERNEL_W - 1) ? FETCH_WINDOW_COL : FETCH_WINDOW_ROW;  
        FETCH_WINDOW_COL: 
            next_state = (col_index_KERNEL  == KERNEL_W - 1) ? FETCH_OFM_ROW : FETCH_WINDOW_COL;
        FETCH_OFM_ROW: 
            next_state = (row_index_OFM     == OFM_W - 1) ? FETCH_OFM_COL : FETCH_WINDOW_ROW;
        FETCH_OFM_COL: 
            next_state = (col_index_OFM     == OFM_W - 1) ? IDLE : FETCH_WINDOW_ROW;
        default: 
            next_state = IDLE;
    endcase
end

// FSM Output Logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        addr_fetch   <= 0;
        addr_valid   <= 1'b0;
        row_index_KERNEL <= 8'b0;
        col_index_KERNEL <= 8'b0;
        num_of_tiles_count <= 8'b0;
    end else begin
        case (current_state)
            IDLE: begin
                if ( !in_progess ) begin
                    addr_valid      <= 1'b0;
                    row_index_KERNEL    <= 8'b0;
                    col_index_KERNEL <= 8'b0;
                    addr_fetch<= addr_in;
                    window_start_addr<= addr_in;
                end else begin
                    addr_fetch < =window_start_addr;
                end
            end

            FETCH_WINDOW_ROW: begin
                if (row_index_KERNEL < KERNEL_W) begin
                    if (num_of_tiles_count < num_of_tiles) begin
                        addr_fetch         <= addr_fetch + (row_index_KERNEL << 2);
                        num_of_tiles_count <= num_of_tiles_count + 1'b1;
                    end else begin
                        num_of_tiles_count <= 8'b0;
                        addr_fetch         <= addr_fetch + (4 * num_of_tiles);
                    end
                    row_index_KERNEL <= row_index_KERNEL + 1'b1;
                end begin
                    row_index_KERNEL <=0;
                end
                addr_valid  <= 1'b1;
                in_progess  <= 1'b1;
            end 

            FETCH_WINDOW_COL: begin
                if (col_index_KERNEL < KERNEL_W) begin
                    addr_fetch        <= addr_fetch + IFM_W;
                    col_index_KERNEL  <= col_index_KERNEL + 1'b1;
                end else begin
                    col_index_KERNEL <=0;
                end
                    addr_valid  <= 1'b1;
                    in_progess  <= 1'b1;
            end
            FETCH_OFM_ROW: begin
                if ( row_index_OFM < OFM_W) begin
                    window_start_addr      <= window_start_addr + (4 * num_of_tiles);
                    row_index_OFM   <= row_index_OFM + 1'b1;
                end
                else begin

                end
                addr_valid <= 1'b1;
                in_progess  <= 1'b1;

            end
            FETCH_OFM_COL: begin
                if ( col_index_OFM < OFM_W) begin
                    window_start_addr       <= window_start_addr + IFM*4;
                    col_index_OFM           <= col_index_OFM + 1'b1;
                end
                addr_valid  <= 1'b0;
                in_progess  <= 1'b1;
            end

            default: begin
                addr_valid  <= 1'b0;
            end
        endcase
    end
end

assign req_addr_out = addr_fetch;

endmodule
