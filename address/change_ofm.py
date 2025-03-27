import os

MAX_LINE_LENGTH = 100
OFFSET = 3136  # Khoảng cách dòng
MAX_PE = 16  # Tổng số PE: từ PE0 đến PE15
SIZE = 25088 

# Đếm tổng số dòng trong file
def count_lines(filename):
    try:
        with open(filename, 'r') as file:
            return sum(1 for line in file)
    except FileNotFoundError:
        print(f"❌ File '{filename}' không tồn tại!")
        return -1

# Hàm xử lý 1 PE
def process_pe_file(pe_id):
    input_file = f"../Fused-Block-CNN/address/OFM_PE{pe_id}.hex"
    output_file = f"../Fused-Block-CNN/address/OFM_PE{pe_id}_change.hex"

    # Đếm số dòng trong file
    total_lines = count_lines(input_file)
    if total_lines < OFFSET + 1:
        print(f"⚠️ PE{pe_id}: File không đủ {OFFSET + 1} dòng để ghép!")
        return

    try:
        with open(input_file, 'r') as in_file:
            lines = in_file.readlines()

        # Mở file output để ghi
        with open(output_file, 'w') as out_file:
            # Ghi các dòng theo thứ tự: dòng i → dòng i + OFFSET → dòng i + a * OFFSET (a từ 1 đến 8)
            for i in range(total_lines - OFFSET):
                # Chuyển thành chữ thường
                lines[i] = lines[i].lower()
                lines[i + OFFSET] = lines[i + OFFSET].lower()

                # Ghi dòng i và dòng i + OFFSET vào file output
                out_file.write(lines[i])
                out_file.write(lines[i + OFFSET])

                # Ghi thêm các dòng i + a * OFFSET, với a từ 2 đến 8
                for a in range(2, 9):
                    index = i + a * OFFSET
                    if index < total_lines:
                        lines[index] = lines[index].lower()
                        out_file.write(lines[index])

        print(f"✅ PE{pe_id}: Đã ghi xong vào '{output_file}'")

    except FileNotFoundError:
        print(f"❌ PE{pe_id}: Không thể mở file input '{input_file}' hoặc file output '{output_file}'.")

# Hàm chính
def main():
    for pe in range(MAX_PE):
        process_pe_file(pe)

    print(f"\n🚀 Đã xử lý xong tất cả {MAX_PE} PE!")

if __name__ == "__main__":
    main()
