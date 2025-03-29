module Control_unit #(
    parameter TOTAL_PE = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire run,            // New run signal
    //input  wire inprogress,     // Signal to prevent further actions when in progress
    input  wire [3:0] instrution,  // instruction code
    input  wire [3:0] KERNEL_W,
    input  wire [7:0] OFM_W,
    input  wire [7:0] OFM_C,
    input  wire [7:0] IFM_C,
    input  wire [7:0] IFM_W,
    input  wire [1:0] stride,
    input  wire addr_valid,
    input  wire done_compute,

    output reg cal_start,
    output reg wr_rd_req_IFM,
    output reg wr_rd_req_Weight,
    output reg [31:0] base_addr,
    output wire [2:0] current_state_o,

    output reg [31:0] wr_addr_IFM,
    output reg [31:0] wr_addr_Weight,

    output reg [3:0] KERNEL_W_out,
    output reg [7:0] OFM_W_out,
    output reg [7:0] OFM_C_out,
    output reg [7:0] IFM_C_out,
    output reg [7:0] IFM_W_out,
    output reg [1:0] stride_out
);

// Define state machine states

parameter    S_REFRESH = 3'b000;
parameter    S_LOAD    = 3'b001;
parameter    S_CAL     = 3'b010;
parameter    S_STORE   = 3'b011;


reg [2:0] current_state, next_state;

// Internal counters
reg [32:0] IFM_size_counter;
reg [32:0] Weight_size_counter;
reg [15:0] num_of_bytes_shift = 2; // num_of_bytes = 4 per one time read data from BRAM

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        current_state <= S_REFRESH;
    //else if (run && !inprogress)  // Only trigger state change if run is asserted and inprogress is 0
    else if (run)  // Only trigger state change if run is asserted and inprogress is 0
        current_state <= next_state;
end

// Next state logic and control signals
always @(*) begin
    // Default values for control signals
    next_state = current_state;
    cal_start = 0;
    wr_rd_req_IFM = 0;
    wr_rd_req_Weight = 0;
    wr_addr_IFM = 0;
    wr_addr_Weight = 0;
    base_addr = 0;
    
    case (current_state)
        S_REFRESH: begin
            cal_start = 0;
            wr_rd_req_IFM = 0;
            wr_rd_req_Weight = 0;
            wr_addr_IFM = 0;
            wr_addr_Weight = 0;
            base_addr = 0;
            //if (instrution == 4'd1 && !inprogress) next_state = S_LOAD; // Transition to LOAD current_state when inprogress is 0
            if (instrution == 4'd1) next_state = S_LOAD; // Transition to LOAD state when inprogress is 0    
        end

        S_LOAD: begin
            base_addr = 0; // Base address for memory
    
            // IFM Load
            if (IFM_size_counter < 58*58*32) begin
                wr_rd_req_IFM = 1;
                wr_addr_IFM = IFM_size_counter >> num_of_bytes_shift;
            end else begin
                wr_rd_req_IFM = 0;
                wr_addr_IFM = 0;
            end

            // Weight Load
            if (Weight_size_counter < 32*9*8) begin
                wr_rd_req_Weight = 1;
                wr_addr_Weight = Weight_size_counter >> num_of_bytes_shift;
            end else begin
                wr_rd_req_Weight = 0;
                wr_addr_Weight = 0;
            end

            // Check if both IFM and weights are loaded
            if (IFM_size_counter >= 58*58*32 && Weight_size_counter >= 32*9*8) begin
                next_state = S_CAL; // Transition to CAL state
            end
        end

        S_CAL: begin
            if (done_compute) begin
                cal_start = 0;
                next_state = S_STORE; // After computation, transition to STORE
            end else begin
                cal_start = 1; // Start computation
            end
        end

        S_STORE: begin
            next_state = S_REFRESH;
        end

        default: begin
            next_state = S_REFRESH;
        end
    endcase
end

// Update counters for IFM and weight size
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        IFM_size_counter <= 0;
        Weight_size_counter <= 0;
    end else begin
        if (wr_rd_req_IFM)
            IFM_size_counter <= IFM_size_counter + 4;
        if (wr_rd_req_Weight)
            Weight_size_counter <= Weight_size_counter + 4;
    end
end

// Output the values for KERNEL_W, OFM_W, OFM_C, IFM_C, IFM_W, stride
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        KERNEL_W_out <= 0;
        OFM_W_out <= 0;
        OFM_C_out <= 0;
        IFM_C_out <= 0;
        IFM_W_out <= 0;
        stride_out <= 0;
    end else begin
        KERNEL_W_out <= KERNEL_W;
        OFM_W_out <= OFM_W;
        OFM_C_out <= OFM_C;
        IFM_C_out <= IFM_C;
        IFM_W_out <= IFM_W;
        stride_out <= stride;
    end
end


assign current_state_o = current_state;
endmodule
