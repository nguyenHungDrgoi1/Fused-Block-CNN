import numpy as np
import tensorflow as tf

# Hàm đọc dữ liệu từ file HEX với thứ tự hàng → cột → channel
def read_hex_file(filename, shape):
    with open(filename, "r") as file:
        hex_values = file.readlines()

    # Chuyển đổi từ HEX sang số nguyên 16-bit
    data = np.array([int(x.strip(), 16) for x in hex_values], dtype=np.int32)

    # Định dạng lại dữ liệu theo đúng thứ tự hàng → cột → channel
    H, W, C = shape
    reshaped_data = np.zeros((H, W, C), dtype=np.int32)

    index = 0
    for c in range(C):  # Channel trước
        for h in range(H):  # Sau đó duyệt hàng
            for w in range(W):  # Cuối cùng duyệt cột
                reshaped_data[h, w, c] = data[index]
                index += 1

    return reshaped_data

# Hàm ghi dữ liệu ra file HEX theo thứ tự hàng → cột → channel
def write_hex_file(filename, data):
    H, W, C = data.shape
    with open(filename, "w") as file:
        for c in range(C):  # Duyệt qua từng channel
            for h in range(H):  # Duyệt theo hàng
                for w in range(W):  # Duyệt theo cột
                    int_value = int(round(data[h, w, c]))  # Chuyển float thành int
                    hex_value = int_value & 0xFF  # Giữ lại 8 bit thấp nhất
                    file.write(f"{hex_value:02x}\n")  # Định dạng 2 ký tự HEX


input_feature_height = 32
input_feature_width = 32
input_feature_channel = 3
weight_height = 3
weight_width = 3
weight_channel = input_feature_channel
weight_filter = 3
output_feature_height = 32
output_feature_width = 32
output_feature_channel = weight_filter

# Đường dẫn file
input_file = "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/input.hex"
weight_file = "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/weight.hex"
output_file = "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/in-out-weight/output.hex"

# Đọc dữ liệu đầu vào
input_data = read_hex_file(input_file, (input_feature_height, input_feature_width, input_feature_channel))

# Đọc dữ liệu kernel với kích thước 3x3x3 (1 filter)
weight_data_flat = read_hex_file(weight_file, (weight_height, weight_width, weight_channel * weight_filter))

# Reshape lại thành (3,3,3,1) theo thứ tự hàng → cột → channel → filter
weight_data = weight_data_flat.reshape(weight_height, weight_width, weight_channel, weight_filter).transpose(0,1,3,2)

# In kiểm tra kernel
# print("Kernel đọc từ file:")
# for c in range(3):  # Duyệt qua từng channel
#     print(f"Channel {c}:")
#     print(weight_data[:, :, c, 0])  # Hiển thị ma trận 3x3 của channel c
#     print()

# Tạo mô hình Convolution với 1 filter
input_layer = tf.keras.layers.Input(shape=(input_feature_height, input_feature_width, input_feature_channel))
conv_layer = tf.keras.layers.Conv2D(filters=weight_filter, kernel_size=(weight_height, weight_width), padding="same", activation=None)(input_layer)
model = tf.keras.Model(inputs=input_layer, outputs=conv_layer)

# Đặt trọng số cho Conv2D layer với bias = 0
model.layers[1].set_weights([weight_data.astype(np.float32), np.zeros(weight_filter, dtype=np.float32)])  

# Chạy dữ liệu qua mô hình
output_data = model.predict(input_data.reshape(1, input_feature_height, input_feature_width, input_feature_channel).astype(np.float32))
output_data = output_data.reshape(output_feature_height, output_feature_width, output_feature_channel)

# Ghi kết quả ra file HEX
write_hex_file(output_file, output_data)

print(f"Kết quả đã được ghi vào {output_file}")
