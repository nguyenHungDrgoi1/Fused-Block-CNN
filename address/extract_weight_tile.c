#include <stdio.h>
#include <stdlib.h>

void readAndWriteFile(const char *inputFile, const char *outputFile, int n, int m, int num_segments, int offset) {
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
        start_offset = 144 * offset;
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
    const char *inputFile = "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/Weight.hex";  // Đường dẫn tới file nguồn

    const int PE = 16;
    const int filter = 32;
    int tile = filter / PE;

    int kernel_height = 3;
    int kernel_channel = 16;

    int kernel_size = kernel_channel * kernel_height * kernel_height;  // Số lượng giá trị cần đọc mỗi lần
    int offset = kernel_size * (PE - 1);   // Nhân với m để tính vị trí tiếp theo cần đọc (m*n)

    // Gọi hàm để thực hiện việc đọc và ghi nhiều lần vào các file khác nhau với các offset khác nhau
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE0.hex", kernel_size, offset, 2, 0); // offset = 1 cho đoạn từ 144 đến 287
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE1.hex", kernel_size, offset, 2, 1); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE2.hex", kernel_size, offset, 2, 2); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE3.hex", kernel_size, offset, 2, 3); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE4.hex", kernel_size, offset, 2, 4); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE5.hex", kernel_size, offset, 2, 5); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE6.hex", kernel_size, offset, 2, 6); // offset = 0 cho đoạn tiếp theo 
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE7.hex", kernel_size, offset, 2, 7); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE8.hex", kernel_size, offset, 2, 8); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE9.hex", kernel_size, offset, 2, 9); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE10.hex", kernel_size, offset, 2, 10); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE11.hex", kernel_size, offset, 2, 11); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE12.hex", kernel_size, offset, 2, 12); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE13.hex", kernel_size, offset, 2, 13); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE14.hex", kernel_size, offset, 2, 14); // offset = 0 cho đoạn tiếp theo
    readAndWriteFile(inputFile, "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_PE15.hex", kernel_size, offset, 2, 15); // offset = 0 cho đoạn tiếp theo


    return 0;
}
