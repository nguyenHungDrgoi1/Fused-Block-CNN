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
    input_file = "../Fused-Block-CNN/address/ofm.hex"

    PE = 16
    filter_count = 32
    tile = filter_count // PE

    ofm_height = 54
    ofm_size = ofm_height * ofm_height
    offset = ofm_height * ofm_height * (PE - 1)
    num_segments = 2

    for pe in range(PE):
        output_file = f"../Fused-Block-CNN/address/OFM_PE{pe}.hex"
        read_and_write_file(input_file, output_file, ofm_size, offset, num_segments, pe, ofm_height)


if __name__ == "__main__":
    main()
