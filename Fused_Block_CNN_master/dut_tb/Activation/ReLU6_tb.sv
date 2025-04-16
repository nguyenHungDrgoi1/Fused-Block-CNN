module ReLU6_tb;
    reg [7:0] OFM;
    wire [7:0] OFM_active;

    // Instantiate the ReLU6 module
    ReLU6 uut (
        .OFM(OFM),
        .OFM_active(OFM_active)
    );

    // Test vector
    initial begin
        // Initialize inputs
        OFM = 8'b00000000; // Test with minimum value
        #10;
        $display("OFM = %b, OFM_active = %b", OFM, OFM_active);

        OFM = 8'b00000110; // Test with value less than 6
        #10;
        $display("OFM = %b, OFM_active = %b", OFM, OFM_active);

        OFM = 8'b00000111; // Test with value equal to 6
        #10;
        $display("OFM = %b, OFM_active = %b", OFM, OFM_active);

        OFM = 8'b11111111; // Test with maximum value
        #10;
        $display("OFM = %b, OFM_active = %b", OFM, OFM_active);

        OFM = 8'b00001000; // Test with value greater than 6
        #10;
        $display("OFM = %b, OFM_active = %b", OFM, OFM_active);

        // Finish simulation
        $finish;
    end

    // Optional: monitor signals
    initial begin
        $monitor("At time %t, OFM = %b, OFM_active = %b", $time, OFM, OFM_active);
    end

endmodule
