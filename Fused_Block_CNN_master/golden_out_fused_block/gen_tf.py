import numpy as np
import tensorflow as tf
import math

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

def write_hex_file(filename, data):
    H, W, C = data.shape
    with open(filename, "w") as file:
        for c in range(C):
            for h in range(H):
                for w in range(W):
                    int_value = int(round(data[h, w, c]))
                    hex_value = int_value & 0xFF
                    file.write(f"{hex_value:02X}\n")

# === Main ===
if __name__ == "__main__":
    # Cố định tham số cho Conv1
    ifm_height = 58
    ifm_width = 58
    ifm_channel = 16
    weight_height = 3
    weight_width = 3
    weight_filter = 128
    padding = 0
    stride = 1

    # Cố định tham số cho Conv2
    weight2_height = 1
    weight2_width = 1
    weight2_filter = 32
    padding2 = 0
    stride2 = 1

    # === Conv1 Output Dimensions ===
    ofm1_height = (ifm_height - weight_height + 2 * padding) // stride + 1
    ofm1_width  = (ifm_width  - weight_width  + 2 * padding) // stride + 1
    ofm1_channel = weight_filter

    # === Conv2 Output Dimensions ===
    ofm2_height = (ofm1_height - weight2_height + 2 * padding2) // stride2 + 1
    ofm2_width  = (ofm1_width  - weight2_width  + 2 * padding2) // stride2 + 1
    ofm2_channel = weight2_filter

    # === File paths ===
    input_file = "../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/ifm.hex"
    weight1_file = "../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1.hex"
    weight2_file = "../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight2.hex"
    output_file1 = "../Fused-Block-CNN/golden_out_fused_block/output_hex_folder/ofm1.hex"
    output_file2 = "../Fused-Block-CNN/golden_out_fused_block/output_hex_folder/ofm2.hex"

    # === Đọc dữ liệu ===
    input_data = read_hex_file(input_file, (ifm_height, ifm_width, ifm_channel))
    weight1_data = read_hex_file_weight(weight1_file, (weight_height, weight_width, ifm_channel, weight_filter))
    weight2_data = read_hex_file_weight(weight2_file, (weight2_height, weight2_width, weight_filter, weight2_filter))

    tf_padding1 = "same" if padding > 0 else "valid"
    tf_padding2 = "same" if padding2 > 0 else "valid"

    # === Tạo mô hình 2 lớp Conv ===
    input_layer = tf.keras.layers.Input(shape=(ifm_height, ifm_width, ifm_channel))
    conv1 = tf.keras.layers.Conv2D(
        filters=weight_filter,
        kernel_size=(weight_height, weight_width),
        strides=(stride, stride),
        padding=tf_padding1,
        activation=None)(input_layer)

    conv2 = tf.keras.layers.Conv2D(
        filters=weight2_filter,
        kernel_size=(weight2_height, weight2_width),
        strides=(stride2, stride2),
        padding=tf_padding2,
        activation=None)(conv1)

    model = tf.keras.Model(inputs=input_layer, outputs=[conv1, conv2])

    # Gán trọng số
    model.layers[1].set_weights([weight1_data.astype(np.float32), np.zeros(weight_filter, dtype=np.float32)])
    model.layers[2].set_weights([weight2_data.astype(np.float32), np.zeros(weight2_filter, dtype=np.float32)])

    # Dự đoán
    input_tensor = input_data.reshape(1, ifm_height, ifm_width, ifm_channel).astype(np.float32)
    output_conv1, output_conv2 = model.predict(input_tensor)

    # Reshape và ghi ra file HEX
    write_hex_file(output_file1, output_conv1.reshape(ofm1_height, ofm1_width, ofm1_channel))
    # write_hex_file(output_file2, output_conv2.reshape(ofm2_height, ofm2_width, ofm2_channel))

    print(f"Đã ghi kết quả Conv1 vào {output_file1}")
    print(f"Đã ghi kết quả Conv2 vào {output_file2}")
    output_conv2_reshaped = output_conv2.reshape(ofm2_height, ofm2_width, ofm2_channel)
    print(f"Reshaped Conv2: {output_conv2_reshaped.shape}")
    write_hex_file(output_file2, output_conv2_reshaped)
    print(output_conv2)


