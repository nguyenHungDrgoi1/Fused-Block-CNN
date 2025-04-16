def compare_files(file1, file2, pe_id=None):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        # Đọc toàn bộ nội dung của file để tính số dòng
        lines1 = f1.readlines()
        lines2 = f2.readlines()

        # Kiểm tra độ dài số dòng của hai file
        if len(lines1) != len(lines2):
            if pe_id is not None:
                print(f"⚠️ PE{pe_id} - Số dòng của hai file khác nhau: {len(lines1)} (File 1) != {len(lines2)} (File 2)")
            else:
                print(f"⚠️ Số dòng của hai file khác nhau: {len(lines1)} (File 1) != {len(lines2)} (File 2)")

        line_num = 1
        diff_count = 0

        # So sánh nội dung từng dòng
        for line1, line2 in zip(lines1, lines2):
            # Xử lý: xóa khoảng trắng + chuyển về chữ hoa
            clean1 = ''.join(line1.strip().split()).upper()
            clean2 = ''.join(line2.strip().split()).upper()

            if clean1 != clean2:
                if pe_id is not None:
                    print(f"❌ PE{pe_id} - Dòng {line_num} khác nhau:")
                else:
                    print(f"❌ Dòng {line_num} khác nhau:")
                print(f"    File 1: {clean1}")
                print(f"    File 2: {clean2}")
                diff_count += 1

            line_num += 1

    if diff_count == 0:
        if pe_id is not None:
            print(f"✅ PE{pe_id}: Hai file giống nhau!")
        else:
            print("✅ Hai file giống nhau!")
    else:
        print(f"⚠️ PE{pe_id}: Tổng số dòng khác nhau: {diff_count}")
    print("-" * 50)


if __name__ == "__main__":
    for pe in range(16):  # PE0 → PE15
        file1 = f"address/OFM_PE{pe}_DUT.hex"
        file2 = f"address/OFM_PE{pe}_change.hex"
        compare_files(file1, file2, pe_id=pe)
