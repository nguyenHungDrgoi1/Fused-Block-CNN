
`timescale 1 ns / 1 ps

	module Fused_block #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Master Bus Interface M00_AXI
		parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
		parameter integer C_M00_AXI_BURST_LEN	= 16,
		parameter integer C_M00_AXI_ID_WIDTH	= 1,
		parameter integer C_M00_AXI_ADDR_WIDTH	= 32,
		parameter integer C_M00_AXI_DATA_WIDTH	= 128,
		parameter integer C_M00_AXI_AWUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_ARUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_WUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_RUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_BUSER_WIDTH	= 0
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Master Bus Interface M00_AXI
		input start,
		
    
		input wire  m00_axi_init_axi_txn,
		output wire  m00_axi_txn_done,
		output wire  m00_axi_error,
		input wire  m00_axi_aclk,
		input wire  m00_axi_aresetn,
		output wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_awid,
		output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_awaddr,
		output wire [7 : 0] m00_axi_awlen,
		output wire [2 : 0] m00_axi_awsize,
		output wire [1 : 0] m00_axi_awburst,
		output wire  m00_axi_awlock,
		output wire [3 : 0] m00_axi_awcache,
		output wire [2 : 0] m00_axi_awprot,
		output wire [3 : 0] m00_axi_awqos,
		output wire [C_M00_AXI_AWUSER_WIDTH-1 : 0] m00_axi_awuser,
		output wire  m00_axi_awvalid,
		input wire  m00_axi_awready,
		output wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_wdata,
		output wire [C_M00_AXI_DATA_WIDTH/8-1 : 0] m00_axi_wstrb,
		output wire  m00_axi_wlast,
		output wire [C_M00_AXI_WUSER_WIDTH-1 : 0] m00_axi_wuser,
		output wire  m00_axi_wvalid,
		input wire  m00_axi_wready,
		input wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_bid,
		input wire [1 : 0] m00_axi_bresp,
		input wire [C_M00_AXI_BUSER_WIDTH-1 : 0] m00_axi_buser,
		input wire  m00_axi_bvalid,
		output wire  m00_axi_bready,
		output wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_arid,
		output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_araddr,
		output wire [7 : 0] m00_axi_arlen,
		output wire [2 : 0] m00_axi_arsize,
		output wire [1 : 0] m00_axi_arburst,
		output wire  m00_axi_arlock,
		output wire [3 : 0] m00_axi_arcache,
		output wire [2 : 0] m00_axi_arprot,
		output wire [3 : 0] m00_axi_arqos,
		output wire [C_M00_AXI_ARUSER_WIDTH-1 : 0] m00_axi_aruser,
		output wire  m00_axi_arvalid,
		input wire  m00_axi_arready,
		input wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_rid,
		input wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_rdata,
		input wire [1 : 0] m00_axi_rresp,
		input wire  m00_axi_rlast,
		input wire [C_M00_AXI_RUSER_WIDTH-1 : 0] m00_axi_ruser,
		input wire  m00_axi_rvalid,
		output wire  m00_axi_rready,
		input 	wire                  start_write,
		input wire [31:0] addr_write,
		output wire [127:0] data_out_reg_fused,
    output  wire                    done
	);
       localparam base_addr_IFM = 32'h0000_0000;
       localparam  size_IFM = 32'h32C40;
        localparam base_addr_Weight_layer_1 = 32'h32C40;
        localparam size_Weight_layer_1 = 32'h2400;
        localparam base_addr_Weight_layer_2 = 32'h0035040;
        localparam size_Weight_layer_2 = 32'h800;
        localparam KERNEL_W = 3;
        localparam OFM_W = 56;
        localparam OFM_C = 64;
        localparam IFM_C = 16;
        localparam IFM_W = 114;
        localparam stride = 2;
        localparam IFM_C_layer2 = 64;
        localparam OFM_C_layer2 = 32;
        localparam OFM_W_layer2 = 56;
        localparam data_in = 128'h1231_3212_abde_aa4c_123d_321f_abde_aa4c ;

    wire start_read;
    wire [31:0] addr_read;
    //wire [127:0] data_in;
	wire [127:0] data_out;

	wire [31:0] wr_addr_fused;
    wire [20:0] we_fused;
    
    //wire for Weight connect to PE_1x1 from BRAM
    wire [31:0] Weight_0_n_state;
    wire [31:0] Weight_1_n_state;
    wire [31:0] Weight_2_n_state;
    wire [31:0] Weight_3_n_state;
    wire [31:0] addr_ram_next_rd;
    wire [31:0] addr_w_n_state;

    wire [31:0] wr_addr_fused;
    wire [31:0] rd_addr_fused;
    wire [20:0] we_fused;
     //Write to PE_cluster
    wire [7:0]  OFM_0;
    wire [7:0]  OFM_1;
    wire [7:0]  OFM_2;
    wire [7:0]  OFM_3;
    wire [7:0]  OFM_4;
    wire [7:0]  OFM_5;
    wire [7:0]  OFM_6;
    wire [7:0]  OFM_7;
    wire [7:0]  OFM_8;
    wire [7:0]  OFM_9;
    wire [7:0]  OFM_10;
    wire [7:0]  OFM_11;
    wire [7:0]  OFM_12;
    wire [7:0]  OFM_13;
    wire [7:0]  OFM_14;
    wire [7:0]  OFM_15;
    wire [7:0]  OFM_16;
    wire [31:0] addr_IFM;
    wire [19:0] addr_w;
    wire [31:0] IFM_data;
    wire [31:0] Weight_0;
    wire [31:0] Weight_1;
    wire [31:0] Weight_2;
    wire [31:0] Weight_3;
    wire [31:0] Weight_4;
    wire [31:0] Weight_5;
    wire [31:0] Weight_6;
    wire [31:0] Weight_7;
    wire [31:0] Weight_8;
    wire [31:0] Weight_9;
    wire [31:0] Weight_10;
    wire [31:0] Weight_11;
    wire [31:0] Weight_12;
    wire [31:0] Weight_13;
    wire [31:0] Weight_14;
    wire [31:0] Weight_15; 
    wire [31:0] out_BRAM_CONV;
    wire        wr_data_valid;
    wire [15:0] done_window_for_PE_cluster;
     wire [15:0] finish_for_PE_cluster;
    wire        done_window_one_bit;
    wire        finish_for_PE;
    // wire [7:0] count_for_a_OFM_o;
    
    wire        addr_valid;
    wire [7:0]  tile;
    wire        cal_start_ctl;
    // wire        wr_rd_req_IFM;
    // wire        wr_rd_req_Weight;
    // wire [31:0] wr_addr_Weight;
    // wire [31:0] wr_addr_IFM;

    // wire data_mux and register for pipeline
    wire [3:0] PE_reset_n_state_wire;
    wire [31:0] data_out_mux;
    wire [7:0]  OFM_n_CONV_0;
    wire [7:0]  OFM_n_CONV_1;
    wire [7:0]  OFM_n_CONV_2;
    wire [7:0]  OFM_n_CONV_3;
    wire [7:0]  OFM_n_CONV_4;
    wire [7:0]  OFM_n_CONV_5;
    wire [7:0]  OFM_n_CONV_6;
    wire [7:0]  OFM_n_CONV_7;
    wire [7:0]  OFM_n_CONV_8;
    wire [7:0]  OFM_n_CONV_9;
    wire [7:0]  OFM_n_CONV_10;
    wire [7:0]  OFM_n_CONV_11;
    wire [7:0]  OFM_n_CONV_12;
    wire [7:0]  OFM_n_CONV_13;
    wire [7:0]  OFM_n_CONV_14;
    wire [7:0]  OFM_n_CONV_15;
    wire [7:0]  OFM_n_CONV_16;
    wire [15:0] valid;
    wire  [127:0] data_write_pipeline_bram;

    wire [7:0]  OFM_active_0;
    wire [7:0]  OFM_active_1;
    wire [7:0]  OFM_active_2;
    wire [7:0]  OFM_active_3;
    wire [7:0]  OFM_active_4;
    wire [7:0]  OFM_active_5;
    wire [7:0]  OFM_active_6;
    wire [7:0]  OFM_active_7;
    wire [7:0]  OFM_active_8;
    wire [7:0]  OFM_active_9;
    wire [7:0]  OFM_active_10;
    wire [7:0]  OFM_active_11;
    wire [7:0]  OFM_active_12;
    wire [7:0]  OFM_active_13;
    wire [7:0]  OFM_active_14;
    wire [7:0]  OFM_active_15;
    wire [7:0]  OFM_active_16;
    wire [31:0] base_addr =0;
    wire  [127:0] data_out_global_BRAM;

    //output fused signal
    wire [7:0] OFM_0_n_state;
    wire [7:0] OFM_1_n_state;
    wire [7:0] OFM_2_n_state;
    wire [7:0] OFM_3_n_state;
    wire done_compute;
    //controller 1x1 add signal 
    wire [3:0] PE_finish_PE_cluster1x1;

    //global signal
    wire [127:0] store_in_global_RAM;
    wire [127:0] data_in_global;

    //register fused
    wire we_out_reg_fused;
    
    wire  valid_dram ;
    wire [127:0] data_out ;

    reg [31:0] IFM_data_q ; 

// Instantiation of Axi Bus Interface M00_AXI
	// Add user wire here
		assign  m00_axi_txn_done = 0 ;
		assign  m00_axi_error = 0;
        assign  m00_axi_awid = 0;
        assign  m00_axi_awlen = 0;
		assign  m00_axi_awsize = 3'b100;
		assign  m00_axi_awburst = 1;
        assign  m00_axi_awlock = 0;
		assign  m00_axi_awcache = 0;
		assign  m00_axi_awprot = 0;
		assign  m00_axi_awqos = 0;
		assign  m00_axi_awuser = 1;
        assign  m00_axi_wstrb = 16'b1111_1111_1111_1111;
        assign  m00_axi_wuser = 0;
        assign  m00_axi_arid = 0;
        assign  m00_axi_arlen = 127;
		assign  m00_axi_arsize = 3'b100;
		assign  m00_axi_arburst = 1;
		assign  m00_axi_arlock = 0;
		assign  m00_axi_arcache = 0;
		assign  m00_axi_arprot = 0;
		assign  m00_axi_arqos = 0;
        assign  m00_axi_aruser =  1;
        assign data_out_check = (data_out == 128'h1111_1111_1111_1111) ? 1 : 0;
	// User wire ends

	    DRAM_Global_top_fused_control_unit Global_control_unit(
        .clk(m00_axi_aclk),
        .reset_n(m00_axi_aresetn),
        .start(start),
        .ready(ready),
        .IFM_C(IFM_C),
        .IFM_W(IFM_W),

    // Global BRAM signal
        //.wr_addr_global(wr_addr_global_ctl),

    // Load BRAM signal
        .wr_addr_fused(wr_addr_fused),
        .rd_addr_fused(rd_addr_fused),
        .we_fused(we_fused),


    //signal for infor of size
        .base_addr_IFM(base_addr_IFM),
        .size_IFM(size_IFM),
        .base_addr_Weight_layer_1(base_addr_Weight_layer_1),
        .size_Weight_layer_1(size_Weight_layer_1),
        .base_addr_Weight_layer_2(base_addr_Weight_layer_2),
        .size_Weight_layer_2(size_Weight_layer_2),
        .start_read(start_read),
        .addr_read(addr_read),

    // write on Global BRAN
        .valid_layer2(we_global_ctl),
        .valid_data(valid_dram),
        .done_compute(done_compute)
    );

    AXI_master master(
    .clk(m00_axi_aclk),
    .reset_n(m00_axi_aresetn),
  	.awvalid(m00_axi_awvalid),
  	.awready(m00_axi_awready),
  	.awaddr(m00_axi_awaddr),
  	.wvalid(m00_axi_wvalid),
  	.wready(m00_axi_wready),
  	.wdata(m00_axi_wdata),
  	.wlast(m00_axi_wlast),
  	.bvalid(m00_axi_bvalid),
  	.bready(m00_axi_bready),
  	.bresp(m00_axi_bresp),
  	.arvalid(m00_axi_arvalid),
  	.arready(m00_axi_arready),
  	.araddr(m00_axi_araddr),
  	.rvalid(m00_axi_rvalid),
  	.rready(m00_axi_rready),
  	.rdata(m00_axi_rdata),
  	.rresp(m00_axi_rresp),
  	.rlast(m00_axi_rlast),
  	.start_write(start_write),
  	.start_read(start_read),
  	.addr_read(addr_read),
  	.addr_write(addr_write),
  	.data_in(data_in),
  	.valid(valid_dram),
  	.data_out(data_out)
    );
	

	 BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(20000),
        .off_set_shift(4)
    )BRAM_IFM(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[20]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_IFM),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(IFM_data)               // Dữ liệu ra
    );

    always@(posedge clk or negedge m00_axi_aresetn) begin
        if(~m00_axi_aresetn) begin
            IFM_data_q <= 0;
        end
        else begin
            IFM_data_q <= IFM_data;
        end
    end
    
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_0_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[0]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_0)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_1_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[1]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_1)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_2_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[2]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_2)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_3_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[3]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_3)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_4_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[4]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_4)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_5_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[5]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_5)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_6_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[6]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_6)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_7_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[7]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_7)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_8_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[8]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_8)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_9_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[9]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_9)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_10_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[10]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_10)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_11_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[11]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_11)              // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_12_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[12]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_12)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_13_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[13]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_13)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_14_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[14]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_14)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_15_layer1(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[15]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_15)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_0_layer2(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[16]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w_n_state),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_0_n_state)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_1_layer2(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[17]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w_n_state),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_1_n_state)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_2_layer2(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[18]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w_n_state),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_2_n_state)               // Dữ liệu ra
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4)
    )BRAM_Weight_3_layer2(
    .clk(m00_axi_aclk),
    .wr_rd_en(we_fused[19]),                               // Write enable
    .wr_addr(wr_addr_fused),            // Địa chỉ ghi
    .rd_addr(addr_w_n_state),  // Địa chỉ đọc (địa chỉ byte → cần dịch)
    .data_in(data_out),               // Dữ liệu vào
    .data_out(Weight_3_n_state)               // Dữ liệu ra
    );
    address_generator addr_gen(
        .clk(m00_axi_aclk),
        .rst_n(m00_axi_aresetn),
        .KERNEL_W(KERNEL_W),
        .OFM_W(OFM_W),
        .OFM_C(OFM_C),
        .IFM_C(IFM_C),
        .IFM_W(IFM_W),
        .stride(stride),
        //.ready(cal_start),
        .ready(ready),
        .addr_in(base_addr),
        .req_addr_out_filter(addr_w),
        .req_addr_out_ifm(addr_IFM),
        .done_compute(done_compute),
        .done_window(done_window_one_bit),
        .finish_for_PE(finish_for_PE),
        .addr_valid_filter(addr_valid),
        .num_of_tiles_for_PE(tile)
    );

    CONV_1x1_controller CONV_1x1_controller_inst(
        .clk(m00_axi_aclk),
        .reset_n(m00_axi_aresetn),
        .valid(wr_data_valid),
        .weight_c(IFM_C_layer2),
        .num_filter(OFM_C_layer2),
        .cal_start(ready),
        .addr_ifm(addr_ram_next_rd),
        .addr_weight(addr_w_n_state),
        .PE_reset(PE_reset_n_state_wire),
        .PE_finish(PE_finish_PE_cluster1x1)
    );

    //
    PE_cluster_1x1 PE_cluster_1x1(
        .clk(m00_axi_aclk),
        .reset_n(m00_axi_aresetn),
        .PE_reset(PE_reset_n_state_wire),
        .Weight_0(Weight_0_n_state),
        .Weight_1(Weight_1_n_state),
        .Weight_2(Weight_2_n_state),
        .Weight_3(Weight_3_n_state),
        .IFM(out_BRAM_CONV),
        .OFM_0(OFM_0_n_state),
        .OFM_1(OFM_1_n_state),
        .OFM_2(OFM_2_n_state),
        .OFM_3(OFM_3_n_state)
    );
    
    PE_cluster PE_cluster_layer1(
        .clk(m00_axi_aclk),
        .reset_n(m00_axi_aresetn),
        .PE_reset(done_window_for_PE_cluster),
        .PE_finish(PE_finish),
        //.valid(valid),
        .IFM(IFM_data_q),
        .Weight_0(Weight_0),
        .Weight_1(Weight_1),
        .Weight_2(Weight_2),
        .Weight_3(Weight_3),
        .Weight_4(Weight_4),
        .Weight_5(Weight_5),
        .Weight_6(Weight_6),
        .Weight_7(Weight_7),
        .Weight_8(Weight_8),
        .Weight_9(Weight_9),
        .Weight_10(Weight_10),
        .Weight_11(Weight_11),
        .Weight_12(Weight_12),
        .Weight_13(Weight_13),
        .Weight_14(Weight_14),
        .Weight_15(Weight_15),
        .OFM_0(OFM_0),
        .OFM_1(OFM_1),
        .OFM_2(OFM_2),
        .OFM_3(OFM_3),
        .OFM_4(OFM_4),
        .OFM_5(OFM_5),
        .OFM_6(OFM_6),
        .OFM_7(OFM_7),
        .OFM_8(OFM_8),
        .OFM_9(OFM_9),
        .OFM_10(OFM_10),
        .OFM_11(OFM_11),
        .OFM_12(OFM_12),
        .OFM_13(OFM_13),
        .OFM_14(OFM_14),
        .OFM_15(OFM_15)
    );
    ReLU6 active0(
        .OFM(OFM_0),
        .OFM_active(OFM_active_0)
    );
    ReLU6 active1(
        .OFM(OFM_1),
        .OFM_active(OFM_active_1)
    );
    ReLU6 active2(
        .OFM(OFM_2),
        .OFM_active(OFM_active_2)
    );
    ReLU6 active3(
        .OFM(OFM_3),
        .OFM_active(OFM_active_3)
    );
    ReLU6 active4(
        .OFM(OFM_4),
        .OFM_active(OFM_active_4)
    );
    ReLU6 active5(
        .OFM(OFM_5),
        .OFM_active(OFM_active_5)
    );
    ReLU6 active6(
        .OFM(OFM_6),
        .OFM_active(OFM_active_6)
    );
    ReLU6 active7(
        .OFM(OFM_7),
        .OFM_active(OFM_active_7)
    );
    ReLU6 active8(
        .OFM(OFM_8),
        .OFM_active(OFM_active_8)
    );
    ReLU6 active9(
        .OFM(OFM_9),
        .OFM_active(OFM_active_9)
    );
    ReLU6 active10(
        .OFM(OFM_10),
        .OFM_active(OFM_active_10)
    );
    ReLU6 active11(
        .OFM(OFM_11),
        .OFM_active(OFM_active_11)
    );
    ReLU6 active12(
        .OFM(OFM_12),
        .OFM_active(OFM_active_12)
    );
    ReLU6 active13(
        .OFM(OFM_13),
        .OFM_active(OFM_active_13)
    );
    ReLU6 active14(
        .OFM(OFM_14),
        .OFM_active(OFM_active_14)
    );
    ReLU6 active15(
        .OFM(OFM_15),
        .OFM_active(OFM_active_15)
    );

    assign done_window_for_PE_cluster       =   {16{done_window_one_bit}};
    assign finish_for_PE_cluster            =   1 && ( addr_IFM != 'b0 )   ? {16{finish_for_PE}} : 16'b0;
    assign valid                            =   finish_for_PE_cluster;




    wire [1:0]  control_mux_wire;
    wire [31:0] addr_ram_next_wr_wire;
    wire        wr_en_next_write;

 assign data_write_pipeline_bram = {OFM_active_15,OFM_active_14,OFM_active_13,OFM_active_12,OFM_active_11,OFM_active_10,OFM_active_9,OFM_active_8,OFM_active_7,OFM_active_6,OFM_active_5,OFM_active_4,OFM_active_3,OFM_active_2,OFM_active_1,OFM_active_0};
    Write_for_Bram_controller data_write_controller(
        .clk(clk),
        .reset_n(reset_n),
        .OFM_C(IFM_C_layer2),
        .valid(finish_for_PE),
        .write_addr(addr_ram_next_wr_wire)
    );
    BRAM_General_weight #(
        .DATA_WIDTH_IN(128),
        .DATA_WIDTH_OUT(32),
        .DEPTH(360),
        .off_set_shift(4) 
        )BRAM_IFM_layer2(
        .clk(clk),
        .rd_addr(addr_ram_next_rd),
        .wr_addr(addr_ram_next_wr_wire),
        .wr_rd_en(done_window_one_bit),
        .data_in(data_write_pipeline_bram),
        .data_out(out_BRAM_CONV)
    );

    Register_for_fused reg_for_write_in_global(
        .clk(m00_axi_aclk),
        .reset_n(m00_axi_aresetn),
        .data_in({OFM_3_n_state,OFM_2_n_state,OFM_1_n_state,OFM_0_n_state}),
        .valid(PE_finish_PE_cluster1x1),
        .data_out(data_out_reg_fused),
        .valid_out(we_out_reg_fused)
    );
    
    
    
    
    


	endmodule
