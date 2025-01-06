import numpy as np
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Input, Conv2D

# 1. Tạo dữ liệu đầu vào giả lập (kích thước 3x3x3)
input_data = np.array([[[1, 5, 5], [2, 1, 5], [0, 3, 1]],
                       [[2, 1, 1], [1, 2, 1], [1, 1, 2]],
                       [[3, 0, 2], [0, 3, 0], [2, 0, 3]]])
# Đảm bảo rằng đầu vào có shape (1, 3, 3, 3)
input_data = np.expand_dims(input_data, axis=0)  # Thêm chiều batch, shape sẽ là (1, 3, 3, 3)

# 2. Xây dựng mô hình với Conv2D
input_layer = Input(shape=(3, 3, 3))  # Đầu vào 3x3x3
conv_layer = Conv2D(filters=1, kernel_size=(3, 3), strides=(1, 1),padding = 'same', use_bias=False)(input_layer)  # Kernel 3x3 với padding='same'
model = Model(inputs=input_layer, outputs=conv_layer)

# 3. Khởi tạo trọng số cho kernel (tùy chỉnh trọng số nếu muốn)
weights = model.layers[1].get_weights()

# Thay thế kernel bằng một ma trận 3x3x3 (ví dụ tùy chỉnh)
custom_kernel = np.array([[[[1], [1], [1]],
                           [[1], [1], [1]],
                           [[1], [1], [1]]],

                          [[[1], [1], [1]],
                           [[1], [1], [1]],
                           [[1], [1], [1]]],

                          [[[1], [1], [1]],
                           [[1], [1], [1]],
                           [[1], [1], [1]]]])

weights[0] = custom_kernel  # Kernel trọng số
model.layers[1].set_weights(weights)  # Set lại trọng số kernel

# 4. Dự đoán và in ra kết quả
output = model.predict(input_data)
# print("Input Data (3x3x3):")
# for i in range(input_data.shape[-1]):  # Lặp qua từng kênh đầu vào
#     print(f"Kênh {i + 1}:")
#     print(input_data[0, :, :, i])

# # 6. In dữ liệu đầu ra (từng kênh)
print("\nOutput Data (3x3x3):")
for i in range(output.shape[-1]):  # Lặp qua từng kênh đầu ra
    print(f"Kênh {i + 1} (Đầu ra):")
    print(np.transpose(output[0, :, :, i]))
# print(output)
