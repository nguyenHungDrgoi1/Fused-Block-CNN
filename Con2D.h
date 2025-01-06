#ifndef CON2D
#define CON2D
float *** ConV2D(float *** ifmap, float ****kernel, int input_height,int input_width, int input_channel, int kernel_height, int kernel_filter, int kernel_channel, int stride, int padding);

#endif