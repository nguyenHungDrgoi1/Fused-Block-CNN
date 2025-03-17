#include <stdio.h>

int main(){
    const int IFM_channel = 16;
    const int IFM_height = 10;
    const int IFM_width = 10;

    const int kernel_width = 3;
    const int kernel_filter = 32;

    const int PE = 4;
    const int tile = kernel_filter / PE;
    const int total_cycle_for_1_tile = kernel_width * kernel_width * IFM_channel / 4;
    //int tile = kernel_filter / PE;
    int count = 1;
    int add_base = 0;
    int add_file [30000];
    
    FILE *fp = fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/addr_Weight.txt", "w");
    if (fp == NULL) {
        printf("Error opening file!\n");
        return 1;
    }
    
    for (int i = 0; i < total_cycle_for_1_tile * tile; i++){
        add_file[i] = add_base;
        fprintf(fp, "%d\n", add_file[i]);
        if (count % total_cycle_for_1_tile == 0) {
            add_base = add_base + (kernel_width * kernel_width * IFM_channel) * PE - (kernel_width * kernel_width *IFM_channel - 4) ;
        }
        else {
            add_base = add_base + 4;
        }
        count++;
    }
    
    fclose(fp);
    printf("Address data written to address_output.txt\n");
    
    return 0;
}
