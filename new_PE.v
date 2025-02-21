module new_PE(
    input  wire        clk,
    input  wire        reset_n,
    // 3 cặp IFM và Weight
    input  wire [7:0]  IFM1, IFM2, IFM3,
    input  wire [7:0]  Weight1, Weight2, Weight3,
    // Tín hiệu điều khiển
    input  wire        PE_en,      
    input  wire        PE_finish, 
    // Output
    output wire [7:0]  OFM,
    output wire        valid
);

    // --- Các wire trung gian ---
    wire [7:0] mul1, mul2, mul3;    // Kết quả 3 phép nhân
    wire [7:0] add1, add2;          // Kết quả cộng dồn từng bước
    wire [7:0] sum_d;               // Giá trị tổng mới
    reg  [7:0] sum_q;               // Thanh ghi lưu giá trị tổng
    reg        valid_r;             // Thanh ghi xuất cờ valid

    // Nhân 3 cặp IFM*Weight
    assign mul1 = IFM1 * Weight1;
    assign mul2 = IFM2 * Weight2;
    assign mul3 = IFM3 * Weight3;


    assign add1 = mul1 + mul2;
    assign add2 = add1 + mul3;


    assign sum_d = add2 + sum_q;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            sum_q <= 8'd0; 
        end else if (PE_en) begin 
            sum_q <= 8'd0;
        end else begin
            sum_q <= sum_d;
        end
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            valid_r <= 1'b0;
        end else if (PE_finish) begin
            // Khi PE_finish = 1, ta set valid=1 (bắn ra 1 chu kỳ)
            valid_r <= 1'b1;
        end else begin
            valid_r <= 1'b0;
        end
    end

    // Gán các ngõ ra
    assign OFM   = sum_q;
    assign valid = valid_r;

endmodule
