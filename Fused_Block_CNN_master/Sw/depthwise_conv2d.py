import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Input, DepthwiseConv2D

# ---------------------
# 1. Tạo dữ liệu đầu vào (3 kênh, mỗi kênh 3x3)
#    Mỗi kênh là một mảng 3x3 tương ứng với "1 cụm 9 số".
# ---------------------
channel_1 = [
    [58, 62, 66],
    [70, 74, 78],
    [82, 87, 90]
]
channel_2 = [
    [2, 5, 8],
    [2, 5, 8],
    [2, 5, 8]
]
channel_3 = [
    [3, 6, 9],
    [3, 6, 9],
    [3, 6, 9]
]

# Gom 3 kênh lại thành mảng có shape (3, 3, 3)
# axis=-1 tức là dồn các kênh thành cột cuối cùng (channel dimension).
input_data = np.stack([channel_1, channel_2, channel_3], axis=-1)

# Thêm batch dimension để có shape (1, 3, 3, 3)
input_data = np.expand_dims(input_data, axis=0)

# Chuyển sang float32 (phù hợp với TensorFlow)
input_data = input_data.astype(np.float32)

# ---------------------
# 2. Xây dựng mô hình DepthwiseConv2D
# ---------------------
input_layer = Input(shape=(3, 3, 3), dtype=tf.float32)
conv_layer = DepthwiseConv2D(
    kernel_size=(3, 3),
    padding='same',
    use_bias=False,
    dtype=tf.float32
)(input_layer)
model = Model(inputs=input_layer, outputs=conv_layer)

# ---------------------
# 3. Tùy chỉnh trọng số kernel (3,3,3,1) - toàn 1
# ---------------------
custom_kernel = np.ones((3, 3, 3, 1), dtype=np.float32)
model.layers[1].set_weights([custom_kernel])

# ---------------------
# 4. Chạy mô hình (dự đoán)
# ---------------------
output = model.predict(input_data)

# ---------------------
# 5. In kết quả
# ---------------------
print("Input shape:", input_data.shape)   # (1, 3, 3, 3)
print("Output shape:", output.shape)      # (1, 3, 3, 3) vì depth_multiplier mặc định = 1

# In chi tiết từng kênh đầu ra
print("\nOutput Data (3x3x3):")
for i in range(output.shape[-1]):
    print(f"Kênh {i + 1} (Đầu ra):")
    # Không transpose nữa để xem ma trận ở dạng [hàng, cột]
    print(output[0, :, :, i])
