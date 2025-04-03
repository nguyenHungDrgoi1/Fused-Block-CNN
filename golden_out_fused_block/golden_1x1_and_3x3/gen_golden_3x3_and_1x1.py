######################################################################################
# Cách kiểm tra giá trị được lấy ra từ tọa độ:                                       #
#line = b * (H * W * C) + y * (W * C) + x * C + c                                    #
#  Ví dụ:                                                                            #
# IFM shape: [1, 56, 56, 32]                                                         #
# Tọa độ: IFM[0, 2, 14, 0]                                                           #                      
# line = 0 * (56*56*32) + 2 * (56*32) + 14*32 + 0                                    #
#      = 2 * 1792 + 448                                                              #
#      = 3584 + 448                                                                  #
#      = 4032                                                                        #
# → Giá trị tại dòng 4033 trong file (do file đánh số từ 1)                          #
######################################################################################

import numpy as np
import random

def write_int_array_to_hex_file(arr, filename):
    arr = np.ascontiguousarray(arr.astype(np.int32))
    flat = arr.flatten()
    with open(filename, "w") as f:
        for val in flat:
            f.write("{:08X}\n".format(np.uint32(val)))

def conv2d_debug(IFM, Weight, kernel_size, stride=1, padding='same', layer_name='', sample_coords=None):
    B, H, W, C_in = IFM.shape
    K_h, K_w = kernel_size
    _, _, _, C_out = Weight.shape

    pad_h = (K_h - 1) // 2 if padding == 'same' else 0
    pad_w = (K_w - 1) // 2 if padding == 'same' else 0
    IFM_padded = np.pad(IFM, ((0, 0), (pad_h, pad_h), (pad_w, pad_w), (0, 0)), mode='constant')

    H_out = (H + 2 * pad_h - K_h) // stride + 1
    W_out = (W + 2 * pad_w - K_w) // stride + 1
    OFM = np.zeros((B, H_out, W_out, C_out), dtype=np.int32)

    print(f"\n🧠 Layer: {layer_name}")
    if sample_coords is None:
        sample_coords = [(0, random.randint(0, H_out-1), random.randint(0, W_out-1), random.randint(0, C_out-1)) for _ in range(10)]

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
                    OFM[b, y, x, m] = val
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

    # Dữ liệu ngẫu nhiên nhỏ dễ kiểm tra
    IFM = np.random.randint(-2, 3, size=(B, H, W, in_ch_expand), dtype=np.int32)
    Weight_expand = np.random.randint(-2, 3, size=(3, 3, in_ch_expand, out_ch_expand), dtype=np.int32)
    Weight_project = np.random.randint(-2, 3, size=(1, 1, in_ch_project, out_ch_project), dtype=np.int32)

    # Layer expand
    OFM_expand, sampled_expand = conv2d_debug(IFM, Weight_expand, (3, 3), layer_name='block2b_expand_conv')

    # Layer project
    OFM_project, sampled_project = conv2d_debug(OFM_expand, Weight_project, (1, 1), layer_name='block2b_project_conv')

    # Ghi file hex
    write_int_array_to_hex_file(IFM, "IFM.hex")
    write_int_array_to_hex_file(Weight_expand, "Weight_expand.hex")
    write_int_array_to_hex_file(Weight_project, "Weight_project.hex")
    write_int_array_to_hex_file(OFM_expand, "Golden_OFM_expand.hex")
    write_int_array_to_hex_file(OFM_project, "Golden_OFM_project.hex")

    print("\n✅ Đã ghi xong tất cả file .hex")
    return OFM_expand, OFM_project

# Gọi main để lấy kết quả
OFM_expand_result, OFM_project_result = main()
######################################################################################
# Gọi ví dụ:  CÁI NÀY ĐỂ CHỈ ĐỊNH TỌA ĐỘ MÀ MÌNH MUỐN XEM                            #                                 
# inspect_ofm_value(OFM_expand_result, 0, 2, 14, 0)                                  #
# inspect_ofm_value(OFM_expand_result, 0, 0, 0, 0)                                   #
# inspect_ofm_value(OFM_project_result, 0, 10, 10, 5)                                #
######################################################################################
