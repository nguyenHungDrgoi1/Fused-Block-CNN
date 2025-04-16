import numpy as np
import tensorflow as tf
from tensorflow.keras import Model
CONV_KERNEL_INITIALIZER = tf.keras.initializers.Ones()
# Hàm MBConv từ đoạn code trước
def block(
    inputs,
    activation="ReLu",
    drop_rate=0.0,
    name="",
    filters_in=32,
    filters_out=16,
    kernel_size=4,
    strides=1,
    expand_ratio=1,
    se_ratio=0.0,
    id_skip=True,
):
    bn_axis = 3 if tf.keras.backend.image_data_format() == "channels_last" else 1

    # Expansion phase
    x = tf.keras.layers.Conv2D(
        16,
        kernel_size = (1,1),
        padding="same",
        use_bias=False,
        kernel_initializer=CONV_KERNEL_INITIALIZER,
        name=name + "expand_conv",
    )(inputs)
    # print(x)
        # x = tf.keras.layers.BatchNormalization(axis=bn_axis, name=name + "expand_bn")(x)
    #x = tf.keras.layers.Activation(activation, name=name + "expand_activation")(x)

    # Depthwise Convolution
    if strides == 2:
        x = tf.keras.layers.ZeroPadding2D(
            padding=((kernel_size // 2, kernel_size // 2), (kernel_size // 2, kernel_size // 2)),
            name=name + "dwconv_pad",
        )(x)
        conv_pad = "valid"
    else:
        conv_pad = "same"
    x = tf.keras.layers.DepthwiseConv2D(
        kernel_size,
        strides=strides,
        padding=conv_pad,
        use_bias=False,
        depthwise_initializer=CONV_KERNEL_INITIALIZER,
        name=name + "dwconv",
    )(x)
    # #x = tf.keras.layers.BatchNormalization(axis=bn_axis, name=name + "bn")(x)
    # x = tf.keras.layers.Activation("swish", name=name + "activation")(x)

    # Squeeze-and-Excitation
    if 0 < se_ratio <= 1:
        filters_se = max(1, int(filters_in * se_ratio))
        se = tf.keras.layers.GlobalAveragePooling2D(name=name + "se_squeeze")(x)
        se = tf.keras.layers.Reshape((1, 1, 16), name=name + "se_reshape")(se)
        se = tf.keras.layers.Conv2D(
            4,
            1,
            padding="same",
            # activation="sigmoid",
            kernel_initializer=CONV_KERNEL_INITIALIZER,
            name=name + "se_reduce",
        )(se)
        se = tf.keras.layers.Conv2D(
            16,
            1,
            padding="same",
            # activation="sigmoid",
            kernel_initializer=CONV_KERNEL_INITIALIZER,
            name=name + "se_expand",
        )(se)
        x = tf.keras.layers.multiply([x, se], name=name + "se_excite")

    # Projection phase
    x = tf.keras.layers.Conv2D(
        4,
        1,
        padding="same",
        use_bias=False,
        kernel_initializer=CONV_KERNEL_INITIALIZER,
        name=name + "project_conv",
    )(x)
    x = tf.keras.layers.BatchNormalization(axis=bn_axis, name=name + "project_bn")(x)

    # Skip connection
    if id_skip and strides == 1 and filters_in == filters_out:
        if drop_rate > 0:
            x = tf.keras.layers.Dropout(
                drop_rate, noise_shape=(None, 1, 1, 1), name=name + "drop"
            )(x)
        x = tf.keras.layers.add([x, inputs], name=name + "add")

    return x

# Tạo mô hình MBConv
def create_mbconv_model():
    input_tensor = tf.keras.layers.Input(shape=(3,3,4), name="input")
    output_tensor = block(
        inputs=input_tensor,
        activation="swish",
        drop_rate=0.2,
        filters_in=3,
        filters_out=16,
        kernel_size=3,
        strides=1,
        expand_ratio=1,
        se_ratio=0.25,
        id_skip=True,
        name="mbconv_",
    )
    model = Model(inputs=input_tensor, outputs=output_tensor, name="MBConv_Model")
    return model

# Tạo mô hình
model = create_mbconv_model()

# Hiển thị cấu trúc mô hình
model.summary()

# Tạo dữ liệu đầu vào: ma trận các số nguyên
# Tạo đầu vào cố định
input_data = np.array([
    [[[1, 4, 7,10], [1, 4, 7,10], [1, 4, 7,10]],
     [[2, 5, 8,11], [2, 5, 8,11], [2, 5, 8,11]],
     [[3, 6, 9,12], [3, 6, 9,12], [3, 6, 9,12]]]
]).astype(np.float32)  # Kích thước (1, 3, 3, 3)
print("hung ngu")
print(input_data.shape)
print(input_data)
print("Input Channels:")
for channel in range(input_data.shape[-1]):
    print(f"Channel {channel + 1}:\n", input_data[0, :, :, channel])

# Chạy mô hình với dữ liệu thực tế
print("\nIn kết quả của từng lớp:")
for layer in model.layers:
    # Bỏ qua lớp đầu vào vì không có đầu ra
    if "input" in layer.name:
        continue
    if "mbconv_se_squeeze" in layer.name:
        print(output)
        continue
    if "mbconv_se_reshape" in layer.name:
        print(output)
        continue
    # Tạo một mô hình trung gian
    intermediate_model = Model(inputs=model.input, outputs=layer.output)
    
    # Chạy dữ liệu qua lớp
    output = intermediate_model.predict(input_data)
    
    # In tên lớp và đầu ra
    print(f"\nLớp {layer.name}:")
    print("\nOutput Channels:")
    # print(output)

