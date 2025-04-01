import numpy as np
import tensorflow as tf

# Hàm đọc dữ liệu từ file HEX với thứ tự hàng → cột → channel → filter
def read_hex_file_weight(filename, shape):
    with open(filename, "r") as file:
        hex_values = file.readlines()

    # Chuyển đổi từ HEX sang số nguyên 16-bit (đảm bảo dtype là np.int16 nếu dữ liệu có kích thước 16-bit)
    data = np.array([int(x.strip(), 16) for x in hex_values], dtype=np.int16)

    # Định dạng lại dữ liệu theo đúng thứ tự hàng → cột → channel → filter
    H, W, C, F = shape  # File lưu theo (height → width → channel → filter)
    reshaped_data = np.zeros((H, W, C, F), dtype=np.int16)

    index = 0
    for f in range(F):  # Duyệt qua từng hàng
        for h in range(H):  # Duyệt qua từng cột
            for w in range(W):  # Duyệt qua từng channel
                for c in range(C):  # Duyệt qua filters
                    reshaped_data[h, w, c, f] = data[index]
                    index += 1

    return reshaped_data

# Hàm đọc dữ liệu từ file HEX với thứ tự hàng → cột → channel
def read_hex_file(filename, shape):
    with open(filename, "r") as file:
        hex_values = file.readlines()

    # Chuyển đổi từ HEX sang số nguyên 32-bit
    data = np.array([int(x.strip(), 16) for x in hex_values], dtype=np.int32)

    # Định dạng lại dữ liệu theo đúng thứ tự hàng → cột → channel
    H,W,C = shape
    reshaped_data = np.zeros((H, W, C), dtype=np.int32)

    index = 0
    for h in range(H):  # Duyệt qua hàng
        for w in range(W):  # Duyệt qua cột
            for c in range(W):  # Duyệt qua channel
                reshaped_data[h, w, c] = data[index]
                index += 1

    return reshaped_data

# Hàm ghi dữ liệu ra file HEX theo thứ tự hàng → cột → channel
def write_hex_file(filename, data):
    H, W, C = data.shape
    with open(filename, "w") as file:
        for h in range(H):  # Duyệt qua từng hàng
            for w in range(W):  # Duyệt qua từng cột
                for c in range(C):  # Duyệt qua từng channel
                    int_value = int(round(data[h, w, c]))  # Chuyển float thành int
                    hex_value = int_value & 0xFF  # Giữ lại 8 bit thấp nhất
                    file.write(f"{hex_value:02X}\n")  # Định dạng 2 ký tự HEX

# Đọc dữ liệu đầu vào
input_feature_height = 58
input_feature_width = 58
input_feature_channel = 16
weight_height = 3
weight_width = 3
weight_channel = input_feature_channel
weight_filter = 32
output_feature_height = 56
output_feature_width = 56
output_feature_channel = weight_filter

# Đường dẫn file
input_file = "../Fused-Block-CNN/address/ifm_padded.hex"
weight_file = "../Fused-Block-CNN/address/weight.hex"
output_file = "../Fused-Block-CNN/address/ofm.hex"

# Đọc dữ liệu từ file input và weight
input_data = read_hex_file(input_file, (input_feature_height, input_feature_width, input_feature_channel))
weight_data_flat = read_hex_file_weight(weight_file, (weight_height, weight_width, weight_channel, weight_filter))

# Reshape lại thành (3,3,3,1) theo thứ tự hàng → cột → channel → filter
weight_data = weight_data_flat.reshape(weight_height, weight_width, weight_channel, weight_filter)

# Tạo mô hình Convolution với 1 filter
input_layer = tf.keras.layers.Input(shape=(input_feature_height, input_feature_width, input_feature_channel))
conv_layer = tf.keras.layers.Conv2D(filters=weight_filter, kernel_size=(weight_height, weight_width), padding="valid", activation=None)(input_layer)
model = tf.keras.Model(inputs=input_layer, outputs=conv_layer)

# Đặt trọng số cho Conv2D layer với bias = 0
model.layers[1].set_weights([weight_data.astype(np.float32), np.zeros(weight_filter, dtype=np.float32)])

# Chạy dữ liệu qua mô hình
output_data = model.predict(input_data.reshape(1, input_feature_height, input_feature_width, input_feature_channel).astype(np.float32))
output_data = output_data.reshape(output_feature_height, output_feature_width, output_feature_channel)

# Ghi kết quả ra file HEX
write_hex_file(output_file, output_data)

print(f"Kết quả đã được ghi vào {output_file}")