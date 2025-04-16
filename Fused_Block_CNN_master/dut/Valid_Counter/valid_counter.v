module valid_counter #(
    parameter WIDTH = 10
)(
    input wire clk,
    input wire rst_n,                       // active-low reset
    input wire valid_in,                   // tín hiệu từ PE_Cluster 
    input wire [3:0] PE_number,            // PE: 2, 4, 16
    input wire [10:0] IFM_C,               // IFM channel
    output reg valid_out                   // valid đến khối sau
);

    reg [WIDTH-1:0] counter;
    reg [WIDTH-1:0] threshold;

    // LUT for threshold values based on IFM_C and PE_number
    // IFM_C: 16, 32, 64, 128, 192, 96, 384, 576, 112, 672, 1152
    always @(*) begin
        case ({IFM_C, PE_number})
            {11'd16 ,  4'd2 } : threshold = 8;
            {11'd32 ,  4'd2 } : threshold = 16;
            {11'd64 ,  4'd2 } : threshold = 32;
            {11'd128,  4'd2 } : threshold = 64;
            {11'd192,  4'd2 } : threshold = 96;
            {11'd96 ,  4'd2 } : threshold = 48;
            {11'd384,  4'd2 } : threshold = 192;
            {11'd576,  4'd2 } : threshold = 288;
            {11'd112,  4'd2 } : threshold = 56;
            {11'd672,  4'd2 } : threshold = 336;
            {11'd1152, 4'd2 } : threshold = 576;

            {11'd16 ,  4'd4 } : threshold = 4;
            {11'd32 ,  4'd4 } : threshold = 8;
            {11'd64 ,  4'd4 } : threshold = 16;
            {11'd128,  4'd4 } : threshold = 32;
            {11'd192,  4'd4 } : threshold = 48;
            {11'd96 ,  4'd4 } : threshold = 24;
            {11'd384,  4'd4 } : threshold = 96;
            {11'd576,  4'd4 } : threshold = 144;
            {11'd112,  4'd4 } : threshold = 28;
            {11'd672,  4'd4 } : threshold = 168;
            {11'd1152, 4'd4 } : threshold = 288;

            {11'd16 ,  4'd16} : threshold = 1;
            {11'd32 ,  4'd16} : threshold = 2;
            {11'd64 ,  4'd16} : threshold = 4;
            {11'd128,  4'd16} : threshold = 8;
            {11'd192,  4'd16} : threshold = 12;
            {11'd96 ,  4'd16} : threshold = 6;
            {11'd384,  4'd16} : threshold = 24;
            {11'd576,  4'd16} : threshold = 36;
            {11'd112,  4'd16} : threshold = 7;
            {11'd672,  4'd16} : threshold = 42;
            {11'd1152, 4'd16} : threshold = 72;

            default: threshold = 0;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
        begin
            counter <= 0;
            valid_out <= 0;
        end else if (threshold != 0 && valid_in)
        begin
            if (counter == threshold - 1) 
            begin
                counter <= 0;
                valid_out <= 1;
            end else 
            begin
                counter <= counter + 1;
                valid_out <= 0;
            end
        end else 
        begin
            valid_out <= 0;
        end
    end

endmodule
