import tensorflow as tf
import numpy as np

# Hàm Sigmoid trong TensorFlow
def sigmoid_tf(input):
    return tf.sigmoid(input)

# Hàm kiểm tra tính đúng đắn của hàm C
def check_sigmoid(input):
    # Chuyển input thành tensor của TensorFlow
    input_tensor = tf.convert_to_tensor(input, dtype=tf.float32)

    # Áp dụng hàm Sigmoid từ TensorFlow
    output_tensor = sigmoid_tf(input_tensor)

    return output_tensor.numpy()

# Ví dụ kiểm tra
if __name__ == "__main__":
    # Tạo dữ liệu đầu vào giả lập (batch_size, height, width, channels)
    input = np.array([[[[1.0, -2.0, 3.0], [4.0, -5.0, 6.0], [-7.0, 8.0, 9.0]],
                       [[10.0, -11.0, 12.0], [-13.0, 14.0, 15.0], [16.0, -17.0, 18.0]],
                       [[19.0, 20.0, -21.0], [22.0, -23.0, 24.0], [25.0, -26.0, 27.0]]]])

    # Áp dụng hàm Sigmoid trong TensorFlow cho ma trận 3D
    output = tf.keras.layers.BatchNormalization(axis=3, name= "bn")(input)

    # In kết quả
    print("Kết quả sau khi áp dụng Sigmoid (TensorFlow):")
    print(output)
