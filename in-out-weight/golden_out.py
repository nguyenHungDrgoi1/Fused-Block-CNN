import tensorflow as tf
import numpy as np

def generate_random_tensor(shape, dtype=np.uint8):  # Đổi sang uint8
    return np.random.randint(0, 256, shape, dtype=dtype)  # Giá trị từ 0 → 255

def save_tensor_as_hex(tensor, filename):
    with open(filename, 'w') as f:
        for value in tensor.flatten():
            int_value = int(np.round(value))  # Convert float to int
            f.write(f"{int_value & 0xFF:02X}\n")  # Ghi hex không dấu (2 ký tự)

# Define input dimensions
batch_size = 1
in_channels = 2
out_channels = 4
input_size = (3, 3)  # Height x Width
kernel_size = (3, 3)
stride = 1
padding = 'same'

np.random.seed(42)  # For reproducibility

# Generate random IFM and Weights as uint8
IFM = generate_random_tensor((batch_size, *input_size, in_channels), dtype=np.uint8)
Weight = generate_random_tensor((kernel_size[0], kernel_size[1], in_channels, out_channels), dtype=np.uint8)

# Reorder weights to store depth first (IC before OC)
Weight_reordered = np.transpose(Weight, (0, 1, 3, 2))  # (H, W, OC, IC)

# Convert to float32 for Conv2D (TF only accepts float input)
IFM_tensor = tf.convert_to_tensor(IFM.astype(np.float32))
Weight_tensor = Weight.astype(np.float32)

# Create Conv2D layer with weights, no bias
conv2d = tf.keras.layers.Conv2D(
    filters=out_channels,
    kernel_size=kernel_size,
    strides=stride,
    padding=padding,
    use_bias=False,
    kernel_initializer=tf.constant_initializer(Weight_tensor)
)

# Apply convolution
OFM = conv2d(IFM_tensor)

# Save IFM, Weight (depth-first), and OFM to files
save_tensor_as_hex(IFM, 'IFM.hex')
save_tensor_as_hex(Weight_reordered, 'Weight.hex')
save_tensor_as_hex(OFM.numpy(), 'OFM.hex')

print("✅ IFM, Weight (uint8), and OFM have been saved as hex files.")
