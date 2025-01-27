#include <stdio.h>
#include <stdlib.h>
#include "Padding.h"
#include "math.h"
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
    int output_height = (input_height - kernel_height + 2 * padding) / stride + 1;
    int output_width = (input_width - kernel_height + 2 * padding) / stride + 1;
    int output_channel = kernel_filter;

    int padded_height = input_height + 2 * padding;
    int padded_width = input_width + 2 * padding;

    // Thêm padding vào ifmap
    float ***ifmap_padded = Padding_3D(ifmap, input_height, input_width, input_channel, padding);

    // Cấp phát bộ nhớ cho output feature map
    
    if (input_height == 1 && input_width == 1) {
        float*** ofmap = (float***)malloc(3 * sizeof(float**));
        for (int k = 0; k < 3; k++) {
            ofmap[k] = (float**)malloc(output_height * sizeof(float*));
            for (int i = 0; i < output_height; i++) {
                ofmap[k][i] = (float*)malloc(output_width * sizeof(float));
            }
        }
        ofmap[0][0][0] = 0;
        ofmap[1][0][0] = 0;
        ofmap[2][0][0] = 0;
        for (int i = 0; i < kernel_channel; i++) {
            for (int j = 0; j < input_channel; j++) {
                ofmap[i][0][0] = ifmap[j][0][0] * kernel[i][0][0][0]+ ofmap[i][0][0];
            }
        }
        return ofmap;
    }
    if (kernel_height == 1) {
        float*** ofmap = (float***)malloc(4 * sizeof(float**));
        for (int k = 0; k < 4; k++) {
            ofmap[k] = (float**)malloc(output_height * sizeof(float*));
            for (int i = 0; i < output_height; i++) {
                ofmap[k][i] = (float*)malloc(output_width * sizeof(float));
            }
        }
        ofmap[0][0][0] = 0;
        ofmap[1][0][0] = 0;
        ofmap[2][0][0] = 0;
        for (int i = 0; i < kernel_filter; i++) {
            for (int j = 0; j < input_channel; j++) {
                for (int j = 0 ; )
                ofmap[i][0][0] = ifmap[j][0][0] * kernel[i][0][0][0] + ofmap[i][0][0];
            }
        }
        return ofmap;
    }
    float*** ofmap = (float***)malloc(output_channel * sizeof(float**));
    for (int k = 0; k < output_channel; k++) {
        ofmap[k] = (float**)malloc(output_height * sizeof(float*));
        for (int i = 0; i < output_height; i++) {
            ofmap[k][i] = (float*)malloc(output_width * sizeof(float));
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
float*** DeepWise(float*** ifmap, float**** kernel, int input_height, int input_width, int input_channel, int kernel_height, int kernel_filter, int kernel_channel, int stride, int padding) {
    int output_height = (input_height - kernel_height + 2 * padding) / stride + 1;
    int output_width = (input_width - kernel_height + 2 * padding) / stride + 1;
    int output_channel = input_channel;

    int padded_height = input_height + 2 * padding;
    int padded_width = input_width + 2 * padding;
    //print("%d,%d,%d", output_height, output_width, output_channel);
    // Thêm padding vào ifmap
    float*** ifmap_padded = Padding_3D(ifmap, input_height, input_width, input_channel, padding);

    // Cấp phát bộ nhớ cho output feature map
    float*** ofmap = (float***)malloc(output_channel * sizeof(float**));
    for (int k = 0; k < output_channel; k++) {
        ofmap[k] = (float**)malloc(output_height * sizeof(float*));
        for (int i = 0; i < output_height; i++) {
            ofmap[k][i] = (float*)malloc(output_width * sizeof(float));
        }
    }
    for (int k = 0; k < output_channel; k++) {
        for (int p = 0; p < output_height; p++) {
            for (int q = 0; q < output_width; q++) {
                ofmap[k][p][q] = 0;
                for (int r = 0; r < kernel_height; r++) {
                    for (int s = 0; s < kernel_height; s++) {
                        for (int c = 0; c < 1; c++) {
                            int h = p * stride + r;
                            int w = q * stride + s;
                            ofmap[k][p][q] += ifmap_padded[k][h][w] * kernel[k][c][r][s];
                        }
                    }
                }
            }
        }
    }
    for (int c = 0; c < input_channel; c++) {
        for (int i = 0; i < padded_height; i++) {
            free(ifmap_padded[c][i]);
        }
        free(ifmap_padded[c]);
    }
    free(ifmap_padded);

    return ofmap;
}

float sigmoid(float x) {
     float y = 1.0f / (1.0f + expf(-x));
    //float y = 1.0f / (1.0f + pow(2.718, -x));
    return y;
}

// Hàm Swish
float swish(float x) {
    return x * sigmoid(x);
}

// Hàm Swish cho ma trận 3D (height, width, channels)
float*** swish3D(float*** input, int height, int width, int channels) {
    // Cấp phát bộ nhớ cho ma trận output
    float*** output = (float***)malloc(height * sizeof(float**));
    for (int h = 0; h < height; h++) {
        output[h] = (float**)malloc(width * sizeof(float*));
        for (int w = 0; w < width; w++) {
            output[h][w] = (float*)malloc(channels * sizeof(float));
        }
    }

    // Áp dụng Swish lên ma trận 3D
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            for (int c = 0; c < channels; c++) {
                float x = input[h][w][c];
                output[h][w][c] = swish(x); // Áp dụng hàm Swish
            }
        }
    }

    return output; // Trả về ma trận kết quả
}
float*** multify(float*** input, int height, int width, int channels, float*** input_2 , int height_2, int width_2, int channels_2) {
    // Cấp phát bộ nhớ cho ma trận output
    float*** output = (float***)malloc(3 * sizeof(float**));
    for (int h = 0; h < 3; h++) {
        output[h] = (float**)malloc(3 * sizeof(float*));
        for (int w = 0; w < 3; w++) {
            output[h][w] = (float*)malloc(3 * sizeof(float));
        }
    }

    // Áp dụng Swish lên ma trận 3D
    for (int c = 0; c < 3; c++) {
        for (int h = 0; h < 3; h++) {
            for (int w = 0; w < 3; w++) {
                float x = input[c][h][w];
                float y = input_2[c][0][0];
                output[c][h][w]=  x*y; // Áp dụng hàm Swish
            }
        }
    }

    return output; // Trả về ma trận kết quả
}
float*** sigmoid3D(float*** input, int height, int width, int channels) {
    // Cấp phát bộ nhớ cho ma trận output
    float*** output = (float***)malloc(3 * sizeof(float**));
    for (int h = 0; h < 3; h++) {
        output[h] = (float**)malloc(3 * sizeof(float*));
        for (int w = 0; w < 3; w++) {
            output[h][w] = (float*)malloc(3 * sizeof(float));
        }
    }

    // Áp dụng Swish lên ma trận 3D
    for (int c = 0; c < channels; c++) {
        for (int h = 0; h < height; h++) {
            for (int w = 0; w < width; w++) {
                float x = input[c][h][w];
                output[c][h][w] = sigmoid(x); // Áp dụng hàm Swish
            }
        }
    }

    return output; // Trả về ma trận kết quả
}
float*** GlobalAveragePooling2D(float*** input, int height, int width, int channels) {
    // Cấp phát bộ nhớ cho output
    float*** output = (float***)malloc(height * sizeof(float**));
    for (int h = 0; h < height; h++) {
        output[h] = (float**)malloc(width * sizeof(float*));
        for (int w = 0; w < width; w++) {
            output[h][w] = (float*)malloc(channels * sizeof(float));
        }
    }

    // Tính trung bình trên mỗi kênh
    for (int c = 0; c < channels; c++) {
        float sum = 0.0f;
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                sum += input[c][i][j];
            }
        }
        output[c][0][0] = sum / (height * width); // Trung bình toàn cục cho mỗi kênh
    }

    return output; // Trả về kết quả sau Global Average Pooling
}
float*** reshape_3d(float*** input, int input_height, int input_width, int input_channels, int output_height, int output_width, int output_channels) {
    // Cấp phát bộ nhớ cho ma trận output
    float*** output = (float***)malloc(output_channels * sizeof(float**));
    for (int c = 0; c < output_channels; c++) {
        output[c] = (float**)malloc(output_height * sizeof(float*));
        for (int i = 0; i < output_height; i++) {
            output[c][i] = (float*)malloc(output_width * sizeof(float));
        }
    }

    // Reshape đầu vào thành output có kích thước (1, 1, c)
    for (int c = 0; c < input_channels; c++) {
        for (int i = 0; i < output_height; i++) {
            for (int j = 0; j < output_width; j++) {
                // Vì reshape về (1, 1, c), chúng ta chỉ sao chép giá trị của channel vào
                output[c][i][j] = input[c][0][0];  // Gán giá trị của (0, 0) cho tất cả các vị trí
            }
        }
    }

    return output;
}
// Hàm chính
int main() {
    int input_height = 3, input_width = 3, input_channel = 3;
    int kernel_height = 3, kernel_channel = 3, kernel_filter = 3; int kernel_filter_16 = 16;
    int stride = 1, padding = 1;

    int output_height = input_height;
    int output_width = input_width;
    int output_channel = kernel_filter;

    // Khởi tạo input feature map
    float ***ifmap = (float ***)malloc(4 * sizeof(float **));
    for (int c = 0; c < 4; c++) {
        ifmap[c] = (float **)malloc(input_height * sizeof(float *));
        for (int i = 0; i < input_height; i++) {
            ifmap[c][i] = (float *)malloc(input_width * sizeof(float));
        }
    }

    float input_data[4][3][3] = {
        {{1, 1, 1}, {2, 2, 2}, {3, 3, 3}},
        {{4, 4, 4}, {5, 5, 5}, {6, 6, 6}},
        {{7, 7, 7}, {8, 8, 8}, {9, 9, 9}},
        {{10, 10, 10}, {11, 11, 11}, {12, 12, 12}}
    };
    
    for (int c = 0; c < 4; c++) {
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
        kernel[k] = (float ***)malloc(4 * sizeof(float **));
        for (int c = 0; c < 4; c++) {
            kernel[k][c] = (float **)malloc(kernel_height * sizeof(float *));
            for (int r = 0; r < kernel_height; r++) {
                kernel[k][c][r] = (float *)malloc(kernel_height * sizeof(float));
                for (int s = 0; s < kernel_height; s++) {
                    kernel[k][c][r][s] = 1.0; // Kernel giá trị 1.0
                }
            }
        }
    }

    // Khởi tạo kernel_16
    float**** kernel_16 = (float****)malloc(kernel_filter_16 * sizeof(float***));
    for (int k = 0; k < kernel_filter_16; k++) {
        kernel_16[k] = (float***)malloc(4 * sizeof(float**));
        for (int c = 0; c < 4; c++) {
            kernel_16[k][c] = (float**)malloc(kernel_height * sizeof(float*));
            for (int r = 0; r < kernel_height; r++) {
                kernel_16[k][c][r] = (float*)malloc(kernel_height * sizeof(float));
                for (int s = 0; s < kernel_height; s++) {
                    kernel_16[k][c][r][s] = 1.0; // Kernel giá trị 1.0
                }
            }
        }
    }
    // Thực hiện Convolution
    float ***ofmap = ConV2D(ifmap, kernel_16, 3, 3, 4, 1, 16, 4, stride, padding);
    //float*** ofmap_1 = batchnorm(ofmap, input_height, input_width, input_channel, 1e-3, NULL, NULL, NULL, NULL, 1);
 /*   float*** ofmap_1 = swish3D(ofmap, 3, 3, 3);
    float ***ofmap_2 = GlobalAveragePooling2D(ofmap_1, 3, 3, 3);
    float*** ofmap_3 = ConV2D(ofmap_2, kernel, 1, 1, 3, 1, 1, 1,stride, padding);
    float*** ofmap_4 = sigmoid3D(ofmap_3, 1, 1, 1);
    float*** ofmap_5 = ConV2D(ofmap_4, kernel, 1, 1, 1, 1, 1, 3, stride, padding);
    float*** ofmap_6 = sigmoid3D(ofmap_5,1,1,3);
    float*** ofmap_7 = multify(ofmap_1, 3, 3, 3, ofmap_6, 1, 1, 3);
    float*** ofmap_8 = ConV2D(ofmap_7, kernel_16, 3, 3, 3, 3, 16, 3, stride, padding); */
    // In kết quả
    for (int k = 0; k < 16; k++) {
        printf("Output Channel %d:\n", k);
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
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
