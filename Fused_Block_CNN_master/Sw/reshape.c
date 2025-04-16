#include "MB_CONV.h"
void reshape(  //Tuan Anh
    const int16_t *input,       // Pointer to input data
    int16_t *output,            // Pointer to output data
    int input_width,            // Original input width
    int input_height,           // Original input height
    int input_channels,         // Original input channels
    int output_width,           // New output width
    int output_height,          // New output height
    int output_channels         // New output channels
){
    int input_size = input_width * input_height * input_channels;
    int output_size = output_width * output_height * output_channels;
    if (input_size == output_size) {
        for (int i = 0 ; i < output_size; i++) {
            output[i] = input[i];
        }
    }
    else {
        print("Error size");
    }
    
}