`timescale 1ns / 1ps

module Controller_tb;
    // Testbench signals
    reg clk;
    reg reset_n;
    reg en;
    reg [15:0] valid;
    
    wire [12:0] addr_1, addr_2, addr_3, addr_4, addr_5, addr_6, addr_7, addr_8;
    wire [12:0] addr_9, addr_10, addr_11, addr_12, addr_13, addr_14, addr_15, addr_16;
    
    // Instantiate the Controller module
    Controller uut (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .valid(valid),
        .addr_1(addr_1), .addr_2(addr_2), .addr_3(addr_3), .addr_4(addr_4),
        .addr_5(addr_5), .addr_6(addr_6), .addr_7(addr_7), .addr_8(addr_8),
        .addr_9(addr_9), .addr_10(addr_10), .addr_11(addr_11), .addr_12(addr_12),
        .addr_13(addr_13), .addr_14(addr_14), .addr_15(addr_15), .addr_16(addr_16)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        en = 0;
        valid = 16'b0;
        
        // Apply reset
        #10;
        reset_n = 1;
        
        // Test Case 1: Enable controller and check address outputs
        #40;
        en = 1;
        #20;
        valid = 16'b0000000000000001; // Enable only first Controller_PE
        #50;
        
        valid = 16'b0000000000000010; // Enable second Controller_PE
        #50;
        
        valid = 16'b1111111111111111; // Enable all Controller_PE
        #50;
        
        // Test Case 2: Disable controller and check if addresses reset
        #10;
        en = 0;
        #50;
        
        // Test Case 3: Enable again to verify continued counting
        #10;
        en = 1;
        #100;
        
        // Display results
        $display("Time = %0t", $time);
        $display("Addresses:");
        $display("addr_1: %h", addr_1);
        $display("addr_2: %h", addr_2);
        $display("addr_3: %h", addr_3);
        $display("addr_4: %h", addr_4);
        $display("addr_5: %h", addr_5);
        $display("addr_6: %h", addr_6);
        $display("addr_7: %h", addr_7);
        $display("addr_8: %h", addr_8);
        $display("addr_9: %h", addr_9);
        $display("addr_10: %h", addr_10);
        $display("addr_11: %h", addr_11);
        $display("addr_12: %h", addr_12);
        $display("addr_13: %h", addr_13);
        $display("addr_14: %h", addr_14);
        $display("addr_15: %h", addr_15);
        $display("addr_16: %h", addr_16);
        
        #10;
        $finish;
    end
endmodule
