#ifndef PADDING
#define PADDING
float ***Padding_3D(float ***ifmap, int input_height, int input_width, int input_channel, int padding);
float **Padding_2D(float **ifmap, int input_height, int input_width, int padding);

#endif