#include "MB_CONV.h"
void add (  //Tuan Anh
    const int16_t *input1,      // Pointer to first input tensor
    const int16_t *input2,      // Pointer to second input tensor
    int16_t *output,            // Pointer to output tensor
    int width,                  // Width of the tensors
    int height,                 // Height of the tensors
    int channels                // Number of channels in the tensors
){
    for(int i = 0; i < width * height * channels; i++){
        output[i] = input1[i] + input2[i];
    }
}