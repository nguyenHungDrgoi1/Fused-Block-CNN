#include<stdio.h>
#include<stdlib.h>
#include "Padding.h"
float ***Padding_3D(float ***ifmap, int input_height, int input_width, int input_channel, int padding) {
    // Tính toán kích thước output
    int padded_height = input_height + 2 * padding;
    int padded_width = input_width + 2 * padding;

    // Cấp phát động mảng ba chiều cho ofmap
    float ***ofmap = (float ***)malloc(input_channel * sizeof(float **));
    for (int k = 0; k < input_channel; k++) {
        ofmap[k] = (float **)malloc(padded_height * sizeof(float *));
        for (int i = 0; i < padded_height; i++) {
            ofmap[k][i] = (float *)malloc(padded_width * sizeof(float));
        }
    }

    // Gán giá trị cho ofmap
    for (int k = 0; k < input_channel; k++) {
        for (int p = 0; p < padded_height; p++) {
            for (int q = 0; q < padded_width; q++) {
                if (p < padding || q < padding || p >= (input_height + padding) || q >= (input_width + padding)) {
                    ofmap[k][p][q] = 0.0f;
                } else {
                    ofmap[k][p][q] = ifmap[k][p - padding][q - padding];
                }
            }
        }
    }

    return ofmap;
}
float **Padding_2D(float **ifmap, int input_height, int input_width, int padding){
    // Tính toán kích thước output
    int padded_height = input_height + 2 * padding;
    int padded_width = input_width + 2 * padding;

    // Cấp phát động mảng ba chiều cho ofmap
    float **ofmap = (float **)malloc(padded_height * sizeof(float *));
    for (int p = 0; p < padded_height; p++) {
        ofmap[p] = (float *)malloc(padded_width * sizeof(float));
    }
    for (int p = 0; p < padded_height; p++) {
        for (int q = 0; q < padded_width; q++) {
                if (p < padding || q < padding || p >= (input_height + padding) || q >= (input_width + padding)) {
                    ofmap[p][q] = 0.0f;
                } else {
                    ofmap[p][q] = ifmap[p - padding][q - padding];
                }
        }
    }
    return ofmap;

}
// int main() {
//     ///// CHAY THU PADDING 3D//////////////////////////////
//     int input_height = 3, input_width = 3, input_channel = 2, padding = 2;

//     // Cấp phát động mảng ba chiều cho ifmap
//     float ***ifmap = (float ***)malloc(input_channel * sizeof(float **));
//     for (int k = 0; k < input_channel; k++) {
//         ifmap[k] = (float **)malloc(input_height * sizeof(float *));
//         for (int i = 0; i < input_height; i++) {
//             ifmap[k][i] = (float *)malloc(input_width * sizeof(float));
//         }
//     }

//     // Gán giá trị cho ifmap
//     for (int k = 0; k < input_channel; k++) {
//         for (int i = 0; i < input_height; i++) {
//             for (int j = 0; j < input_width; j++) {
//                 ifmap[k][i][j] = i * input_width + j + 1; // Giá trị mẫu
//             }
//         }
//     }

//     // In ifmap
//     printf("Input Feature Map:\n");
//     for (int k = 0; k < input_channel; k++) {
//         for (int i = 0; i < input_height; i++) {
//             for (int j = 0; j < input_width; j++) {
//                 printf("%.1f ", ifmap[k][i][j]);
//             }
//             printf("\n");
//         }
//         printf("\n");
//     }

//     // Gọi hàm Padding
//     float ***ofmap = Padding_3D(ifmap, input_height, input_width, input_channel, padding);

//     // In ofmap
//     printf("Output Feature Map (with padding):\n");
//     int padded_height = input_height + 2 * padding;
//     int padded_width = input_width + 2 * padding;
//     for (int k = 0; k < input_channel; k++) {
//         for (int i = 0; i < padded_height; i++) {
//             for (int j = 0; j < padded_width; j++) {
//                 printf("%.1f ", ofmap[k][i][j]);
//             }
//             printf("\n");
//         }
//         printf("\n");
//     }

//     // Giải phóng bộ nhớ
//     for (int k = 0; k < input_channel; k++) {
//         for (int i = 0; i < input_height; i++) {
//             free(ifmap[k][i]);
//         }
//         free(ifmap[k]);
//     }
//     free(ifmap);

    // for (int k = 0; k < output_channel; k++) {
    //     for (int i = 0; i < padded_height; i++) {
    //         free(ofmap[k][i]);
    //     }
    //     free(ofmap[k]);
    // }
    // free(ofmap);

    //return 0;
    ///// CHAY THU PADDING 2D ////////////////////////
    //  int input_height = 3, input_width = 3, padding = 1;

    // // Cấp phát động mảng 2D cho ifmap
    // float **ifmap = (float **)malloc(input_height * sizeof(float *));
    // for (int i = 0; i < input_height; i++) {
    //     ifmap[i] = (float *)malloc(input_width * sizeof(float));
    // }

    // // Gán giá trị mẫu cho ifmap
    // for (int i = 0; i < input_height; i++) {
    //     for (int j = 0; j < input_width; j++) {
    //         ifmap[i][j] = i * input_width + j + 1; // Giá trị mẫu
    //     }
    // }

    // // In ifmap ban đầu
    // printf("Input 2D Feature Map:\n");
    // for (int i = 0; i < input_height; i++) {
    //     for (int j = 0; j < input_width; j++) {
    //         printf("%.1f ", ifmap[i][j]);
    //     }
    //     printf("\n");
    // }
    // printf("\n");

    // // Gọi hàm Padding2D
    // float **ofmap = Padding_2D(ifmap, input_height, input_width, padding);

    // // In ofmap sau khi padding
    // int padded_height = input_height + 2 * padding;
    // int padded_width = input_width + 2 * padding;

    // printf("Output 2D Feature Map (with padding):\n");
    // for (int i = 0; i < padded_height; i++) {
    //     for (int j = 0; j < padded_width; j++) {
    //         printf("%.1f ", ofmap[i][j]);
    //     }
    //     printf("\n");
    // }

    // // Giải phóng bộ nhớ
    // for (int i = 0; i < input_height; i++) {
    //     free(ifmap[i]);
    // }
    // free(ifmap);

    // for (int i = 0; i < padded_height; i++) {
    //     free(ofmap[i]);
    // }
    // free(ofmap);

    // return 0;
//}