import numpy as np

def save_to_hex_file(data, filename):
    with open(filename, 'w') as f:
        for val in data.flatten():
            int_val = int(val)
            f.write(f"{int_val & 0xFF:02X}\n")

if __name__ == "__main__":
    # Cố định tham số cho Conv1
    ifm_height = 58
    ifm_width = 58
    ifm_channel = 32
    weight_height = 3
    weight_width = 3
    weight_filter = 128
    padding = 0

    # Cố định tham số cho Conv2
    weight2_height = 1
    weight2_width = 1
    weight2_filter = 32
    padding2 = 0
    stride2 = 1

    np.random.seed(30)
    IFM = np.random.randint(0, 4, size=(ifm_height, ifm_width, ifm_channel), dtype=np.uint8)
    Weight1 = np.random.randint(0, 4, size=(weight_filter, weight_height, weight_width, ifm_channel), dtype=np.uint8)
    Weight2 = np.random.randint(0, 4, size=(weight2_filter, weight2_height, weight2_width, weight_filter), dtype=np.uint8)

    padded_height = ifm_height + 2 * padding
    padded_width = ifm_width + 2 * padding

    save_to_hex_file(IFM, "../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/ifm.hex")
    save_to_hex_file(Weight1, "../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight1.hex")
    save_to_hex_file(Weight2, "../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight2.hex")
    print("✅ Đã lưu IFM (padded) và Weight.")
