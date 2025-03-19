#include <stdio.h>
#include <stdint.h>
#include <string.h>

void pooling_average(
    const int16_t *input,  // Pointer to input data
    int16_t *output,       // Pointer to output data
    int input_width,       // Input width
    int input_height,      // Input height
    int input_channels,    // Number of input channels
    int pool_width,        // Pooling window width
    int pool_height,       // Pooling window height
    int stride_width,      // Stride width
    int stride_height      // Stride height
) {
    // Tính toán kích thước đầu ra
    int output_width = (input_width - pool_width) / stride_width + 1;
    int output_height = (input_height - pool_height) / stride_height + 1;

    // Lặp qua từng kênh
    for (int c = 0; c < input_channels; c++) {
        for (int h = 0; h < output_height; h++) {
            for (int w = 0; w < output_width; w++) {
                int32_t sum = 0;
                int count = 0;

                // Lặp qua cửa sổ pooling
                for (int ph = 0; ph < pool_height; ph++) {
                    for (int pw = 0; pw < pool_width; pw++) {
                        int in_h = h * stride_height + ph;
                        int in_w = w * stride_width + pw;

                        if (in_h < input_height && in_w < input_width) {
                            int input_idx = (c * input_height + in_h) * input_width + in_w;
                            sum += input[input_idx];
                            count++;
                        }
                    }
                }

                // Tính giá trị trung bình
                int output_idx = (c * output_height + h) * output_width + w;
                output[output_idx] = (int16_t)(sum / count);
            }
        }
    }
}
