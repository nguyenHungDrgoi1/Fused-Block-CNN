#include <stdio.h>
#include <stdlib.h>

void readAndWriteFile(const char *inputFile, const char *outputFile, int n, int m, int num_segments, int offset, int ofm_height) {
    FILE *inFile = fopen(inputFile, "r");
    FILE *outFile = fopen(outputFile, "w");

    if (inFile == NULL || outFile == NULL) {
        printf("Không thể mở file!\n");
        return;
    }

    int *buffer = (int *)malloc(n * sizeof(int));  // Dùng buffer để lưu n giá trị

    if (buffer == NULL) {
        printf("Lỗi cấp phát bộ nhớ!\n");
        fclose(inFile);
        fclose(outFile);
        return;
    }

    // Nếu offset = 1, đọc từ giá trị 144 đến 287
    int start_offset = 0;
    if (offset != 0) {
        start_offset = ofm_height * ofm_height * offset;
    }

    // Di chuyển con trỏ tới start_offset nếu offset = 1
    fseek(inFile, start_offset * sizeof(int), SEEK_SET);

    for (int segment = 0; segment < num_segments; segment++) {
        // Đọc n giá trị từ file vào buffer
        for (int i = 0; i < n; i++) {
            if (fscanf(inFile, "%x", &buffer[i]) != 1) {  // Đọc dữ liệu hex từ file
                printf("Lỗi đọc dữ liệu từ file!\n");
                free(buffer);
                fclose(inFile);
                fclose(outFile);
                return;
            }
        }

        // Ghi n giá trị vào file đích
        for (int i = 0; i < n; i++) {
            fprintf(outFile, "%02X\n", buffer[i]);  // Ghi giá trị ra file đích
        }

        // Đổi vị trí đọc cho đoạn tiếp theo
        // Bỏ qua m giá trị để đọc đoạn tiếp theo
        for (int skip = 0; skip < m; skip++) {
            fscanf(inFile, "%x", &buffer[0]);  // Đọc nhưng không lưu vào buffer
        }
    }

    // Giải phóng bộ nhớ và đóng các file
    free(buffer);
    fclose(inFile);
    fclose(outFile);

    printf("Hoàn thành việc đọc và ghi nhiều đoạn vào file!\n");
}

int main() {
    const char *inputFile = "../Fused-Block-CNN/address/ofm.hex";  // Đường dẫn tới file nguồn

    const int PE = 16;
    const int filter = 32;
    int tile = filter / PE;

    int ofm_height = 56;
    int ofm_channel = 32;

    int kernel_size = ofm_height * ofm_height;  // Số lượng giá trị cần đọc mỗi lần
    int offset = ofm_height * ofm_height * (PE - 1);   // Nhân với m để tính vị trí tiếp theo cần đọc (m*n)

    // Gọi hàm để thực hiện việc đọc và ghi nhiều lần vào các file khác nhau với các offset khác nhau
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE0.hex", kernel_size, offset, 2, 0,ofm_height); // offset = 1 cho đoạn từ 144 đến 287
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE1.hex", kernel_size, offset, 2, 1,ofm_height); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE2.hex", kernel_size, offset, 2, 2,ofm_height); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE3.hex", kernel_size, offset, 2, 3,ofm_height); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE4.hex", kernel_size, offset, 2, 4,ofm_height); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE5.hex", kernel_size, offset, 2, 5,ofm_height); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE6.hex", kernel_size, offset, 2, 6,ofm_height); // offset = 0 cho đoạn tiếp theo 
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE7.hex", kernel_size, offset, 2, 7,ofm_height); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE8.hex", kernel_size, offset, 2, 8,ofm_height); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE9.hex", kernel_size, offset, 2, 9,ofm_height); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE10.hex", kernel_size, offset, 2, 10,ofm_height); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE11.hex", kernel_size, offset, 2, 11,ofm_height); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE12.hex", kernel_size, offset, 2, 12,ofm_height); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE13.hex", kernel_size, offset, 2, 13,ofm_height); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE14.hex", kernel_size, offset, 2, 14,ofm_height); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "../Fused-Block-CNN/address/OFM_PE15.hex", kernel_size, offset, 2, 15,ofm_height); // offset = 0 cho đoạn tiếp theo

    return 0;
}
