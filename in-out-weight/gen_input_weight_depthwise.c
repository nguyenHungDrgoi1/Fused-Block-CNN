#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdint.h>  // Dùng uint8_t

void generateAndWriteHexFile(const char *filename, int arraySize, unsigned int seed) {
    FILE *outFile = fopen(filename, "w"); // Mở file để ghi văn bản

    if (outFile == NULL) {
        printf("Không thể mở file để ghi!\n");
        return;
    }

    srand(seed); // Thiết lập seed khác nhau cho từng file

    for (int i = 0; i < arraySize; i++) {
        uint8_t randomValue = rand() % 256;  // Sinh số trong khoảng [0, 255]
        fprintf(outFile, "%02X\n", randomValue);  // Ghi số theo định dạng HEX (2 chữ số)
    }

    fclose(outFile);
    printf("Ghi mảng 8-bit ngẫu nhiên thành công vào file: %s\n", filename);
}

int main() {
    const int input_height = 16;
    const int input_width = 16;
    const int input_channel = 3;
    int input_size = input_channel * input_height * input_width;

    const int weight_height = 3;
    const int weight_width = 3;
    const int weight_channel = 3;
    const int weight_filter = 1;
    int weight_size = weight_channel * weight_height * weight_width * weight_filter;

    const char *filename_IFM = "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/input_16x16x3.hex";
    const char *filename_Weight = "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/weight_3x3x3.hex";

    // Gọi hàm với seed khác nhau để đảm bảo dãy số khác nhau
    generateAndWriteHexFile(filename_IFM, input_size, time(NULL));
    generateAndWriteHexFile(filename_Weight, weight_size, time(NULL) + 1000); // Seed khác

    return 0;
}
