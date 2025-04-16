#include <stdio.h>

int main(){
    const int IFM_channel = 16;
    const int IFM_height  = 10;
    const int IFM_width   = 10;

    const int kernel_width  = 3;
    const int kernel_filter = 32;

    const int PE  = 4;
    const int tile = kernel_filter / PE;
    
    // Tính số vòng lặp/cycle trong 1 tile
    const int total_cycle_for_1_tile = 
        (kernel_width * kernel_width * IFM_channel) / 4;
    
    int count    = 1;
    int add_base = 0;
    int add_file[30000];


    int K = kernel_width;
    int N = IFM_channel;
    int offset = (K*K*N*PE) - (total_cycle_for_1_tile * 4);

    FILE *fp = fopen("addr_Weight_hex.txt", "w");
    if (fp == NULL) {
        printf("Error opening file!\n");
        return 1;
    }

    for (int i = 0; i < total_cycle_for_1_tile * tile; i++){
        add_file[i] = add_base;

        // In dạng hexa 4 ký tự thường
        fprintf(fp, "%04x\n", add_file[i] & 0xFFFF);

        // if (count % total_cycle_for_1_tile == 0) {
        //     // Cộng thêm offset bù
        //     add_base += offset;
        // } else 
        {
            // Mỗi vòng vẫn +4
            add_base += 4;
        }
        count++;
    }
    
    fclose(fp);
    printf("Address data in HEX format written to addr_Weight_hex.txt\n");
    
    return 0;
}
