#include "MB_CONV.h"
void conv2d(  //tuan anh
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
)
{
    int output_height = (input_height - kernel_height + 2 * padding) / stride_height + 1;
    int output_width = (input_width - kernel_height + 2 * padding) / stride_width + 1;
     for (int oc = 0; oc < output_channels; oc++) {
     // Duyệt qua chiều cao và chiều rộng của đầu ra
     for (int oh = 0; oh < output_height; oh++) {
         for (int ow = 0; ow < output_width; ow++) {
             float value = 0.0f; // Giá trị tích chập cho pixel đầu ra hiện tại
             // Duyệt qua từng kênh đầu vào
             for (int ic = 0; ic < input_channels; ic++) {
                 // Duyệt qua kernel
                 for (int kh = 0; kh < kernel_height; kh++) {
                     for (int kw = 0; kw < kernel_width; kw++) {
                         // Tính toán tọa độ trong đầu vào với padding
                         int ih = oh * stride_height + kh - padding;
                         int iw = ow * stride_width + kw - padding;

                         // Kiểm tra nếu tọa độ trong phạm vi của input
                         if (ih >= 0 && ih < input_height && iw >= 0 && iw < input_width) {
                             // Chỉ số trong mảng input
                             int input_idx = (ic * input_height + ih) * input_width + iw;
                             
                             // Chỉ số trong mảng weights
                             // Lưu ý: Chỉ số weight được tính cho mỗi output channel, input channel và kernel
                             int weight_idx = (((oc * input_channels) + ic) * kernel_width + kh) * kernel_height + kw;

                             // Tính tích chập và cộng dồn vào giá trị đầu ra
                             value += input[input_idx] * kernel[weight_idx];
                         }
                     }
                 }
             }
             // Gán giá trị đã tính vào đầu ra
             int output_idx = (oc * output_height + oh) * output_width + ow;
             output[output_idx] = value + bias[output_idx];
         }
     }
 }
}
