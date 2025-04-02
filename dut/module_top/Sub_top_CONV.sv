module Sub_top_CONV(
    input clk,
    input reset,
    input [31:0] addr,
    input wr_rd_en_IFM,
    input wr_rd_en_Weight,
    input cal_start,
    input [31:0] data_in_IFM,
    input [31:0] data_in_Weight_0,
    input [31:0] data_in_Weight_1,
    input [31:0] data_in_Weight_2,
    input [31:0] data_in_Weight_3,
    input [31:0] data_in_Weight_4,
    input [31:0] data_in_Weight_5,
    input [31:0] data_in_Weight_6,
    input [31:0] data_in_Weight_7,
    input [31:0] data_in_Weight_8,
    input [31:0] data_in_Weight_9,
    input [31:0] data_in_Weight_10,
    input [31:0] data_in_Weight_11,
    input [31:0] data_in_Weight_12,
    input [31:0] data_in_Weight_13,
    input [31:0] data_in_Weight_14,
    input [31:0] data_in_Weight_15,

    input [31:0] data_in_Weight_0_n_state,  // layer 2
    input [31:0] data_in_Weight_1_n_state,  // layer 2
    input [31:0] data_in_Weight_2_n_state,  // layer 2
    input [31:0] data_in_Weight_3_n_state,  // layer 2
    input [1:0]  control_mux,               // controll  layer1_2
    input wr_en_next,                       // controll  layer1_2

    //next state pipeline
    input [31:0] addr_ram_next_rd,
    input [31:0] addr_ram_next_wr,
    input [3:0] PE_reset_n_state,
    input [31:0] addr_w_n_state,
    output [7:0] OFM_0_n_state,
    output [7:0] OFM_1_n_state,
    output [7:0] OFM_2_n_state,
    output [7:0] OFM_3_n_state,
    

    //control signal layer 1
    input wire [15:0] PE_reset,
    input wire [15:0] PE_finish,

    input  wire [3:0] KERNEL_W,
    input  wire [7:0] OFM_W,
    input  wire [7:0] OFM_C,
    input  wire [7:0] IFM_C,
    input  wire [7:0] IFM_W,
    input  wire [1:0] stride,
    output wire [15:0] valid,
    //output wire [15:0] done_window,
    output wire        done_compute,
    


    // for Control_unit
    input  wire        run,
    input  wire [3:0]  instrution,
    output wire        wr_rd_req_IFM_for_tb,
    output wire [31:0] wr_addr_IFM_for_tb,
    output wire        wr_rd_req_Weight_for_tb,
    output wire [31:0] wr_addr_Weight_for_tb,


    output wire [7:0]  OFM_active_0,
    output wire [7:0]  OFM_active_1,
    output wire [7:0]  OFM_active_2,
    output wire [7:0]  OFM_active_3,
    output wire [7:0]  OFM_active_4,
    output wire [7:0]  OFM_active_5,
    output wire [7:0]  OFM_active_6,
    output wire [7:0]  OFM_active_7,
    output wire [7:0]  OFM_active_8,
    output wire [7:0]  OFM_active_9,
    output wire [7:0]  OFM_active_10,
    output wire [7:0]  OFM_active_11,
    output wire [7:0]  OFM_active_12,
    output wire [7:0]  OFM_active_13,
    output wire [7:0]  OFM_active_14,
    output wire [7:0]  OFM_active_15,
    output wire [7:0]  OFM_active_16
);

    //wire for Weight connect to PE_1x1 from BRAM
    logic [31:0] Weight_0_n_state;
    logic [31:0] Weight_1_n_state;
    logic [31:0] Weight_2_n_state;
    logic [31:0] Weight_3_n_state;


    //wire to PE_cluster
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
    logic [31:0] addr_IFM;
    logic [19:0] addr_w;
    logic [31:0] IFM_data;
    logic [31:0] Weight_0;
    logic [31:0] Weight_1;
    logic [31:0] Weight_2;
    logic [31:0] Weight_3;
    logic [31:0] Weight_4;
    logic [31:0] Weight_5;
    logic [31:0] Weight_6;
    logic [31:0] Weight_7;
    logic [31:0] Weight_8;
    logic [31:0] Weight_9;
    logic [31:0] Weight_10;
    logic [31:0] Weight_11;
    logic [31:0] Weight_12;
    logic [31:0] Weight_13;
    logic [31:0] Weight_14;
    logic [31:0] Weight_15;

    wire [31:0] out_BRAM_CONV;
    // wire data_mux and register for pipeline
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

    // wire [7:0]  OFM_active_0;
    // wire [7:0]  OFM_active_1;
    // wire [7:0]  OFM_active_2;
    // wire [7:0]  OFM_active_3;
    // wire [7:0]  OFM_active_4;
    // wire [7:0]  OFM_active_5;
    // wire [7:0]  OFM_active_6;
    // wire [7:0]  OFM_active_7;
    // wire [7:0]  OFM_active_8;
    // wire [7:0]  OFM_active_9;
    // wire [7:0]  OFM_active_10;
    // wire [7:0]  OFM_active_11;
    // wire [7:0]  OFM_active_12;
    // wire [7:0]  OFM_active_13;
    // wire [7:0]  OFM_active_14;
    // wire [7:0]  OFM_active_15;


    wire [15:0] done_window_for_PE_cluster;
    wire [15:0] finish_for_PE_cluster;
    wire        done_window_one_bit;
    wire        finish_for_PE;
    wire [7:0] count_for_a_OFM_o;
    
    wire        addr_valid;
    wire [7:0]  tile;
    wire        cal_start_ctl;
    wire        wr_rd_req_IFM;
    wire        wr_rd_req_Weight;
    wire [31:0] wr_addr_Weight;
    wire [31:0] wr_addr_IFM;

    logic [31:0] base_addr =0;

    Control_unit Control_unit(
        .clk(clk),
        .rst_n(reset),
        .run(run),
        .instrution(instrution),
        .KERNEL_W(KERNEL_W),
        .OFM_W(OFM_W),
        .OFM_C(OFM_C),
        .IFM_C(IFM_C),
        .IFM_W(IFM_W),
        .stride(stride),
        .addr_valid(addr_valid),
        .done_compute(done_compute),
        .tile(tile),
        .cal_start(cal_start_ctl),
        .wr_rd_req_IFM(wr_rd_req_IFM),
        .wr_addr_IFM(wr_addr_IFM),
        .wr_rd_req_Weight(wr_rd_req_Weight),
        .wr_addr_Weight(wr_addr_Weight),
        .base_addr(),
        .current_state_o()
    );

    assign wr_rd_req_IFM_for_tb = wr_rd_req_IFM;
    assign wr_addr_IFM_for_tb   = wr_addr_IFM;
    assign wr_rd_req_Weight_for_tb = wr_rd_req_Weight;
    assign wr_addr_Weight_for_tb   = wr_addr_Weight;

    BRAM_IFM IFM_BRAM(
        .clk(clk),
        .rd_addr(addr_IFM),
        .wr_addr(wr_addr_IFM),
        //.wr_rd_en(wr_rd_en_IFM),
        .wr_rd_en(wr_rd_req_IFM),
        .data_in(data_in_IFM),
        .data_out(IFM_data)
    );
    BRAM BRam_Weight_0_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_0),
        .data_out(Weight_0)
    );
    BRAM BRam_Weight_1_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_1),
        .data_out(Weight_1)
    );
    BRAM BRam_Weight_2_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_2),
        .data_out(Weight_2)
    );
    BRAM BRam_Weight_3_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_3),
        .data_out(Weight_3)
    );
    BRAM BRam_Weight_4_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_4),
        .data_out(Weight_4)
    );
    BRAM BRam_Weight_5_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_5),
        .data_out(Weight_5)
    );
    BRAM BRam_Weight_6_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_6),
        .data_out(Weight_6)
    );
    BRAM BRam_Weight_7_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
.wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_7),
        .data_out(Weight_7)
    );
    BRAM BRam_Weight_8_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_8),
        .data_out(Weight_8)
    );
    BRAM BRam_Weight_9_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_9),
        .data_out(Weight_9)
    );
    BRAM BRam_Weight_10_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_10),
        .data_out(Weight_10)
    );
    BRAM BRam_Weight_11_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_11),
        .data_out(Weight_11)
    );
    BRAM BRam_Weight_12_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_12),
        .data_out(Weight_12)
    );
    BRAM BRam_Weight_13_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_13),
        .data_out(Weight_13)
    );
    BRAM BRam_Weight_14_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_14),
        .data_out(Weight_14)
    );
    BRAM BRam_Weight_15_layer1(
        .clk(clk),
        .rd_addr(addr_w),
        .wr_addr(wr_addr_Weight),
        //.wr_rd_en(wr_rd_en_Weight),
        .wr_rd_en(wr_rd_req_Weight),
        .data_in(data_in_Weight_15),
        .data_out(Weight_15)
    );
    
    PE_cluster PE_cluster_layer1(
        .clk(clk),
        .reset_n(reset),
        .PE_reset(done_window_for_PE_cluster),
        .PE_finish(PE_finish),
        //.valid(valid),
        .IFM(IFM_data),
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
    
    address_generator addr_gen(
        .clk(clk),
        .rst_n(reset),
        .KERNEL_W(KERNEL_W),
        .OFM_W(OFM_W),
        .OFM_C(OFM_C),
        .IFM_C(IFM_C),
        .IFM_W(IFM_W),
        .stride(stride),
        //.ready(cal_start),
        .ready(cal_start_ctl),
        .addr_in(base_addr),
        .req_addr_out_filter(addr_w),
        .req_addr_out_ifm(addr_IFM),
        .done_compute(done_compute),
        .done_window(done_window_one_bit),
        .finish_for_PE(finish_for_PE),
        .addr_valid_filter(addr_valid),
        .num_of_tiles_for_PE(tile)
    );
    assign done_window_for_PE_cluster       =   {16{done_window_one_bit}};
    assign finish_for_PE_cluster            =   (cal_start_ctl) && ( addr_IFM != 'b0 )   ? {16{finish_for_PE}} : 16'b0;
    assign valid                            =   finish_for_PE_cluster;



    Register_for_pipeline Reg_1(
        .clk(clk),
        .reset_n(reset_n),
        .valid_data(done_window_for_PE_cluster),
        .data_in_0(OFM_active_0),
        .data_in_1(OFM_active_1),
        .data_in_2(OFM_active_2),
        .data_in_3(OFM_active_3),
        .data_in_4(OFM_active_4),
        .data_in_5(OFM_active_5),
        .data_in_6(OFM_active_6),
        .data_in_7(OFM_active_7),
        .data_in_8(OFM_active_8),
        .data_in_9(OFM_active_9),
        .data_in_10(OFM_active_10),
        .data_in_11(OFM_active_11),
        .data_in_12(OFM_active_12),
        .data_in_13(OFM_active_13),
        .data_in_14(OFM_active_14),
        .data_in_15(OFM_active_15),
        .data_out_0(OFM_n_CONV_0),
        .data_out_1(OFM_n_CONV_1),
        .data_out_2(OFM_n_CONV_2),
        .data_out_3(OFM_n_CONV_3),
        .data_out_4(OFM_n_CONV_4),
        .data_out_5(OFM_n_CONV_5),
        .data_out_6(OFM_n_CONV_6),
        .data_out_7(OFM_n_CONV_7),
        .data_out_8(OFM_n_CONV_8),
        .data_out_9(OFM_n_CONV_9),
        .data_out_10(OFM_n_CONV_10),
        .data_out_11(OFM_n_CONV_11),
        .data_out_12(OFM_n_CONV_12),
        .data_out_13(OFM_n_CONV_13),
        .data_out_14(OFM_n_CONV_14),
        .data_out_15(OFM_n_CONV_15)
    );

    Data_controller Data_controller_inst(
        .clk(clk),
        .rst_n(reset),
        .OFM_out_valid(valid),
        .control_mux(),
        .addr_ram_next_wr(),
        .wr_en_next()
    );

    MUX_pipeline mux(
        .control(control_mux),

        .data_in_0(OFM_n_CONV_0),
        .data_in_1(OFM_n_CONV_1),
        .data_in_2(OFM_n_CONV_2),
        .data_in_3(OFM_n_CONV_3),
        .data_in_4(OFM_n_CONV_4),
        .data_in_5(OFM_n_CONV_5),
        .data_in_6(OFM_n_CONV_6),
        .data_in_7(OFM_n_CONV_7),
        .data_in_8(OFM_n_CONV_8),
        .data_in_9(OFM_n_CONV_9),
        .data_in_10(OFM_n_CONV_10),
        .data_in_11(OFM_n_CONV_11),
        .data_in_12(OFM_n_CONV_12),
        .data_in_13(OFM_n_CONV_13),
        .data_in_14(OFM_n_CONV_14),
        .data_in_15(OFM_n_CONV_15),

        .data_out(data_out_mux)
    );

    BRAM_IFM BRAM_IFM_layer2(
        .clk(clk),
        .rd_addr(addr_ram_next_rd),
        .wr_addr(addr_ram_next_wr),
        .wr_rd_en(wr_en_next),
        .data_in(data_out_mux),
        .data_out(out_BRAM_CONV)
    );

    BRAM BRAM_Weight_0_layer2(
        .clk(clk),
        .rd_addr(addr_w_n_state),
        .wr_addr(addr),
        .wr_rd_en(wr_rd_en_Weight),
        .data_in(data_in_Weight_0_n_state),
        .data_out(Weight_0_n_state)
    );
    BRAM BRAM_Weight_1_layer2(
        .clk(clk),
        .rd_addr(addr_w_n_state),
        .wr_addr(addr),
        .wr_rd_en(wr_rd_en_Weight),
        .data_in(data_in_Weight_1_n_state),
        .data_out(Weight_1_n_state)
    );
    BRAM BRAM_Weight_2_layer2(
        .clk(clk),
        .rd_addr(addr_w_n_state),
        .wr_addr(addr),
        .wr_rd_en(wr_rd_en_Weight),
        .data_in(data_in_Weight_2_n_state),
        .data_out(Weight_2_n_state)
    );
    BRAM BRAM_Weight_3_layer2(
        .clk(clk),
        .rd_addr(addr_w_n_state),
        .wr_addr(addr),
        .wr_rd_en(wr_rd_en_Weight),
        .data_in(data_in_Weight_3_n_state),
        .data_out(Weight_3_n_state)
    );

    PE_cluster_1x1 PE_cluster_1x1(
        .clk(clk),
        .reset_n(reset),
        .PE_reset(PE_reset_n_state),
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


endmodule