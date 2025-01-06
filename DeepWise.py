import numpy as np
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Input, DepthwiseConv2D

# 1. Tạo dữ liệu đầu vào giả lập (kích thước 3x3x3)
input_data = np.array([[[1, 5, 5], [2, 1, 5], [0, 3, 1]],
                       [[2, 1, 1], [1, 2, 1], [1, 1, 2]],
                       [[3, 0, 2], [0, 3, 0], [2, 0, 3]]])

print(input_data)

# Đảm bảo rằng đầu vào có shape (1, 3, 3, 3)
input_data = np.expand_dims(input_data, axis=0)

# 2. Xây dựng mô hình DepthwiseConv2D
input_layer = Input(shape=(3, 3, 3))
conv_layer = DepthwiseConv2D(kernel_size=(3, 3), padding='same', use_bias=False)(input_layer)
model = Model(inputs=input_layer, outputs=conv_layer)

# 3. Tùy chỉnh trọng số kernel
# Kernel có kích thước (3, 3, 3, 1)
custom_kernel = np.array([[[[1], [1], [1]],
                           [[1], [1], [1]],
                           [[1], [1], [1]]],

                          [[[1], [1], [1]],
                           [[1], [1], [1]],
                           [[1], [1], [1]]],

                          [[[1], [1], [1]],
                           [[1], [1], [1]],
                           [[1], [1], [1]]]])
model.layers[1].set_weights([custom_kernel])

# 4. Dự đoán và in kết quả
output = model.predict(input_data)

# 5. In dữ liệu đầu vào (từng kênh)
# 6. In dữ liệu đầu ra (từng kênh)
print("\nOutput Data (3x3x3):")
for i in range(output.shape[-1]):  # Lặp qua từng kênh đầu ra
    print(f"Kênh {i + 1} (Đầu ra):")
    print(np.transpose(output[0, :, :, i]))
