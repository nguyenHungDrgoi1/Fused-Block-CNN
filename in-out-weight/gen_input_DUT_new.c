#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

// Hàm đọc dữ liệu từ file HEX vào mảng 1D
void read_hex_file(const char *filename, int16_t *data, int size) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        printf("Lỗi: Không thể mở file %s\n", filename);
        exit(1);
    }

    for (int i = 0; i < size; i++) {
        if (fscanf(file, "%hx", &data[i]) != 1) {
            printf("Lỗi đọc file tại dòng %d\n", i);
            fclose(file);
            exit(1);
        }
    }

    fclose(file);
}

// Hàm ghi mảng 1D ra file HEX
void write_hex_file(const char *filename, int16_t *data, int size) {
    FILE *file = fopen(filename, "w");
    if (!file) {
        printf("Lỗi: Không thể mở file để ghi %s\n", filename);
        exit(1);
    }

    for (int i = 0; i < size; i++) {
        fprintf(file, "%02hX\n", data[i]); // Ghi HEX 4 chữ số
    }

    fclose(file);
}

// Hàm trích xuất cửa sổ 3x3 từ mảng 1D và ghi ra file
void extract_patches_1d(const int16_t *input, int H, int W, int C, int K, int F,  int16_t *output) {
    int output_H = H - K + 1;  // Chiều cao đầu ra
    int output_W = W - K + 1;  // Chiều rộng đầu ra
    int index = 0; // Vị trí trong output
    for (int f = 0;  f < F; f++){
    for (int c = 0; c < C; c++) {  
        for (int oh = 0; oh < output_H; oh++) {  
            for (int ow = 0; ow < output_W; ow++) {
                
                // Lấy cửa sổ 3x3
                for (int kh = 0; kh < K; kh++) {
                    for (int kw = 0; kw < K; kw++) {
                        int ih = oh + kh;
                        int iw = ow + kw;
                        int input_index = (c * H * W) + (ih * W) + iw;

                        output[index++] = input[input_index]; // Lưu vào output
                    }
                }
            }
        }
    }
}
}
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
int main() {
    int H = 56, W = 56, C = 16;  // Kích thước input (4x4, 1 channel)
    int K = 3;  // Kernel 3x3
    int F = 3; // filter
    int P = 1;
    int size = H * W * C;
    int size_padded = (H + 2 * P) * (W + 2 * P) * C;

    int output_size = (H + 2 * P - K + 1) * (W + 2 * P - K + 1) * K * K * C * F; // Số phần tử đầu ra

    // Cấp phát bộ nhớ
    int16_t *input_data = (int16_t *)malloc(size * sizeof(int16_t));
    int16_t *input_data_padded = (int16_t *) malloc (size_padded * sizeof(int16_t));
    int16_t *output_data = (int16_t *)malloc(output_size * sizeof(int16_t));

    if (!input_data || !output_data) {
        printf("Lỗi cấp phát bộ nhớ\n");
        return -1;
    }

    // Đọc dữ liệu từ file
    read_hex_file("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/input_56x56x16.hex", input_data, size);
    // padding 1D
    add_padding_1d(input_data, H, W, C, P, 0, input_data_padded);
    // Trích xuất cửa sổ 3x3
    // extract_patches_1d(input_data_padded, H + 2 * P, W + 2 * P, C, K,F, output_data);

    // Ghi kết quả ra file
    write_hex_file("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/dut/input_56x56x16_pad.hex", input_data_padded, size_padded);

    printf("Dữ liệu đã ghi vào output.hex\n");

    // Giải phóng bộ nhớ
    free(input_data);
    free(output_data);

    return 0;
}
