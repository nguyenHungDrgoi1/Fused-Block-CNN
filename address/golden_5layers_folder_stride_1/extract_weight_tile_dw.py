import argparse
import math

def read_and_write_file(input_file, output_file, n, m, num_segments, offset, weight_height, weight_channel):
    try:
        with open(input_file, "r") as in_file:
            lines = in_file.readlines()

        start_offset = 0
        if offset != 0:
            start_offset = weight_height * weight_height * offset

        current_index = start_offset
        output_lines = []

        for segment in range(num_segments):
            # Đọc n giá trị
            segment_data = lines[current_index:current_index + n]
            output_lines.extend(segment_data)
            current_index += n + m  # Bỏ qua m giá trị

        # Làm sạch và chuẩn hóa dòng
        output_lines = [line.strip().upper() for line in output_lines]

        # === Thêm '00' nếu chưa chia hết cho 16 ===
        remainder = len(output_lines) % 16
        if remainder != 0:
            padding_needed = 16 - remainder
            output_lines.extend(['00'] * padding_needed)
            print(f"⚠️ File {output_file} chưa chia hết cho 16. Đã thêm {padding_needed} dòng '00'.")

        # Ghi ra file
        with open(output_file, "w") as out_file:
            for line in output_lines:
                out_file.write(line + '\n')

        print(f"✅ Hoàn thành ghi file: {output_file} ({len(output_lines)} dòng)")
    except Exception as e:
        print(f"❌ Lỗi khi xử lý file {output_file}: {e}")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--pe", type=int, default=16)
    parser.add_argument("--filter_count", type=int, required=True)
    parser.add_argument("--weight_height", type=int, default=3)
    parser.add_argument("--weight_channel", type=int, required=True)
    args = parser.parse_args()
    input_file = "../Fused-Block-CNN/address/golden_5layers_folder_stride_1/hex/DW/weight_2.hex"
    weight_size = args.weight_height * args.weight_height 
    offset = weight_size * (args.pe - 1)
    num_segments = args.weight_channel // args.pe

    for pe in range(args.pe):
        output_file = f"../Fused-Block-CNN/address/golden_5layers_folder_stride_1/hex/DW/weight2_PE{pe}.hex"
        read_and_write_file(input_file, output_file, weight_size, offset, num_segments, pe, args.weight_height, args.weight_channel)

if __name__ == "__main__":
    main()