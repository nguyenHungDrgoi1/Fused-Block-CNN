`timescale 1ns / 1ps

module Controller_PE_tb;
    // Testbench signals
    reg clk;
    reg reset_n;
    reg en;
    reg valid;
    wire [19:0] addr;

    // Instantiate the Controller_PE module
    Controller_PE uut (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid),
        .addr(addr)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        en = 0;
        valid = 0;

        // Test Case 1: Release reset, enable, and check addr
        #10;
        reset_n = 1;
        en = 1;
        #100;

        // Test Case 2: Apply valid signal and observe addr change
        valid = 1;
        #50;
        valid = 0;
        #500;
        valid = 1;
        #300;
        valid = 0;
        #350;
        valid = 1;
        #400;


        // Display results
        $display("Time = %0t", $time);
        $display("Address: %h", addr);
        #10;
        $finish;
    end
endmodule
