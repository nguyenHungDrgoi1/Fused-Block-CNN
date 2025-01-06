#ifndef DEEPWISE
#define DEEPWISE
float *** DeepWise(float *** ifmap, float ****kernel, int input_height, int input_width, int input_channel, int kernel_height,  int kernel_filter,int kernel_channel, int stride, int padding);


#endif