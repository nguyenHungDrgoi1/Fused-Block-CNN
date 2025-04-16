import argparse

def read_and_write_file(input_file, output_file, n, m, num_segments, offset, ofm_height):
    try:
        with open(input_file, "r") as in_file:
            lines = in_file.readlines()

        start_offset = 0
        if offset != 0:
            start_offset = ofm_height * ofm_height * offset

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
    # Cố định tham số
    pe = 4
    ofm_channel = 32
    ofm_height = 56

    input_file = "../Fused-Block-CNN/golden_out_fused_block/output_hex_folder/ofm2.hex"
    ofm_size = ofm_height * ofm_height
    offset = ofm_size * (pe - 1)
    num_segments = ofm_channel // pe

    for pe_id in range(pe):
        output_file = f"../Fused-Block-CNN/golden_out_fused_block/output_hex_folder/OFM2_PE{pe_id}.hex"
        read_and_write_file(input_file, output_file, ofm_size, offset, num_segments, pe_id, ofm_height)

if __name__ == "__main__":
    main()
