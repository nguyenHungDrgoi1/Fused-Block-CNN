module Pre_ram_tb();

    reg clk, reset_n;
    reg [63:0] data_in ;
    reg read_req;
    reg we;
    reg [7:0] addr;
    wire  [256*8 - 1 : 0] data_out;

    always #5 clk = ~ clk;
    
    Pre_ram dut (
        .clk(clk),
        .reset_n(reset_n),
        .read_req(read_req),
        .we(we),
        .addr(addr),
        .data_out(data_out),
        .data_in(data_in)
    );

    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        we = 0;
        read_req = 0;
        addr = 0;
        data_in = 0;

        // Apply reset
        #10 reset_n = 1;
        #10;

        // Write test cases
        $display("Starting Write Operations...");
        we = 1;
        addr = 8'd10;  data_in = 64'hA5A5A5A5A5A5A5A5;  #10;
        addr = 8'd20;  data_in = 64'h5A5A5A5A5A5A5A5A;  #10;
        we = 0;
        #10
        read_req = 1;
        addr = 10;
        #100;
        // End simulation
        $finish;
    end
endmodule