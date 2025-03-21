#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 100
#define OFFSET 2916        // Khoảng cách dòng
#define MAX_PE 16          // Tổng số PE: từ PE0 đến PE15

// Đếm tổng số dòng trong file
int count_lines(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (!file) return -1;

    int count = 0;
    char line[MAX_LINE_LENGTH];
    while (fgets(line, sizeof(line), file)) {
        count++;
    }

    fclose(file);
    return count;
}

// Hàm xử lý 1 PE
void process_pe_file(int pe_id) {
    char inputFile[256];
    char outputFile[256];

    // Tạo tên file input/output theo PE
    sprintf(inputFile, "address/OFM_PE%d.hex", pe_id);
    sprintf(outputFile, "address/OFM_PE%d_change.hex", pe_id);

    // Đếm số dòng trong file
    int total_lines = count_lines(inputFile);
    if (total_lines < OFFSET + 1) {
        printf("⚠️ PE%d: File không đủ %d + 1 dòng để ghép!\n", pe_id, OFFSET);
        return;
    }

    // Mở file input
    FILE *inFile = fopen(inputFile, "r");
    if (!inFile) {
        printf("❌ PE%d: Không thể mở file input '%s'\n", pe_id, inputFile);
        return;
    }

    // Cấp phát bộ nhớ mảng dòng
    char **lines = (char **)malloc(sizeof(char *) * total_lines);
    if (!lines) {
        printf("❌ PE%d: Lỗi cấp phát bộ nhớ!\n", pe_id);
        fclose(inFile);
        return;
    }

    for (int i = 0; i < total_lines; i++) {
        lines[i] = (char *)malloc(MAX_LINE_LENGTH);
        fgets(lines[i], MAX_LINE_LENGTH, inFile);
    }
    fclose(inFile);

    // Mở file output để ghi
    FILE *outFile = fopen(outputFile, "w");
    if (!outFile) {
        printf("❌ PE%d: Không thể mở file output '%s'\n", pe_id, outputFile);
        for (int i = 0; i < total_lines; i++) free(lines[i]);
        free(lines);
        return;
    }

    // Ghi các dòng theo thứ tự: dòng i → dòng i + OFFSET
    for (int i = 0; i < total_lines - OFFSET; i++) {
        fputs(lines[i], outFile);
        fputs(lines[i + OFFSET], outFile);
    }

    printf("✅ PE%d: Đã ghi xong vào '%s'\n", pe_id, outputFile);

    // Giải phóng bộ nhớ
    for (int i = 0; i < total_lines; i++) free(lines[i]);
    free(lines);
    fclose(outFile);
}

int main() {
    for (int pe = 0; pe < MAX_PE; pe++) {
        process_pe_file(pe);
    }

    printf("\n🚀 Đã xử lý xong tất cả %d PE!\n", MAX_PE);
    return 0;
}
