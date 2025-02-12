#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
void add_padding_1d(const int16_t *flat_matrix, int H, int W, int C, int P, int16_t pad_value, int16_t *padded_flat) {
    // Kích thước mới sau khi thêm padding
    int H_new = H + 2 * P;
    int W_new = W + 2 * P;
    int size_new = H_new * W_new * C;

    // Khởi tạo mảng mới với giá trị pad_value
    for (int i = 0; i < size_new; i++) {
        padded_flat[i] = pad_value;
    }

    // Sao chép dữ liệu từ mảng cũ vào vị trí phù hợp trong mảng mới
    for (int c = 0; c < C; c++) {
        for (int h = 0; h < H; h++) {
            for (int w= 0; w < W; w++) {
                int index_old =  (c * H * W) + (h * W) + w;
                int index_new = (c * H_new * W_new) + ((h + P) * W_new) + (w + P);
                padded_flat[index_new] = flat_matrix[index_old];
            }
        }
    }
}
void read_hex_file(const char *filename, int16_t *data, int size) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        printf("Không thể mở file: %s\n", filename);
        exit(1);
    }

    for (int i = 0; i < size; i++) {
        if (fscanf(file, "%hx", &data[i]) != 1) {
            printf("Lỗi đọc file %s tại dòng %d\n", filename, i);
            exit(1);
        }
    }

    fclose(file);
}
void conv2d(
    const int16_t *input,
    const int16_t *kernel,
    const int16_t *bias,
    int16_t *output,
    int16_t *ifm_used,
    int16_t *weight_used,
    int input_width,
    int input_height,
    int input_channels,
    int kernel_width,
    int kernel_height,
    int output_channels,
    int stride_width,
    int stride_height,
    int padding
) {
    int output_height = (input_height - kernel_height + 2 * padding) / stride_height + 1;
    int output_width = (input_width - kernel_width + 2 * padding) / stride_width + 1;
    //input_height = input_height + 2 * padding;
    //input_width = input_width + 2 * padding;
    int index_ifm = 0;
    int index_weight = 0;
    for (int oc = 0; oc < output_channels; oc++) {
        for (int oh = 0; oh < output_height; oh++) {
            for (int ow = 0; ow < output_width; ow++) {
                int32_t value = 0; // Giá trị tích chập cho pixel đầu ra hiện tại

                for (int ic = 0; ic < input_channels; ic++) {
                    for (int kh = 0; kh < kernel_height; kh++) {
                        for (int kw = 0; kw < kernel_width; kw++) {
                            int ih = oh * stride_height + kh;
                            int iw = ow * stride_width + kw;

                            if (ih >= 0 && ih < input_height && iw >= 0 && iw < input_width) {
                                int input_idx = (ic * input_height + ih) * input_width + iw;
                                int weight_idx = (((oc * input_channels) + ic) * kernel_height + kh) * kernel_width + kw;

                                ifm_used[index_ifm++] = input[input_idx];
                                weight_used[index_weight++] = kernel[weight_idx];

                                value += input[input_idx] * kernel[weight_idx];
                            }
                        }
                    }
                }

                int output_idx = (oc * output_height + oh) * output_width + ow;
                if (bias != NULL) {
                    output[output_idx] = value + bias[oc];
                } else {
                    output[output_idx] = value;
                }
            }
        }
    }
}
void write_hex_file(const char *filename, int16_t *data, int size) {
    FILE *file = fopen(filename, "w");
    if (!file) {
        printf("Không thể mở file: %s\n", filename);
        exit(1);
    }

    for (int i = 0; i < size; i++) {
        fprintf(file, "%02hx\n", data[i]); // In giá trị HEX
    }

    fclose(file);
}
int main() {
    // Kích thước đầu vào
    int input_width = 32, input_height = 32, input_channels = 3;
    int kernel_width = 3, kernel_height = 3, output_channels = 3;
    int stride_width = 1, stride_height = 1;
    int padding = 1;
    int input_width_padded = input_width + 2 * padding;
    int input_height_padded = input_height + 2 * padding;

    // Kích thước bộ nhớ cần cấp phát
    int input_size = input_width * input_height * input_channels;
    int input_size_padded = input_width_padded * input_height_padded * input_channels;
    int kernel_size = kernel_width * kernel_height * input_channels * output_channels;
    int output_size = (input_width - kernel_width + 2 * padding) / stride_width + 1;
    output_size *= (input_height - kernel_height + 2 * padding) / stride_height + 1;
    output_size *= output_channels;

    int ifm_used_size = output_size * kernel_width * kernel_height * input_channels;
    int weight_used_size = ifm_used_size; 
    // Cấp phát bộ nhớ
    int16_t *input_data = (int16_t *)malloc(input_size * sizeof(int16_t));
    int16_t *input_data_padded = (int16_t *)malloc(input_size_padded * sizeof(int16_t));
    int16_t *kernel_data = (int16_t *)malloc(kernel_size * sizeof(int16_t));
    int16_t *output_data = (int16_t *)malloc(output_size * sizeof(int16_t));
    int16_t *ifm_used = (int16_t *)malloc(ifm_used_size * sizeof(int16_t));
    int16_t *weight_used = (int16_t *)malloc(weight_used_size * sizeof(int16_t));

    if (!input_data || !kernel_data || !output_data) {
        printf("Lỗi cấp phát bộ nhớ\n");
        return -1;
    }

    // Đọc dữ liệu từ file
    read_hex_file("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/input_depthwise.hex", input_data, input_size);
    read_hex_file("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/weight_depthwise.hex", kernel_data, kernel_size);

    add_padding_1d(input_data, input_height, input_width, input_channels, padding, 0, input_data_padded);

    // Chạy tích chập
    conv2d(
        input_data_padded,
        kernel_data,
        NULL,  // Không dùng bias
        output_data,
        ifm_used,
        weight_used,
        input_width_padded, input_height_padded, input_channels,
        kernel_width, kernel_height, output_channels,
        stride_width, stride_height, 0
    );

    // Ghi kết quả ra file
    //write_hex_file("output.hex", output_data, output_size);
    write_hex_file("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/input_DUT.hex", ifm_used, ifm_used_size);
    write_hex_file("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/weight_DUT.hex", weight_used, weight_used_size);

    printf("Kết quả đã ghi vào output.hex\n");
    printf("Dữ liệu sau khi thêm padding:\n");
// for (int h = 0; h < input_height_padded; h++) {
//     for (int w = 0; w < input_width_padded; w++) {
//         for (int c = 0; c < input_channels; c++) {
//             int index = (h * input_width_padded + w) * input_channels + c;
//             printf("%04hx ", input_data_padded[index]);
//         }
//     }
//     printf("\n");
// }

    // Giải phóng bộ nhớ
    free(ifm_used);
    free(weight_used);
    free(input_data);
    free(input_data_padded);
    free(kernel_data);
    free(output_data);

    return 0;
}
