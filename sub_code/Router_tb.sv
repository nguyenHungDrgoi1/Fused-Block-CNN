`timescale 1ns / 1ps

module Router_tb;
    // Testbench signals
    reg [12:0] addr;
    reg [127:0] data_in;
    reg [12:0] addr_1, addr_2, addr_3, addr_4, addr_5, addr_6, addr_7, addr_8;
    reg [12:0] addr_9, addr_10, addr_11, addr_12, addr_13, addr_14, addr_15, addr_16;
    
    wire [7:0] data_1, data_2, data_3, data_4, data_5, data_6, data_7, data_8;
    wire [7:0] data_9, data_10, data_11, data_12, data_13, data_14, data_15, data_16;
    wire [15:0] valid;
    
    // Instantiate the Router module
    Router uut (
        .addr(addr),
        .data_in(data_in),
        .addr_1(addr_1), .addr_2(addr_2), .addr_3(addr_3), .addr_4(addr_4),
        .addr_5(addr_5), .addr_6(addr_6), .addr_7(addr_7), .addr_8(addr_8),
        .addr_9(addr_9), .addr_10(addr_10), .addr_11(addr_11), .addr_12(addr_12),
        .addr_13(addr_13), .addr_14(addr_14), .addr_15(addr_15), .addr_16(addr_16),
        .data_1(data_1), .data_2(data_2), .data_3(data_3), .data_4(data_4),
        .data_5(data_5), .data_6(data_6), .data_7(data_7), .data_8(data_8),
        .data_9(data_9), .data_10(data_10), .data_11(data_11), .data_12(data_12),
        .data_13(data_13), .data_14(data_14), .data_15(data_15), .data_16(data_16),
        .valid(valid)
    );
    
    initial begin
        // Test Case 1: Normal case with valid addresses
        addr = 13'h000;
        data_in = 128'h112233445566778899AABBCCDDEEFF00;
        addr_1 = 13'h000; addr_2 = 13'h001; addr_3 = 13'h002; addr_4 = 13'h003;
        addr_5 = 13'h004; addr_6 = 13'h007; addr_7 = 13'h008; addr_8 = 13'h009;
        addr_9 = 13'h0a; addr_10 = 13'h00b; addr_11 = 13'h00e; addr_12 = 13'h00f;
        addr_13 = 13'h010; addr_14 = 13'h011; addr_15 = 13'h012; addr_16 = 13'h015;
        
        #10;
        $display("Test Case 1 - Normal Case");
        $display("Valid Signals: %b", valid);
        
        // Test Case 2: All addresses out of range
        addr = 13'h050;
        addr_1 = 13'h100; addr_2 = 13'h101; addr_3 = 13'h102; addr_4 = 13'h103;
        addr_5 = 13'h104; addr_6 = 13'h105; addr_7 = 13'h106; addr_8 = 13'h107;
        addr_9 = 13'h108; addr_10 = 13'h109; addr_11 = 13'h10A; addr_12 = 13'h10B;
        addr_13 = 13'h10C; addr_14 = 13'h10D; addr_15 = 13'h10E; addr_16 = 13'h10F;
        
        #10;
        $display("Test Case 2 - Addresses Out of Range");
        $display("Valid Signals: %b", valid);
        
        // Test Case 3: Edge case where addr_1 is exactly addr
        addr = 13'h020;
        addr_1 = 13'h020; // Should be invalid
        addr_2 = 13'h021; // Should be valid
        
        #10;
        $display("Test Case 3 - Edge Case");
        $display("Valid Signals: %b", valid);
        
        #10;
        $finish;
    end
endmodule
