import argparse

def read_and_write_file(input_file, output_file, n, m, num_segments, offset, weight_height, weight_channel):
    try:
        with open(input_file, "r") as in_file:
            lines = in_file.readlines()

        start_offset = 0
        if offset != 0:
            start_offset = weight_height * weight_height * weight_channel * offset

        current_index = start_offset
        output_lines = []

        for segment in range(num_segments):
            # Đọc n giá trị
            segment_data = lines[current_index:current_index + n]
            output_lines.extend(segment_data)

            current_index += n + m  # Bỏ qua m giá trị

        # Ghi ra file
        with open(output_file, "w") as out_file:
            for line in output_lines:
                out_file.write(line.strip().upper() + '\n')

        print(f"Hoàn thành ghi file: {output_file}")
    except Exception as e:
        print(f"Lỗi khi xử lý file: {e}")

def main():
    # Cố định các tham số
    pe = 4  # Số lượng PE
    filter_count = 32  # Số lượng filters
    weight_height = 3  # Chiều cao của weight
    weight_channel = 128  # Số lượng channel của weight

    input_file = "../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight2.hex"
    tile = filter_count // pe
    weight_size = weight_height * weight_height * weight_channel
    offset = weight_size * (pe - 1)
    num_segments = filter_count // pe

    # Gọi hàm đọc và ghi cho từng PE
    for pe_id in range(pe):
        output_file = f"../Fused-Block-CNN/golden_out_fused_block/weight_hex_folder/weight2_PE{pe_id}.hex"
        read_and_write_file(input_file, output_file, weight_size, offset, num_segments, pe_id, weight_height, weight_channel)

if __name__ == "__main__":
    main()
