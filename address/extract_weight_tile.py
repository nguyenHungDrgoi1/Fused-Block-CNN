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
    input_file = "../Fused-Block-CNN/address/weight.hex"

    PE = 16
    filter_count = 128
    tile = filter_count // PE

    weight_height = 3
    weight_channel = 32
    weight_size = weight_height * weight_height * weight_channel
    offset = weight_size * (PE - 1)
    num_segments = filter_count // PE

    for pe in range(PE):
        output_file = f"../Fused-Block-CNN/address/weight_PE{pe}.hex"
        read_and_write_file(input_file, output_file, weight_size, offset, num_segments, pe, weight_height, weight_channel)


if __name__ == "__main__":
    main()
