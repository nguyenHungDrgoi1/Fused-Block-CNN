#include "MB_CONV.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INPUT_WIDTH 3
#define INPUT_HEIGHT 3
#define INPUT_CHANNELS 4
#define KERNEL_SIZE 3
#define EXPANDED_CHANNELS 16
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
void conv2d(  //tuan anh
    const int16_t *input,       // Pointer to input data
    const int16_t *kernel,      // Pointer to kernel weights
    const int16_t *bias,        // Pointer to bias (can be NULL)
    int16_t *output,            // Pointer to output data
    int input_width,            // Input width
    int input_height,           // Input height
    int input_channels,         // Input channels
    int kernel_width,           // Kernel width
    int kernel_height,          // Kernel height
    int output_channels,        // Number of output channels
    int stride_width,           // Stride width
    int stride_height,          // Stride height
    PaddingType padding         // Padding type
)
{
    int padding_width, padding_height;
    if (padding == PADDING_VALID) {
        padding_width = 0;
        padding_height = 0;
    }
    else {
        padding_width = (kernel_width - 1 ) / 2; // same
        padding_height = (kernel_height - 1) / 2; // same
    }
    int output_height = (input_height - kernel_height + 2 * padding_height) / stride_height + 1;
    int output_width = (input_width - kernel_height + 2 * padding_width) / stride_width + 1;
     for (int oc = 0; oc < output_channels; oc++) {
     // Duyệt qua chiều cao và chiều rộng của đầu ra
     for (int oh = 0; oh < output_height; oh++) {
         for (int ow = 0; ow < output_width; ow++) {
             int32_t value = 0; // Giá trị tích chập cho pixel đầu ra hiện tại
             // Duyệt qua từng kênh đầu vào
             for (int ic = 0; ic < input_channels; ic++) {
                 // Duyệt qua kernel
                 for (int kh = 0; kh < kernel_height; kh++) {
                     for (int kw = 0; kw < kernel_width; kw++) {
                         // Tính toán tọa độ trong đầu vào với padding
                         int ih = oh * stride_height + kh - padding_height;
                         int iw = ow * stride_width + kw - padding_width;

                         // Kiểm tra nếu tọa độ trong phạm vi của input
                         if (ih >= 0 && ih < input_height && iw >= 0 && iw < input_width) {
                             // Chỉ số trong mảng input
                             int input_idx = (ic * input_height + ih) * input_width + iw;
                             
                             // Chỉ số trong mảng weights
                             // Lưu ý: Chỉ số weight được tính cho mỗi output channel, input channel và kernel
                             int weight_idx = (((oc * input_channels) + ic) * kernel_width + kh) * kernel_height + kw;

                             // Tính tích chập và cộng dồn vào giá trị đầu ra
                             value += input[input_idx] * kernel[weight_idx];
                         }
                     }
                 }
             }
             // Gán giá trị đã tính vào đầu ra
             int output_idx = (oc * output_height + oh) * output_width + ow;
             output[output_idx] = value + bias[output_idx];
         }
     }
 }
}
void add (  //Tuan Anh
    const int16_t *input1,      // Pointer to first input tensor
    const int16_t *input2,      // Pointer to second input tensor
    int16_t *output,            // Pointer to output tensor
    int width,                  // Width of the tensors
    int height,                 // Height of the tensors
    int channels                // Number of channels in the tensors
){
    for(int i = 0; i < width * height * channels; i++){
        output[i] = input1[i] + input2[i];
    }
}
void print_layer(
    const int16_t *input,
    int width,        
    int height,                
    int channels  
) {
    for (int c = 0; c < channels; c++) {
        printf("Channel %d:\n", c);
        for (int h = 0; h < height; h++) {
            for (int w = 0; w < width; w++) {
                int idx = c * (height * width) + h * width + w; 
                printf("%d ", input[idx]);
            }
            printf("\n");  // Xuống dòng sau mỗi hàng
        }
        printf("\n");  // Xuống dòng giữa các channel
    }
}

int main() {
    // Khởi tạo dữ liệu đầu vào
    int16_t input[INPUT_WIDTH * INPUT_HEIGHT * INPUT_CHANNELS] = {
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
        25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36
    };

    // Khởi tạo các kernel và bias
    int16_t kernel1[INPUT_CHANNELS * EXPANDED_CHANNELS] = {1}; // 1x1 conv kernel
    for (int i = 0; i < INPUT_CHANNELS * EXPANDED_CHANNELS; i++) {
    kernel1[i] = 1;
}   
    int16_t kernel2[EXPANDED_CHANNELS * KERNEL_SIZE * KERNEL_SIZE] = {1}; // 3x3 dwconv kernel
        for (int i = 0; i < EXPANDED_CHANNELS * KERNEL_SIZE * KERNEL_SIZE; i++) {
    kernel2[i] = 1;
}
    int16_t kernel3[EXPANDED_CHANNELS * INPUT_CHANNELS] = {1}; // 1x1 conv kernel
    
    int16_t bias1[EXPANDED_CHANNELS] = {0};
    int16_t bias2[EXPANDED_CHANNELS] = {0};
    int16_t bias3[INPUT_CHANNELS] = {0};

    // Tạo output cho từng bước
    int16_t output1[INPUT_WIDTH * INPUT_HEIGHT * EXPANDED_CHANNELS]; // Kết quả Conv2D 1x1 đầu tiên
    int16_t output2[INPUT_WIDTH * INPUT_HEIGHT * EXPANDED_CHANNELS]; // Kết quả Depthwise Conv2D
    int16_t output3[INPUT_WIDTH * INPUT_HEIGHT * INPUT_CHANNELS];    // Kết quả Conv2D 1x1 cuối cùng
    int16_t output_residual[INPUT_WIDTH * INPUT_HEIGHT * INPUT_CHANNELS]; // Kết quả cuối cùng (add)

    // 1. Conv2D (1x1)
    conv2d(input, kernel1, bias1, output1,
           INPUT_WIDTH, INPUT_HEIGHT, INPUT_CHANNELS,
           1, 1, EXPANDED_CHANNELS, 1, 1, PADDING_SAME);

    // 2. Depthwise Conv2D (3x3)
    depthwise_conv2d(output1, kernel2, NULL, output2,
                     EXPANDED_CHANNELS, INPUT_HEIGHT, INPUT_WIDTH, 
                     3, 3, 1, 1, PADDING_SAME);

    // 3. Conv2D (1x1)
    conv2d(output2, kernel3, bias3, output3,
           INPUT_WIDTH, INPUT_HEIGHT, EXPANDED_CHANNELS,
           1, 1, INPUT_CHANNELS, 1, 1, PADDING_SAME);

    // 4. Add (Residual connection)
    add(input, output3, output_residual, INPUT_WIDTH, INPUT_HEIGHT, INPUT_CHANNELS);

    // In kết quả
    printf("input:\n");
    // for (int h = 0; h < INPUT_HEIGHT; h++) {
    //     for (int w = 0; w < INPUT_WIDTH; w++) {
    //         for (int c = 0; c < INPUT_CHANNELS; c++) {
    //             int idx = h * INPUT_WIDTH * INPUT_CHANNELS + w * INPUT_CHANNELS + c;
    //             printf("%d ", output_residual[idx]);
    //         }
    //         printf("\n");
    //     }
    //     printf("\n");
    // }
    print_layer(input,INPUT_WIDTH,INPUT_HEIGHT,INPUT_CHANNELS);

    printf("output1:\n");
    print_layer(output1,INPUT_WIDTH,INPUT_HEIGHT,EXPANDED_CHANNELS);

    printf("output2:\n");
    print_layer(output2,INPUT_WIDTH,INPUT_HEIGHT,EXPANDED_CHANNELS);

    return 0;
}
