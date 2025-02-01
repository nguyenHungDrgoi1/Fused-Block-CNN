import numpy as np
import tensorflow as tf
from tensorflow.keras.layers import Conv2D, DepthwiseConv2D, Add
from tensorflow.keras import Model, Input

# Define constants
INPUT_WIDTH = 3
INPUT_HEIGHT = 3
INPUT_CHANNELS = 4
KERNEL_SIZE = 3
EXPANDED_CHANNELS = 16
STRIDE = 1
PADDING = "same"

#   Define the input per channel, exactly as expected
channel_0 = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]], dtype=np.int16)
channel_1 = np.array([[10, 11, 12], [13, 14, 15], [16, 17, 18]], dtype=np.int16)
channel_2 = np.array([[19, 20, 21], [22, 23, 24], [25, 26, 27]], dtype=np.int16)
channel_3 = np.array([[28, 29, 30], [31, 32, 33], [34, 35, 36]], dtype=np.int16)

#   Stack channels to form (Height, Width, Channels)
input_data = np.stack([channel_0, channel_1, channel_2, channel_3], axis=-1)  # (3, 3, 4)

#   Add batch dimension (1, H, W, C) for TensorFlow
input_data = np.expand_dims(input_data, axis=0)  # (1, 3, 3, 4)

#  Define Keras Model
input_layer = Input(shape=(INPUT_HEIGHT, INPUT_WIDTH, INPUT_CHANNELS))

#  Pointwise Conv2D (1x1)
conv1 = Conv2D(filters=EXPANDED_CHANNELS, kernel_size=(1, 1), strides=(1, 1),
               padding=PADDING, use_bias=True, kernel_initializer="ones", bias_initializer="zeros")(input_layer)

#  Depthwise Convolution (3x3)
depthwise_conv = DepthwiseConv2D(kernel_size=(KERNEL_SIZE, KERNEL_SIZE), strides=(1, 1),
                                 padding=PADDING, use_bias=False, depth_multiplier=1,
                                 depthwise_initializer="ones")(conv1)

#  Pointwise Conv2D (1x1)
conv2 = Conv2D(filters=INPUT_CHANNELS, kernel_size=(1, 1), strides=(1, 1),
               padding=PADDING, use_bias=True, kernel_initializer="ones", bias_initializer="zeros")(depthwise_conv)

#  Residual Addition
output_residual = Add()([input_layer, conv2])

#  Define Model
model = Model(inputs=input_layer, outputs=[conv1, depthwise_conv, conv2, output_residual])

#  Compute Outputs
output1, output2, output3, output_residual = model.predict(input_data)

#  Convert outputs to int16 for compatibility with C
output1 = output1.astype(np.int16)
output2 = output2.astype(np.int16)
output3 = output3.astype(np.int16)
output_residual = output_residual.astype(np.int16)

#  File name for saving results
output_file = "golden_MB_CONV_output.txt"

#  Function to write results to a file
def write_to_file(filename, layer, width, height, channels, name=""):
    """Writes the output tensor to a text file."""
    with open(filename, "a") as f:
        f.write(f"\n{name}:\n")
        for c in range(channels):
            f.write(f"Channel {c}:\n")
            for h in range(height):
                for w in range(width):
                    f.write(f"{layer[0, h, w, c]} ")  # Remove batch dimension
                f.write("\n")
            f.write("\n")

#  Clear the output file before writing new data
with open(output_file, "w") as f:
    f.write("")

#  Write outputs to file
write_to_file(output_file, input_data, INPUT_WIDTH, INPUT_HEIGHT, INPUT_CHANNELS, "Input")
write_to_file(output_file, output1, INPUT_WIDTH, INPUT_HEIGHT, EXPANDED_CHANNELS, "Output1 (1x1 Conv)")
write_to_file(output_file, output2, INPUT_WIDTH, INPUT_HEIGHT, EXPANDED_CHANNELS, "Output2 (Depthwise Conv)")
#write_to_file(output_file, output3, INPUT_WIDTH, INPUT_HEIGHT, INPUT_CHANNELS, "Output3 (1x1 Conv)")

print(f"Keras-based golden output has been written to {output_file}")
