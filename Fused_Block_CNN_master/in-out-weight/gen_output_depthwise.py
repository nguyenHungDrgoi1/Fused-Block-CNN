import numpy as np
import tensorflow as tf

import numpy as np

def read_hex_file_weight(filename, shape):
    with open(filename, "r") as file:
        hex_values = file.readlines()

    # Chuyển đổi từ HEX sang số nguyên 16-bit (đảm bảo dtype là np.int16 nếu dữ liệu có kích thước 16-bit)
    data = np.array([int(x.strip(), 16) for x in hex_values], dtype=np.int16)

    # Định dạng lại dữ liệu theo đúng thứ tự channel → width → height → filter (theo file)
    C, H, W, F = shape  # File đang lưu theo Channel → Width → Height → Filter
    reshaped_data = np.zeros((C, H, W, F), dtype=np.int16)

    index = 0
    for f in range(F):  # Duyệt qua từng filter
        for w in range(W):  # Duyệt qua từng height (vì file lưu theo channel trước)
            for h in range(H):  # Duyệt theo width
                for c in range(C):  # Duyệt theo channel
                    reshaped_data[c, h, w, f] = data[index]
                    index += 1

    # Chuyển đổi từ (channel → width → height → filter) thành (height → width → channel → filter)
    reshaped_data = reshaped_data.transpose(2, 1, 0, 3)  # Đưa về (H, W, C, F)

    return reshaped_data


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
        for w in range(W):  # Sau đó duyệt hàng
            for h in range(H):  # Cuối cùng duyệt cột
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


input_feature_height = 56
input_feature_width = 56
input_feature_channel = 16
weight_height = 3
weight_width = 3
weight_channel = input_feature_channel
weight_filter = 32
output_feature_height = 56
output_feature_width = 56
output_feature_channel = weight_filter

# Đường dẫn file
input_file = "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/input_56x56x16.hex"
weight_file = "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/weight_16x32_new.hex"
output_file = "C:/Users/Admin/OneDrive - Hanoi University of Science and Technology/Desktop/CNN/Fused-Block-CNN/address/output.hex"

# Đọc dữ liệu đầu vào
input_data = read_hex_file(input_file, (input_feature_height, input_feature_width, input_feature_channel))

# Đọc dữ liệu kernel với kích thước 3x3x3 (1 filter)
weight_data_flat = read_hex_file_weight(weight_file, (weight_channel, weight_height, weight_width , weight_filter))

# Reshape lại thành (3,3,3,1) theo thứ tự hàng → cột → channel → filter
weight_data = weight_data_flat.reshape(weight_height, weight_width, weight_channel, weight_filter)

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

print("100 phần tử đầu tiên của weight:")
print(weight_data.flatten()[:100])  # In ra 100 phần tử đầu tiên dưới dạng mảng 1 chiều
# Ghi kết quả ra file HEX
write_hex_file(output_file, output_data)

print(f"Kết quả đã được ghi vào {output_file}")
# Select the first patch of the input data (3x3x16) for the first output feature map element
first_ifm_patch = input_data[0:3, 0:3, :]  # This is the 3x3 patch of the input feature map (first position in height and width)
print("First patch of Input Feature Map (IFM):")
print(first_ifm_patch)

# Select the first weight kernel (3x3x16) for the first filter
first_weight_kernel = weight_data[:, :, :, 0]  # This selects the first filter (out of 32)
print("\nFirst weight kernel (filter):")
print(first_weight_kernel)

# To compute the first output element (OFM), we compute the dot product between the IFM patch and the kernel:
# Since the weight data is stored as integers, convert it to float32 for dot product calculation
dot_product_result = np.sum(first_ifm_patch * first_weight_kernel.astype(np.float32))
print("\nDot product of first IFM patch and weight kernel for the first OFM element:")
print(dot_product_result)
