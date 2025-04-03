#include <stdio.h>
#include <stdlib.h>

#define NUM_FILTERS 32
#define NUM_CHANNELS 16
#define KERNEL_SIZE 9  // 3x3 kernel
#define BLOCK_SIZE (NUM_CHANNELS * KERNEL_SIZE) // 144 values

int main() {
    FILE *input_file, *output_file;
    unsigned int weights[NUM_FILTERS][BLOCK_SIZE];  // Lưu từng khối 144 số
    unsigned int reordered_weights[NUM_FILTERS][BLOCK_SIZE];

    // Mở file input
    input_file = fopen("weight_16x32.hex", "r");
    if (!input_file) {
        perror("Lỗi mở file weight_16x32.hex");
        return 1;
    }

    // Đọc dữ liệu từ file theo khối 144 số
    for (int f = 0; f < NUM_FILTERS; f++) {
        for (int i = 0; i < BLOCK_SIZE; i++) {
            if (fscanf(input_file, "%x", &weights[f][i]) != 1) {
                printf("Lỗi đọc file tại Filter %d, Index %d\n", f, i);
                fclose(input_file);
                return 1;
            }
        }
    }
    fclose(input_file);

    // Chuyển đổi định dạng
    for (int f = 0; f < NUM_FILTERS; f++) {
        for (int c = 0; c < NUM_CHANNELS; c++) {
            for (int k = 0; k < KERNEL_SIZE; k++) {
                // Sắp xếp lại: lấy giá trị theo từng channel, cách nhau 9 số trong block 144
                reordered_weights[f][c * KERNEL_SIZE + k] = weights[f][k * NUM_CHANNELS + c];
            }
        }
    }

    // Mở file output
    output_file = fopen("reformatted_weights.hex", "w");
    if (!output_file) {
        perror("Lỗi mở file reformatted_weights.hex");
        return 1;
    }

    // Ghi dữ liệu ra file theo định dạng mới
    for (int f = 0; f < NUM_FILTERS; f++) {
        for (int i = 0; i < BLOCK_SIZE; i++) {
            fprintf(output_file, "%X\n", reordered_weights[f][i]);
        }
    }
    fclose(output_file);

    printf("✅ Chuyển đổi định dạng trọng số hoàn tất. Đã lưu vào 'reformatted_weights.hex'.\n");
    return 0;
}
