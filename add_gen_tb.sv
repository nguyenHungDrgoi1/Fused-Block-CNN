`timescale 1ps / 1ps

module address_generator_tb;

    parameter TOTAL_PE   = 16;
    parameter DATA_WIDTH = 32;

    reg clk;
    reg rst_n;
    reg [3:0] KERNEL_W;
    reg [7:0] OFM_C;
    reg [7:0] OFM_W;
    reg [7:0] IFM_C;
    reg [7:0] IFM_W;
    reg [1:0] stride;
    reg ready;
    reg [31:0] addr_in;
    
    wire [31:0] req_addr_out_ifm;
    wire [31:0] req_addr_out_filter;
    wire addr_valid_ifm;
    wire addr_valid_filter;
    wire done_compute;

    integer file_ifm, file_filter;

    // Instantiate the DUT
    address_generator #(
        .TOTAL_PE(TOTAL_PE),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .KERNEL_W(KERNEL_W),
        .OFM_C(OFM_C),
        .OFM_W(OFM_W),
        .IFM_C(IFM_C),
        .IFM_W(IFM_W),
        .stride(stride),
        .done_compute(done_compute),
        .ready(ready),
        .addr_in(addr_in),
        .req_addr_out_ifm(req_addr_out_ifm),
        .req_addr_out_filter(req_addr_out_filter),
        .addr_valid_ifm(addr_valid_ifm),
        .addr_valid_filter(addr_valid_filter)
    );

    // Clock generation
    always #2 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        KERNEL_W = 3;
        OFM_W = 8;
        IFM_C = 16;
        IFM_W = 10;
        OFM_C = 16;
        stride = 2;
        ready = 0;
        addr_in = 32'h0000;

        // Open files for writing
        file_ifm =  $fopen("/home/thanhdo/questasim/PE/Fused-Block-CNN/in-out-weight/addresses_ifm.hex", "w");
        file_filter =  $fopen("/home/thanhdo/questasim/PE/Fused-Block-CNN/in-out-weight/addresses_filter.hex", "w");
        
        // Apply reset
        #5 rst_n = 1;
        
        // Start test sequence
        #5 ready = 1;

        // Monitor and write to files
        while (!done_compute) begin
            @(negedge clk );
                if (addr_valid_ifm)
                    $fwrite(file_ifm,"%H\n", req_addr_out_ifm[15:0]);
                if (addr_valid_filter)
                    if (req_addr_out_ifm[3:0] != req_addr_out_filter[3:0])
                        $fwrite(file_filter,"time :%H / %t\n", req_addr_out_filter[15:0], $time);
                    else $fwrite(file_filter,"%H\n", req_addr_out_filter[15:0]);

        end
        
        // Close files
        $fclose(file_ifm);
        $fclose(file_filter);
        
        // Stop simulation
        $stop;
    end

endmodule
