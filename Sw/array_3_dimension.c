#include <stdio.h>
#include<stdint.h>

#define X 2  // Số hàng
#define Y 3  // Số cột
#define Z 4  // Số chiều sâu

int main() {
    int8_t array[X][Y][Z]; // Khai báo mảng 3 chiều

    // Gán giá trị cho mảng
    for (int i = 0; i < X; i++) {
        for (int j = 0; j < Y; j++) {
            for (int k = 0; k < Z; k++) {
                array[i][j][k] = i * 100 + j * 10 + k; // Gán giá trị dễ nhận diện
            }
        }
    }

    // In ra giá trị và địa chỉ từng phần tử
    printf("Giá trị và địa chỉ của từng phần tử trong mảng 3 chiều:\n");
    for (int i = 0; i < X; i++) {
        for (int j = 0; j < Y; j++) {
            for (int k = 0; k < Z; k++) {
                printf("array[%d][%d][%d] = %d, Địa chỉ: %p\n", 
                        i, j, k, array[i][j][k], (void*)&array[i][j][k]);
            }
        }
    }
    
    return 0;
}
