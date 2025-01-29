#include <stdio.h>
#include <stdint.h>
#include <string.h>

typedef enum {
    PADDING_VALID,
    PADDING_SAME
} PaddingType;

void depthwise_conv2d(
    const int16_t *input,
    const int16_t *kernel,
    const int16_t *bias,
    int16_t *output,
    int input_width,
    int input_height,
    int input_channels,
    int kernel_width,
    int kernel_height,
    int stride_width,
    int stride_height,
    PaddingType padding
) {
    int output_width = input_width;
    int output_height = input_height;
    int pad_w = (kernel_width - 1) / 2;
    int pad_h = (kernel_height - 1) / 2;

    if (padding == PADDING_VALID) {
        output_width = (input_width - kernel_width) / stride_width + 1;
        output_height = (input_height - kernel_height) / stride_height + 1;
        pad_w = 0;
        pad_h = 0;
    }

    memset(output, 0, output_width * output_height * input_channels * sizeof(int16_t));

    for (int c = 0; c < input_channels; c++) {
        for (int h = 0; h < output_height; h++) {
            for (int w = 0; w < output_width; w++) {
                int32_t sum = bias ? bias[c] : 0;
                for (int kh = -pad_h; kh <= pad_h; kh++) {
                    for (int kw = -pad_w; kw <= pad_w; kw++) {
                        int in_h = h + kh;
                        int in_w = w + kw;
                        if (in_h >= 0 && in_h < input_height && in_w >= 0 && in_w < input_width) {
                            int input_idx = (in_h * input_width + in_w) * input_channels + c;
                            int kernel_idx = ((kh + pad_h) * kernel_width + (kw + pad_w)) * input_channels + c;
                            sum += input[input_idx] * kernel[kernel_idx];
                        }
                    }
                }
                int output_idx = (c * output_height + h) * output_width + w;
                output[output_idx] = (sum > 32767) ? 32767 : ((sum < -32768) ? -32768 : sum);
            }
        }
    }
}


/**Example */
int main() {
    int16_t input[3][3][3] = {
        {{1, 4, 7}, {1, 4, 7}, {1, 4, 7}},
        {{2, 5, 8}, {2, 5, 8}, {2, 5, 8}},
        {{3, 6, 9}, {3, 6, 9}, {3, 6, 9}}
    };

    int16_t kernel[3][3][3] = {
        {{1, 1, 1}, {1, 1, 1}, {1, 1, 1}},
        {{1, 1, 1}, {1, 1, 1}, {1, 1, 1}},
        {{1, 1, 1}, {1, 1, 1}, {1, 1, 1}}
    };

    int16_t output[3][3][3] = {0};

    depthwise_conv2d(
        &input[0][0][0],
        &kernel[0][0][0],
        NULL,
        &output[0][0][0],
        3, 3, 3,
        3, 3,
        1, 1,
        PADDING_SAME
    );

    printf("\nOutput Data (3x3x3):\n");
    for (int c = 0; c < 3; c++) {
        printf("Channel %d:\n", c + 1);
        for (int h = 0; h < 3; h++) {
            for (int w = 0; w < 3; w++) {
                printf("%d ", output[c][h][w]);
            }
            printf("\n");
        }
    }
    return 0;
}