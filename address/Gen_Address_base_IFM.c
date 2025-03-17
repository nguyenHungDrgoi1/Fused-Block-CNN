#include <stdio.h>

int main(){
    const int IFM_channel = 16;
    const int IFM_height = 10;
    const int IFM_width = 10;

    const int kernel_width = 3;
    const int kernel_filter = 32;

    const int PE = 16;

    //int tile = kernel_filter / PE;
    int count = 1;
    int add_base = 0;
    int add_file [30000];
    
    FILE *fp = fopen("C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/addr_IFM.txt", "w");
    if (fp == NULL) {
        printf("Error opening file!\n");
        return 1;
    }
    
    for (int i = 0; i < 30000; i++){
        add_file[i] = add_base;
        fprintf(fp, "%X\n", add_file[i]);
        
        if (count != 0 && count % ((IFM_channel * kernel_width * kernel_width) / 4) == 0 ){
            add_base = add_base - (kernel_width * IFM_height - IFM_height + 1) * IFM_channel - 12;
        }
        else if (count != 0 && count % ((IFM_channel * kernel_width ) / 4) == 0 ) {
            add_base = add_base + (IFM_width - 2) * IFM_channel - 12;
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
