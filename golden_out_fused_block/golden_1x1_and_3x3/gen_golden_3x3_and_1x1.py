
import numpy as np
import random


def write_uint_array_to_hex_file_depth_width_height_batch(arr, filename):
    arr = np.ascontiguousarray(arr.astype(np.uint32))
    B, H, W, C = arr.shape
    with open(filename, "w") as f:
        for c in range(C):
            for w in range(W):
                for h in range(H):
                    for b in range(B):
                        val = arr[b, h, w, c]
                        f.write("{:08X}\n".format(val))

def write_uint_array_to_hex_file(arr, filename):
    arr = np.ascontiguousarray(arr.astype(np.uint32))
    B, H, W, C = arr.shape
    with open(filename, "w") as f:

        for val in flat:
            f.write("{:08X}\n".format(val))
        for c in range(C):
            for w in range(W):
                for h in range(H):
                    for b in range(B):
                        val = arr[b, h, w, c]
                        f.write("{:08X}\n".format(val))

def conv2d_debug(IFM, Weight, kernel_size, stride=1, padding='same', layer_name='', sample_coords=None):
    B, H, W, C_in = IFM.shape
    K_h, K_w = kernel_size
    _, _, _, C_out = Weight.shape

    pad_h = (K_h - 1) // 2 if padding == 'same' else 0
    pad_w = (K_w - 1) // 2 if padding == 'same' else 0
    IFM_padded = np.pad(IFM, ((0, 0), (pad_h, pad_h), (pad_w, pad_w), (0, 0)), mode='constant')

    H_out = (H + 2 * pad_h - K_h) // stride + 1
    W_out = (W + 2 * pad_w - K_w) // stride + 1
    OFM = np.zeros((B, H_out, W_out, C_out), dtype=np.uint32)

    print(f"\n🧠 Layer: {layer_name}")
    if sample_coords is None:
        sample_coords = [(0, random.randint(0, H_out - 1), random.randint(0, W_out - 1), random.randint(0, C_out - 1)) for _ in range(10)]

    for b in range(B):
        for y in range(H_out):
            for x in range(W_out):
                for m in range(C_out):
                    val = 0
                    expr = []
                    for i in range(K_h):
                        for j in range(K_w):
                            for c in range(C_in):
                                in_y = y * stride + i
                                in_x = x * stride + j
                                a = IFM_padded[b, in_y, in_x, c]
                                w = Weight[i, j, c, m]
                                val += a * w
                                expr.append(f"IFM[{b},{in_y},{in_x},{c}]*W[{i},{j},{c},{m}]")
                    OFM[b, y, x, m] = np.uint32(val)
                    if (b, y, x, m) in sample_coords:
                        print(f"OFM[{b},{y},{x},{m}] = " + " + ".join(expr) + f" = {val}")
    return OFM, sample_coords

def inspect_ofm_value(OFM, b, y, x, m):
    val = OFM[b, y, x, m]
    print(f"🔍 Giá trị tại OFM[{b},{y},{x},{m}] = {val}")
    return val

def main():
    # Cấu hình
    B, H, W = 1, 56, 56
    in_ch_expand, out_ch_expand = 32, 128
    in_ch_project, out_ch_project = 128, 32


    # Sinh dữ liệu ngẫu nhiên nhỏ hơn 0xFF (unsigned)

    # Sinh ngẫu nhiên số nhỏ < 0xFF, kiểu uint32

    IFM = np.random.randint(0, 0xFF, size=(B, H, W, in_ch_expand), dtype=np.uint32)
    Weight_expand = np.random.randint(0, 0xFF, size=(3, 3, in_ch_expand, out_ch_expand), dtype=np.uint32)
    Weight_project = np.random.randint(0, 0xFF, size=(1, 1, in_ch_project, out_ch_project), dtype=np.uint32)

    # Layer expand
    OFM_expand, _ = conv2d_debug(IFM, Weight_expand, (3, 3), layer_name='block2b_expand_conv')

    # Layer project
    OFM_project, _ = conv2d_debug(OFM_expand, Weight_project, (1, 1), layer_name='block2b_project_conv')

    # Ghi file hex theo thứ tự C → W → H → B
    write_uint_array_to_hex_file_depth_width_height_batch(IFM, "IFM.hex")
    write_uint_array_to_hex_file_depth_width_height_batch(Weight_expand, "Weight_expand.hex")
    write_uint_array_to_hex_file_depth_width_height_batch(Weight_project, "Weight_project.hex")
    write_uint_array_to_hex_file_depth_width_height_batch(OFM_expand, "Golden_OFM_expand.hex")
    write_uint_array_to_hex_file_depth_width_height_batch(OFM_project, "Golden_OFM_project.hex")

    print("\n✅ Đã ghi xong tất cả file .hex (theo thứ tự C → X → Y → B)")
    return OFM_expand, OFM_project

# Chạy chương trình
OFM_expand_result, OFM_project_result = main()



# Gọi ví dụ:
# inspect_ofm_value(OFM_expand_result, 0, 0, 0, 0)
# inspect_ofm_value(OFM_project_result, 0, 10, 10, 5)

######################################################################################
# Gọi ví dụ:  CÁI NÀY ĐỂ CHỈ ĐỊNH TỌA ĐỘ MÀ MÌNH MUỐN XEM                            #
# (Tọa độ theo các chiều mặc định của Python: b,x,y,c)                               #                                 
# inspect_ofm_value(OFM_expand_result, 0, 2, 14, 0)                                  #
# inspect_ofm_value(OFM_expand_result, 0, 0, 0, 0)                                   #
# inspect_ofm_value(OFM_project_result, 0, 10, 10, 5)                                #
######################################################################################
