#include <stdio.h>
#include <stdlib.h>
#include "Padding.h"
// Hàm giả lập Padding_3D
float ***Padding_3D(float ***ifmap, int input_height, int input_width, int input_channel, int padding) {
    int padded_height = input_height + 2 * padding;
    int padded_width = input_width + 2 * padding;

    float ***padded = (float ***)malloc(input_channel * sizeof(float **));
    for (int c = 0; c < input_channel; c++) {
        padded[c] = (float **)malloc(padded_height * sizeof(float *));
        for (int i = 0; i < padded_height; i++) {
            padded[c][i] = (float *)malloc(padded_width * sizeof(float));
            for (int j = 0; j < padded_width; j++) {
                if (i >= padding && i < input_height + padding && j >= padding && j < input_width + padding) {
                    padded[c][i][j] = ifmap[c][i - padding][j - padding];
                } else {
                    padded[c][i][j] = 0.0; // Giá trị padding là 0
                }
            }
        }
    }
    return padded;
}

// Hàm thực hiện Conv2D
float ***ConV2D(float ***ifmap, float ****kernel, int input_height, int input_width, int input_channel, int kernel_height, int kernel_filter, int kernel_channel, int stride, int padding) {
    int output_height = (input_height - kernel_height + 2 * padding) / stride + 1 ;
    int output_width = (input_width - kernel_height + 2 * padding) / stride + 1;
    int output_channel = kernel_filter;

    int padded_height = input_height + 2 * padding;
    int padded_width = input_width + 2 * padding;

    // Thêm padding vào ifmap
    float ***ifmap_padded = Padding_3D(ifmap, input_height, input_width, input_channel, padding);

    // Cấp phát bộ nhớ cho output feature map
    float ***ofmap = (float ***)malloc(output_channel * sizeof(float **));
    for (int k = 0; k < output_channel; k++) {
        ofmap[k] = (float **)malloc(output_height * sizeof(float *));
        for (int i = 0; i < output_height; i++) {
            ofmap[k][i] = (float *)malloc(output_width * sizeof(float));
        }
    }

    // Thực hiện tính chập
    for (int k = 0; k < output_channel; k++) {
        for (int p = 0; p < output_height; p++) {
            for (int q = 0; q < output_width; q++) {
                ofmap[k][p][q] = 0;
                for (int r = 0; r < kernel_height; r++) {
                    for (int s = 0; s < kernel_height; s++) {
                        for (int c = 0; c < kernel_channel; c++) {
                            int h = p * stride + r;
                            int w = q * stride + s;
                            ofmap[k][p][q] += ifmap_padded[c][h][w] * kernel[k][c][r][s];
                        }
                    }
                }
            }
        }
    }

    // Giải phóng bộ nhớ cho ifmap_padded
    for (int c = 0; c < input_channel; c++) {
        for (int i = 0; i < padded_height; i++) {
            free(ifmap_padded[c][i]);
        }
        free(ifmap_padded[c]);
    }
    free(ifmap_padded);

    return ofmap;
}

// Hàm giải phóng bộ nhớ
void free_memory_3D(float ***array, int channel, int height) {
    for (int c = 0; c < channel; c++) {
        for (int i = 0; i < height; i++) {
            free(array[c][i]);
        }
        free(array[c]);
    }
    free(array);
}

void free_memory_4D(float ****array, int filter, int channel, int height) {
    for (int k = 0; k < filter; k++) {
        for (int c = 0; c < channel; c++) {
            for (int i = 0; i < height; i++) {
                free(array[k][c][i]);
            }
            free(array[k][c]);
        }
        free(array[k]);
    }
    free(array);
}

// Hàm chính
int main() {
    int input_height = 3, input_width = 3, input_channel = 3;
    int kernel_height = 3, kernel_channel = 3, kernel_filter = 1;
    int stride = 1, padding = 1;

    int output_height = input_height + 2 * padding - kernel_height + 1;
    int output_width = input_width + 2 * padding - kernel_height + 1;
    int output_channel = kernel_filter;

    // Khởi tạo input feature map
    float ***ifmap = (float ***)malloc(input_channel * sizeof(float **));
    for (int c = 0; c < input_channel; c++) {
        ifmap[c] = (float **)malloc(input_height * sizeof(float *));
        for (int i = 0; i < input_height; i++) {
            ifmap[c][i] = (float *)malloc(input_width * sizeof(float));
        }
    }

    float input_data[3][3][3] = {
        {{1, 2, 3}, {2, 1, 0}, {0, 1, 2}},
        {{5, 1, 0}, {1, 2, 3}, {3, 1, 0}},
        {{5, 1, 2}, {5, 1, 0}, {1, 2, 3}}
    };
    
    for (int c = 0; c < input_channel; c++) {
        printf("Input Channel %d:\n", c);
        for (int i = 0; i < input_height; i++) {
            for (int j = 0; j < input_width; j++) {
                ifmap[c][i][j] = input_data[c][i][j];
                printf("%.2f ", ifmap[c][i][j] );
            }
            printf("\n");
        }
    }

    // Khởi tạo kernel
    float ****kernel = (float ****)malloc(kernel_filter * sizeof(float ***));
    for (int k = 0; k < kernel_filter; k++) {
        kernel[k] = (float ***)malloc(kernel_channel * sizeof(float **));
        for (int c = 0; c < kernel_channel; c++) {
            kernel[k][c] = (float **)malloc(kernel_height * sizeof(float *));
            for (int r = 0; r < kernel_height; r++) {
                kernel[k][c][r] = (float *)malloc(kernel_height * sizeof(float));
                for (int s = 0; s < kernel_height; s++) {
                    kernel[k][c][r][s] = 1.0; // Kernel giá trị 1.0
                }
            }
        }
    }

    // Thực hiện Convolution
    float ***ofmap = ConV2D(ifmap, kernel, input_height, input_width, input_channel, kernel_height, kernel_filter, kernel_channel, stride, padding);

    // In kết quả
    for (int k = 0; k < output_channel; k++) {
        printf("Output Channel %d:\n", k);
        for (int i = 0; i < output_height; i++) {
            for (int j = 0; j < output_width; j++) {
                printf("%.2f ", ofmap[k][i][j]);
            }
            printf("\n");
        }
    }

    // Giải phóng bộ nhớ
    free_memory_3D(ifmap, input_channel, input_height);
    free_memory_4D(kernel, kernel_filter, kernel_channel, kernel_height);
    free_memory_3D(ofmap, output_channel, output_height);

    return 0;
}
