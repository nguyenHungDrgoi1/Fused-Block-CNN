#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    // Thay file1.txt và file2.txt bằng đường dẫn file cần so sánh
    FILE *f1 = fopen("addr_Weight_hex.txt", "r");
    FILE *f2 = fopen("addresses_filter.hex", "r");

    if (!f1 || !f2) {
        printf("Error opening one of the files.\n");
        return 1;
    }

    char line1[128], line2[128];
    int sameCount = 0;
    int totalCount = 0;

    // Đọc file theo từng dòng cho đến khi 1 file hết
    while (1) {
        char *res1 = fgets(line1, sizeof(line1), f1);
        char *res2 = fgets(line2, sizeof(line2), f2);

        if (!res1 || !res2) {
            // Hết 1 trong 2 file
            break;
        }

        // Xoá ký tự xuống dòng nếu có
        line1[strcspn(line1, "\r\n")] = 0;
        line2[strcspn(line2, "\r\n")] = 0;

        totalCount++;

        // So sánh chuỗi
        if (strcmp(line1, line2) == 0) {
            sameCount++;
        }
    }

    fclose(f1);
    fclose(f2);

    printf("So dong da so sanh: %d\n", totalCount);
    printf("So dong giong nhau: %d\n", sameCount);

    return 0;
}
