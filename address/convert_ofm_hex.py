import numpy as np

# Bước 1: Đọc file ofm.hex
with open("address/ofm.hex", "r") as f:
    hex_data = [line.strip() for line in f if line.strip() != '']

# Bước 2: Chuyển hex -> số nguyên
int_data = [int(x, 16) for x in hex_data]

# Bước 3: Đặt kích thước ban đầu (w, h, c)
w, h, c = 54, 54, 32  # Điều chỉnh theo dữ liệu thực tế

# Tổng số phần tử
expected_len = w * h * c
assert len(int_data) == expected_len, f"Sai số lượng phần tử: {len(int_data)} != {expected_len}"

# Bước 4: Chuyển thành numpy array và reshape (w, h, c)
data = np.array(int_data, dtype=np.uint8).reshape((w, h, c))  # đúng thứ tự đã cho

# Bước 5: Transpose -> (c, w, h)
reordered = np.transpose(data, (2, 0, 1))

# Bước 6: Ghi ra file hex mới theo thứ tự (c, w, h)
with open("ofm_reordered.hex", "w") as f_out:
    for c_idx in range(c):
        for w_idx in range(w):
            for h_idx in range(h):
                val = reordered[c_idx, w_idx, h_idx]
                f_out.write(f"{val:02X}\n")
