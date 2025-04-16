#include <stdio.h>

int main(){
    const int IFM_channel = 16;
    const int IFM_height  = 10;
    const int IFM_width   = 10;

    const int kernel_width  = 3;
    const int kernel_filter = 16;

    const int PE  = 4;
    const int tile = kernel_filter / PE;
    int OFM    = IFM_height - kernel_width +1 ;
    
    // Tính số vòng lặp/cycle trong 1 tile
    const int total_cycle_for_1_tile = 
        (kernel_width * kernel_width * IFM_channel) / 4;
    
    int count    = 1;
    int add_base = 0;
    int add_file[30000];


    int K = kernel_width;
    int N = IFM_channel;
    int offset = (K*K*N*PE) - (total_cycle_for_1_tile * 4);

    FILE *fp = fopen("/home/thanhdo/questasim/PE/Fused-Block-CNN/in-out-weight/addresses_filter_golden_test.hex", "w");

    if (fp == NULL) {
        printf("Error opening file!\n");
        return 1;
    }
    for (int j= 0; j< OFM*OFM ; j++) {
        for (int i = 0; i < total_cycle_for_1_tile * tile; i++){
            add_file[i] = add_base;
            // In dạng hexa 4 ký tự thường
            fprintf(fp, "%04x\n", add_file[i] & 0xFFFF);
                // Mỗi vòng vẫn +4
            add_base += 4;
            
            count++;
        }
        add_base=0;
    }
    
    fclose(fp);
    printf("Address data in HEX format written to addr_Weight_hex.txt\n");
    
    
    return 0;
}
