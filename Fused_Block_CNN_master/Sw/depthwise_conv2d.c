

#include <stdio.h>
#include <stdint.h>
#include <string.h>

typedef enum {
    PADDING_VALID,
    PADDING_SAME
} PaddingType;

/**
 * depthwise_conv2d dành cho input shape: [channels][height][width].
 * - input_channels: số kênh (channels)
 * - input_height:   chiều cao (height)
 * - input_width:    chiều rộng (width)
 *
 *  Thứ tự duyệt và indexing được sửa lại
 *  để tương thích với cách lưu trữ:
 *     input[c][h][w].
 */
void depthwise_conv2d(
    const int16_t *input,
    const int16_t *kernel,
    const int16_t *bias,
    int16_t *output,
    int input_channels,
    int input_height,
    int input_width,
    int kernel_height,
    int kernel_width,
    int stride_height,
    int stride_width,
    PaddingType padding
) {
    // Tính toán kích thước đầu ra
    int output_height = input_height;
    int output_width = input_width;

    // Tính toán padding
    int pad_h = (kernel_height - 1) / 2;
    int pad_w = (kernel_width - 1) / 2;

    if (padding == PADDING_VALID) {
        output_height = (input_height - kernel_height) / stride_height + 1;
        output_width  = (input_width  - kernel_width ) / stride_width  + 1;
        pad_h = 0;
        pad_w = 0;
    }

    // Xóa bộ nhớ output
    memset(output, 0, output_height * output_width * input_channels * sizeof(int16_t));

    // Vòng lặp depthwise: mỗi kênh có 1 kernel riêng
    for (int c = 0; c < input_channels; c++) {
        for (int out_h = 0; out_h < output_height; out_h++) {
            for (int out_w = 0; out_w < output_width; out_w++) {
                // Khởi tạo giá trị tổng bằng bias (nếu có)
                int32_t sum = (bias != NULL) ? bias[c] : 0;

                // Tính chỉ số h/w trên input (có nhân stride nếu bạn mở rộng)
                // Ở đây stride=1 => in_h=out_h + ...
                int center_h = out_h;  
                int center_w = out_w;

                // Quét vùng kernel
                for (int kh = -pad_h; kh <= pad_h; kh++) {
                    for (int kw = -pad_w; kw <= pad_w; kw++) {
                        int in_h = center_h + kh;
                        int in_w = center_w + kw;

                        // Nếu nằm trong biên => lấy giá trị
                        if (in_h >= 0 && in_h < input_height &&
                            in_w >= 0 && in_w < input_width)
                        {
                            // Index cho input: [c][in_h][in_w]
                            int input_idx = c*(input_height*input_width)
                                            + in_h*input_width
                                            + in_w;

                            // Index cho kernel: [c][kh+pad_h][kw+pad_w]
                            int kernel_idx = c*(kernel_height*kernel_width)
                                             + (kh + pad_h)*kernel_width
                                             + (kw + pad_w);

                            sum += input[input_idx] * kernel[kernel_idx];
                        }
                    }
                }

                // Ghi vào output: [c][out_h][out_w]
                int output_idx = c*(output_height*output_width)
                                 + out_h*output_width
                                 + out_w;

                // Ép giá trị về int16 [-32768..32767]
                if (sum > 32767)   sum = 32767;
                if (sum < -32768)  sum = -32768;
                output[output_idx] = (int16_t) sum;
            }
        }
    }
}


int main() {
    int16_t input[3][3][3] = {
        // Channel 1
        {
            {58, 62, 66},
            {70, 74, 78},
            {82, 87, 90}
        },
        // Channel 2
        {
            {58, 62, 66},
            {70, 74, 78},
            {82, 87, 90}
        },
        // Channel 3
        {
            {58, 62, 66},
            {70, 74, 78},
            {82, 87, 90}
        }
    };

    // ------------------------------
    // 2) Khai báo kernel (3 kênh, mỗi kênh 3×3)
    //    Mỗi kênh đều toàn 1 => DepthwiseConv2D = cộng 9 ô lân cận
    // ------------------------------
    int16_t kernel[3][3][3] = {
        // Kernel cho Channel 1
        {
            {1, 1, 1},
            {1, 1, 1},
            {1, 1, 1}
        },
        // Kernel cho Channel 2
        {
            {1, 1, 1},
            {1, 1, 1},
            {1, 1, 1}
        },
        // Kernel cho Channel 3
        {
            {1, 1, 1},
            {1, 1, 1},
            {1, 1, 1}
        }
    };

    // Mảng đầu ra: 3 kênh, mỗi kênh (3×3)
    int16_t output[3][3][3] = {0};

    // Gọi hàm depthwise_conv2d()
    depthwise_conv2d(
        (const int16_t*)input,   // &input[0][0][0]
        (const int16_t*)kernel,  // &kernel[0][0][0]
        NULL,                    // bias = NULL
        (int16_t*)output,        // &output[0][0][0]
        3,  // input_channels
        3,  // input_height
        3,  // input_width
        3,  // kernel_height
        3,  // kernel_width
        1,  // stride_height
        1,  // stride_width
        PADDING_SAME
    );

    // ------------------------------
    // 3) In kết quả (mỗi channel 3×3)
    // ------------------------------
    printf("\nOutput Data (3x3x3):\n");
    for (int c = 0; c < 3; c++) {
        printf("Channel %d:\n", c + 1);
        for (int h = 0; h < 3; h++) {
            for (int w = 0; w < 3; w++) {
                // output[c][h][w]
                printf("%d ", output[c][h][w]);
            }
            printf("\n");
        }
    }

    return 0;
}
