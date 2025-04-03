module CONV_1x1_controller_tb();

    // Clock and reset
    reg clk;
    reg reset_n;

    // Inputs
    reg valid;
    reg [7:0] weight_c;
    reg [7:0] num_filter;

    // Outputs
    wire [31:0] addr_ifm;
    wire [31:0] addr_weight;
    wire [3:0] PE_en;
    wire [3:0] PE_finish;

    // Additional signal assumed needed for FSM to transition
    reg cal_start;

    // DUT instance
    CONV_1x1_controller uut (
        .clk(clk),
        .reset_n(reset_n),
        .valid(valid),
        .weight_c(weight_c),
        .num_filter(num_filter),
        .addr_ifm(addr_ifm),
        .addr_weight(addr_weight),
        .PE_en(PE_en),
        .PE_finish(PE_finish),
        .cal_start(cal_start)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        valid = 0;
        weight_c = 8'd128;         // for example, depth = 8
        num_filter = 8'd32;       // for example, 4 filters
        cal_start = 0;

        // Reset pulse
        #10 reset_n = 1;

        // Start calculation
        #100 cal_start = 1;
        //valid = 1;

        // Wait some cycles for simulation
        #20000;

        // Stop simulation
        $finish;
    end
    initial begin
        #100
        repeat(1000) begin
        valid <= 1;
        @(posedge clk)
        valid <= 0;
        repeat(72) @(posedge clk)
        valid <= 0;
        end
    end

endmodule
