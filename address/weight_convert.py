import numpy as np

# Hàm để thay đổi thứ tự lưu trữ
def rearrange_weights(weights, depth, width, length, num_filters):
    # Reshape mảng 1 chiều thành 4 chiều (depth, width, length, num_filters)
    weights_4d = weights.reshape((depth, width, length, num_filters))
    
    # Thay đổi thứ tự các chiều từ (depth, width, length, num_filters) -> (width, length, depth, num_filters)
    rearranged_weights_4d = np.transpose(weights_4d, (1, 2, 0, 3))
    
    # Flatten mảng 4 chiều thành mảng 1 chiều
    rearranged_weights_1d = rearranged_weights_4d.flatten()
    
    return rearranged_weights_1d

# Hàm đọc file hex
def read_hex_file(filename, dtype=np.float32):
    # Đọc dữ liệu từ file hex và chuyển đổi thành mảng NumPy
    data = np.fromfile(filename, dtype=dtype)
    return data

# Hàm ghi file hex
def write_hex_file(filename, data):
    # Ghi dữ liệu vào file hex
    data.tofile(filename)

# Ví dụ sử dụng
if __name__ == "__main__":
    # Thông số kích thước của các chiều
    depth, width, length, num_filters = 16, 3, 3, 32  # Thay đổi các giá trị này cho phù hợp với dữ liệu của bạn

    # Tên file hex đầu vào và đầu ra
    input_file = "address/weight_16x32.hex"
    output_file = "address/weight_16x32_new.hex"

    # Đọc dữ liệu từ file hex
    print(f"Reading data from {input_file}...")
    data = read_hex_file(input_file, dtype=np.float32)  # Đảm bảo kiểu dữ liệu phù hợp

    print("Original data shape (1D):", data.shape)
    print("Original data (first 10 values):", data[:10])

    # Thay đổi thứ tự lưu trữ
    print("\nRearranging weights...")
    rearranged_data = rearrange_weights(data, depth, width, length, num_filters)

    print("Rearranged data shape (1D):", rearranged_data.shape)
    print("Rearranged data (first 10 values):", rearranged_data[:10])

    # Kiểm tra xem dữ liệu có thay đổi không
    if np.array_equal(data, rearranged_data):
        print("\nWarning: Rearranged data is the same as original data! Check the reshape and transpose steps.")
    else:
        print("\nData has been rearranged successfully.")

    # Ghi dữ liệu đã thay đổi vào file hex mới
    print(f"\nWriting rearranged data to {output_file}...")
    write_hex_file(output_file, rearranged_data)

    print("Done!")