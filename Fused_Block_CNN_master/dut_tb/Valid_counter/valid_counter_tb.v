`timescale 1ns/1ps

module valid_counter_tb();

    // Parameters
    parameter CLK_PERIOD = 10;

    // DUT Inputs
    reg clk;
    reg rst_n;
    reg valid_in;
    reg [3:0] PE_number;
    reg [10:0] IFM_C;

    // DUT Output
    wire valid_out;

    // Instantiate DUT
    valid_counter uut (
        .clk        (clk),
        .rst_n      (rst_n),
        .valid_in   (valid_in),
        .PE_number  (PE_number),
        .IFM_C      (IFM_C),
        .valid_out  (valid_out)
    );

    // Clock generator
    always #(CLK_PERIOD/2) clk = ~clk;

    // Task: apply N one-clock valid_in pulses
    task run_test;
        input [10:0] ifm_c_val;
        input [3:0]  pe_num;
        input integer expected_cycles;

        integer i;
        begin
            $display(">> Testing IFM_C = %0d, PE_number = %0d => expected threshold = %0d",
                     ifm_c_val, pe_num, expected_cycles);

            // Apply config
            IFM_C = ifm_c_val;
            PE_number = pe_num;

            @(posedge clk);  // 1-cycle delay
            for (i = 0; i < expected_cycles; i = i + 1) begin
                @(posedge clk); valid_in = 1;
                @(posedge clk); valid_in = 0;

                if (i < expected_cycles - 1 && valid_out)
                    $display("  [ERROR] valid_out occurred too early at count %0d!", i+1);
                if (i == expected_cycles - 1 && !valid_out)
                    $display("  [ERROR] valid_out missing at expected count %0d!", i+1);
            end

            @(posedge clk);
            if (valid_out)
                $display("  [PASS] valid_out asserted as expected.\n");
            else
                $display("  [FAIL] valid_out NOT asserted!\n");
        end
    endtask

    // Main simulation
    initial begin
        $display("===== VALID_COUNTER TESTBENCH START =====");
        $dumpfile("valid_counter_tb.vcd");
        $dumpvars(0, valid_counter_tb);

        // Init signals
        clk = 0;
        rst_n = 0;
        valid_in = 0;
        IFM_C = 0;
        PE_number = 0;

        // Reset
        #(CLK_PERIOD);
        rst_n = 1;

        // Run test cases
        run_test(64, 4, 16);       // 64 / 4 = 16
        run_test(128, 2, 64);      // 128 / 2 = 64
        run_test(384, 16, 24);     // 384 / 16 = 24
        run_test(576, 4, 144);     // 576 / 4 = 144
        run_test(16, 2, 8);        // 16 / 2 = 8
        run_test(112, 16, 7);      // 112 / 16 = 7

        // Optional invalid case
        $display(">> Testing invalid IFM_C = 28, PE_number = 4 (should not trigger valid_out)");
        IFM_C = 28;
        PE_number = 4;
        valid_in = 1;
        @(posedge clk); valid_in = 0;
        repeat (10) @(posedge clk);

        if (valid_out)
            $display("  [ERROR] valid_out should NOT assert for invalid config!");
        else
            $display("  [PASS] valid_out correctly not asserted.\n");

        $display("===== VALID_COUNTER TESTBENCH FINISH =====");
        $stop;
    end

endmodule
