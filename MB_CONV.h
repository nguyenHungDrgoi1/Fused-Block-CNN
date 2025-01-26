#ifndef MB_CONV_H
#define MB_CONV_H

#include <stdint.h>
#include <stdbool.h>

// Padding types
typedef enum {
    PADDING_SAME,  // Output size matches input size
    PADDING_VALID  // No padding, output size is reduced
} PaddingType;

// Convolution function
void conv2d(
    const int16_t *input,       // Pointer to input data
    const int16_t *kernel,      // Pointer to kernel weights
    const int16_t *bias,        // Pointer to bias (can be NULL)
    int16_t *output,            // Pointer to output data
    int input_width,            // Input width
    int input_height,           // Input height
    int input_channels,         // Input channels
    int kernel_width,           // Kernel width
    int kernel_height,          // Kernel height
    int output_channels,        // Number of output channels
    int stride_width,           // Stride width
    int stride_height,          // Stride height
    PaddingType padding         // Padding type
);

// Depthwise convolution function
void depthwise_conv2d(
    const int16_t *input,       // Pointer to input data
    const int16_t *kernel,      // Pointer to kernel weights
    const int16_t *bias,        // Pointer to bias (can be NULL)
    int16_t *output,            // Pointer to output data
    int input_width,            // Input width
    int input_height,           // Input height
    int input_channels,         // Input channels (equals depth multiplier)
    int kernel_width,           // Kernel width
    int kernel_height,          // Kernel height
    int stride_width,           // Stride width
    int stride_height,          // Stride height
    PaddingType padding         // Padding type
);

// Squeeze-and-Excitation (SE) block function
void se_block(
    const int16_t *input,       // Pointer to input data
    int16_t *output,            // Pointer to output data
    int input_channels,         // Number of input channels
    int reduced_channels        // Number of reduced channels in SE block
);

// Add function (element-wise addition)
void add(
    const int16_t *input1,      // Pointer to first input tensor
    const int16_t *input2,      // Pointer to second input tensor
    int16_t *output,            // Pointer to output tensor
    int width,                  // Width of the tensors
    int height,                 // Height of the tensors
    int channels                // Number of channels in the tensors
);
void pooling_average(
    const int16_t *input,       // Pointer to input data
    int16_t *output,            // Pointer to output data
    int input_width,            // Input width
    int input_height,           // Input height
    int input_channels,         // Number of input channels
    int pool_width,             // Pooling window width
    int pool_height,            // Pooling window height
    int stride_width,           // Stride width
    int stride_height           // Stride height
);

// Reshape function
void reshape(
    const int16_t *input,       // Pointer to input data
    int16_t *output,            // Pointer to output data
    int input_width,            // Original input width
    int input_height,           // Original input height
    int input_channels,         // Original input channels
    int output_width,           // New output width
    int output_height,          // New output height
    int output_channels         // New output channels
);

#endif // MB_CONV_H
