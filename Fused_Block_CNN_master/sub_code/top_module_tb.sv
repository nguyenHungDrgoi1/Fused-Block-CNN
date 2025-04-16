`timescale 1ns / 1ps

module top_module_tb();
    reg clk;
    reg reset_n;
    reg en;
    reg we;
    reg [6:0] wr_addr;
    reg [12:0] rd_addr;
    reg [63:0] data_in;

    wire [7:0] data_1;
    wire [7:0] data_2;
    wire [7:0] data_3;
    wire [7:0] data_4;
    wire [7:0] data_5;
    wire [7:0] data_6;
    wire [7:0] data_7;
    wire [7:0] data_8;
    wire [7:0] data_9;
    wire [7:0] data_10;
    wire [7:0] data_11;
    wire [7:0] data_12;
    wire [7:0] data_13;
    wire [7:0] data_14;
    wire [7:0] data_15;
    wire [7:0] data_16;

    wire [15:0] valid_out;

    reg [7:0] data_in_8bit;

    parameter DEPTH = 128;
    parameter BYTES_PER_ENTRY = 8;

    integer file, file_valid, i, j, scan_result;
    integer file_data[0:15];  // Mảng lưu file pointer cho data_1 đến data_16
            int k = 0;

    top_module uut (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),

        .we(we),
        .wr_addr(wr_addr),
        .rd_addr(rd_addr),
        .data_in(data_in),

        .data_1(data_1),
        .data_2(data_2),
        .data_3(data_3),
        .data_4(data_4),
        .data_5(data_5),
        .data_6(data_6),
        .data_7(data_7),
        .data_8(data_8),
        .data_9(data_9),
        .data_10(data_10),
        .data_11(data_11),
        .data_12(data_12),
        .data_13(data_13),
        .data_14(data_14),
        .data_15(data_15),
        .data_16(data_16),

        .valid_out(valid_out)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        // Khởi tạo tín hiệu
        clk = 0;
        reset_n = 0;
        we = 0;
        en = 0;
        wr_addr = 0;
        rd_addr = 0;
        data_in = 0;

        // Mở file HEX chứa dữ liệu đầu vào
        file = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/input_7x7x5.hex", "r");
        if (file == 0) begin
            $display("❌ Lỗi: Không thể mở file input_7x7x5.hex!");
            $finish;
        end

        // Mở file để ghi giá trị valid_out
        file_valid = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/PE_valid.hex", "w");
        if (file_valid == 0) begin
            $display("❌ Lỗi: Không thể tạo file valid.hex!");
            $finish;
        end
        file_data[0]  = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_1.hex", "w");
        file_data[1]  = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_2.hex", "w");
        file_data[2]  = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_3.hex", "w");
        file_data[3]  = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_4.hex", "w");
        file_data[4]  = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_5.hex", "w");
        file_data[5]  = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_6.hex", "w");
        file_data[6]  = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_7.hex", "w");
        file_data[7]  = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_8.hex", "w");
        file_data[8]  = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_9.hex", "w");
        file_data[9]  = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_10.hex", "w");
        file_data[10] = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_11.hex", "w");
        file_data[11] = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_12.hex", "w");
        file_data[12] = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_13.hex", "w");
        file_data[13] = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_14.hex", "w");
        file_data[14] = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_15.hex", "w");
        file_data[15] = $fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/data_16.hex", "w");


        // Đọc dữ liệu từ file và ghi vào BRAM
        for (i = 0; i < DEPTH; i = i + 1) begin
            data_in = 0;
            for (j = 0; j < BYTES_PER_ENTRY; j = j + 1) begin
                scan_result = $fscanf(file, "%h\n", data_in_8bit);  // Đọc 8-bit HEX từ file
                if (scan_result == 1) begin
                    data_in = data_in | (data_in_8bit << (j * 8));  // Ghép thành 64-bit
                end
            end
            we = 1;
            wr_addr = i;
            #10;  // Chờ 1 chu kỳ clock để ghi vào BRAM
        end

        #10 we = 0;
        #20 reset_n = 1;
        #15
        en = 1;
        #90;
        // rd_addr = 13'h0x0010;
        // #90
        // rd_addr = 13'h0x0020;
        // #90
        // rd_addr = 13'h0x0030;
        // #90
        // rd_addr = 13'h0x0040;
        // #90
        // rd_addr = 13'h0x0050;
        // #90
        // rd_addr = 13'h0x0060;
        // #90
        // rd_addr = 13'h0x0070;
        // #90
        // rd_addr = 13'h0x0080;
        // #90
        // rd_addr = 13'h0x0090;
        // #90
        // rd_addr = 13'h0x00A0;
        // #90
        // rd_addr = 13'h0x00B0;
        // #90
        // rd_addr = 13'h0x00C0;
        // #90
        // rd_addr = 13'h0x00D0;
        // #90
        // rd_addr = 13'h0x00E0;
        // #90
        // rd_addr = 13'h0x00F0;
        // #90
        // rd_addr = 13'h0x0010;
        // #90
        // rd_addr = 13'h0x0020;
        // #90
        // rd_addr = 13'h0x0030;
        // #90
        // rd_addr = 13'h0x0040;
        // #90
        // rd_addr = 13'h0x0050;
        // #90
        // rd_addr = 13'h0x0060;
        // #90
        // rd_addr = 13'h0x0070;
        // #90
        // rd_addr = 13'h0x0080;
        // #90
        // rd_addr = 13'h0x0090;
        // #90
        // rd_addr = 13'h0x00a0;
        // #90
        // rd_addr = 13'h0x00b0;
        // #90
        // rd_addr = 13'h0x00c0;
        // #90
        // rd_addr = 13'h0x00d0;
        // #90
        // rd_addr = 13'h0x00e0;
        // #90
        // rd_addr = 13'h0x00f0;
        // #90

        // Ghi giá trị valid_out vào file valid.hex
       

        // Đóng file
    end
    initial begin
        #1415
        forever begin
            @(posedge clk)
            if(valid_out == 0)
            rd_addr = rd_addr + 16;
            @(posedge clk)
            if(rd_addr > 13'h0x00f0) rd_addr = 0;
        end

    end
    initial begin
        #1415
        forever begin
        @ ( posedge clk )
        k = k + 1;
        end
    end
    initial begin
            int count=0;
            forever begin
            @(posedge clk)
           // $fwrite(file_valid, "%h\n", valid_out);  // Ghi valid_out vào file HEX
            if(valid_out[0]) begin $fwrite(file_data[0], "%h\n", data_1);  count= count+1; end
            if(valid_out[1]) begin $fwrite(file_data[1], "%h\n", data_2); end
            if(valid_out[2]) begin $fwrite(file_data[2], "%h\n", data_3); end
            if(valid_out[3]) begin $fwrite(file_data[3], "%h\n", data_4); end
            if(valid_out[4]) begin $fwrite(file_data[4], "%h\n", data_5); end
            if(valid_out[5]) begin $fwrite(file_data[5], "%h\n", data_6); end
            if(valid_out[6]) begin $fwrite(file_data[6], "%h\n", data_7); end
            if(valid_out[7]) begin $fwrite(file_data[7], "%h\n", data_8); end
            if(valid_out[8]) begin $fwrite(file_data[8], "%h\n", data_9); end
            if(valid_out[9]) begin $fwrite(file_data[9], "%h\n", data_10); end
            if(valid_out[10]) begin $fwrite(file_data[10], "%h\n", data_11); end
            if(valid_out[11]) begin $fwrite(file_data[11], "%h\n", data_12); end
            if(valid_out[12]) begin $fwrite(file_data[12], "%h\n", data_13); end
            if(valid_out[13]) begin $fwrite(file_data[13], "%h\n", data_14); end
            if(valid_out[14]) begin $fwrite(file_data[14], "%h\n", data_15); end
            if(valid_out[15]) begin $fwrite(file_data[15], "%h\n", data_16); end
            $display("Time: %0t | Valid Out: %h", $time, valid_out);
            if(count == 90) begin 
                $display("%d",k);
                $finish; end
        end
    end
endmodule