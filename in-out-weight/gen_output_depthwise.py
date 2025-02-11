import numpy as np
import tensorflow as tf

# Hàm đọc dữ liệu từ file HEX (lấy đủ 32x32x3 hoặc 3x3x3)
def read_hex_file(filename, shape):
    with open(filename, "r") as file:
        hex_values = file.readlines()

    # Chuyển đổi từ HEX sang số nguyên 16-bit
    data = np.array([int(x.strip(), 16) for x in hex_values], dtype=np.int32)
    
    # Reshape theo kích thước mong muốn
    return data.reshape(shape)

# Hàm ghi dữ liệu ra file HEX
def write_hex_file(filename, data):
    with open(filename, "w") as file:
        for value in data:
            file.write(f"{int(value)}\n")  # Ghi số HEX (5 chữ số)

# Đường dẫn file
input_file = "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/input_depthwise.hex"
weight_file = "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/weight_depthwise.hex"
output_file = "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/output_depthwise.hex"

# Đọc dữ liệu từ file
input_data = read_hex_file(input_file, (1, 32, 32, 3))  # Batch=1, H=32, W=32, C=3
weight_data = read_hex_file(weight_file, (3, 3, 3, 1))  # Kernel=3x3, Depth_multiplier=1

# Tạo mô hình Depthwise Convolution
input_layer = tf.keras.layers.Input(shape=(32, 32, 3))
depthwise_layer = tf.keras.layers.DepthwiseConv2D(kernel_size=(3,3), padding="same", activation=None)(input_layer)
model = tf.keras.Model(inputs=input_layer, outputs=depthwise_layer)

# Đặt trọng số cho Depthwise layer
model.layers[1].set_weights([weight_data, np.zeros(3)])  # Bias = 0

# Chạy dữ liệu qua mô hình
output_data = model.predict(input_data)
output_data = output_data.flatten().astype(np.int32)  # Chuyển thành mảng 1D, giữ số nguyên 16-bit

# Ghi kết quả ra file HEX
write_hex_file(output_file, output_data)

print(f"Kết quả đã được ghi vào {output_file}")
