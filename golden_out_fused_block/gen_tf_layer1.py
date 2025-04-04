import numpy as np
import tensorflow as tf
import math

# === CONFIG: Đặt tham số trực tiếp ở đây ===
ifm_height = 58
ifm_width = 58
ifm_channel = 32

weight_height = 3
weight_width = 3
weight_filter = 128

padding = 0 # Padding P
stride = 1   # Stride S

# === Hàm đọc dữ liệu từ file HEX với thứ tự hàng → cột → channel → filter ===
def read_hex_file_weight(filename, shape):
    with open(filename, "r") as file:
        hex_values = file.readlines()
    data = np.array([int(x.strip(), 16) for x in hex_values], dtype=np.int16)

    H, W, C, F = shape
    reshaped_data = np.zeros((H, W, C, F), dtype=np.int16)
    index = 0
    for f in range(F):
        for h in range(H):
            for w in range(W):
                for c in range(C):
                    reshaped_data[h, w, c, f] = data[index]
                    index += 1
    return reshaped_data

# === Hàm đọc dữ liệu từ file HEX với thứ tự hàng → cột → channel ===
def read_hex_file(filename, shape):
    with open(filename, "r") as file:
        hex_values = file.readlines()
    data = np.array([int(x.strip(), 16) for x in hex_values], dtype=np.int32)

    H, W, C = shape
    reshaped_data = np.zeros((H, W, C), dtype=np.int32)
    index = 0
    for h in range(H):
        for w in range(W):
            for c in range(C):
                reshaped_data[h, w, c] = data[index]
                index += 1
    return reshaped_data

# === Hàm ghi dữ liệu ra file HEX ===
def write_hex_file(filename, data):
    H, W, C = data.shape
    with open(filename, "w") as file:
        for c in range(C):
            for h in range(H):
                for w in range(W):
                    int_value = int(round(data[h, w, c]))
                    hex_value = int_value & 0xFF
                    file.write(f"{hex_value:02X}\n")

# === MAIN ===
# Tính kích thước OFM với padding và stride
output_feature_height = (ifm_height - weight_height + 2 * padding) // stride + 1
output_feature_width = (ifm_width - weight_width + 2 * padding) // stride + 1
output_feature_channel = weight_filter

# File paths cố định
input_file = "../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/ifm.hex"
weight_file = "../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1.hex"
output_file = "../Fused-Block-CNN/golden_out_fused_block/output_hex_folder/ofm1.hex"

# Đọc dữ liệu
input_data = read_hex_file(input_file, (ifm_height, ifm_width, ifm_channel))
weight_data_flat = read_hex_file_weight(weight_file, (weight_height, weight_width, ifm_channel, weight_filter))
weight_data = weight_data_flat.reshape(weight_height, weight_width, ifm_channel, weight_filter)

# Xác định padding cho TensorFlow layer
tf_padding = "same" if padding > 0 else "valid"

# Tạo mô hình
input_layer = tf.keras.layers.Input(shape=(ifm_height, ifm_width, ifm_channel))
conv_layer = tf.keras.layers.Conv2D(filters=weight_filter,
                                    kernel_size=(weight_height, weight_width),
                                    strides=(stride, stride),
                                    padding=tf_padding,
                                    activation=None
                                    )(input_layer)
model = tf.keras.Model(inputs=input_layer, outputs=conv_layer)
model.layers[1].set_weights([weight_data.astype(np.float32), np.zeros(weight_filter, dtype=np.float32)])

# Dự đoán và reshape
output_data = model.predict(input_data.reshape(1, ifm_height, ifm_width, ifm_channel).astype(np.float32))
output_data = output_data.reshape(output_feature_height, output_feature_width, output_feature_channel)

# Ghi kết quả
write_hex_file(output_file, output_data)
print(f"Kết quả đã được ghi vào {output_file}")
