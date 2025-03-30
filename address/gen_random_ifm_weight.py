import numpy as np
import argparse

def save_to_hex_file(data, filename):
    with open(filename, 'w') as f:
        for val in data.flatten():
            int_val = int(val)
            f.write(f"{int_val & 0xFF:02X}\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--ifm_height", type=int, required=True)
    parser.add_argument("--ifm_width", type=int, required=True)
    parser.add_argument("--ifm_channel", type=int, required=True)
    parser.add_argument("--weight_height", type=int, required=True)
    parser.add_argument("--weight_width", type=int, required=True)
    parser.add_argument("--weight_filter", type=int, required=True)
    parser.add_argument("--padding", type=int, default=0)
    args = parser.parse_args()

    np.random.seed(42)
    IFM = np.random.randint(0, 256, size=(args.ifm_height, args.ifm_width, args.ifm_channel), dtype=np.uint8)
    Weight = np.random.randint(0, 256, size=(args.weight_filter, args.weight_height, args.weight_width, args.ifm_channel), dtype=np.uint8)

    padded_height = args.ifm_height + 2 * args.padding
    padded_width = args.ifm_width + 2 * args.padding

    save_to_hex_file(IFM ,"../Fused-Block-CNN/address/ifm_padded.hex")
    save_to_hex_file(Weight, "../Fused-Block-CNN/address/weight.hex")
    print("✅ Đã lưu IFM (padded) và Weight.")
