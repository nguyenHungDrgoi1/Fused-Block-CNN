import os
import numpy as np

def get_line_index_CXYB(b, h, w, c, H, W, C):
    return c * (W * H * 1) + w * (H * 1) + h * 1 + b

def check_hex_value(filename, b, h, w, c, H, W, C):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(script_dir, filename)

    line_idx = get_line_index_CXYB(b, h, w, c, H, W, C)

    try:
        with open(file_path, "r") as f:
            lines = f.readlines()
            if line_idx >= len(lines):
                print(f"❌ Dòng {line_idx} vượt quá số dòng trong file {filename}")
                return
            value = lines[line_idx].strip()
            uint_val = np.uint32(int(value, 16))  # ✅ lấy giá trị unsigned

            print(f"\n📁 File: {filename}")
            print(f"📍 Tọa độ [b,h,w,c] = [{b},{h},{w},{c}]")
            print(f"➡️  Dòng số: {line_idx} (dòng thứ {line_idx+1} tính từ 1)")
            print(f"🔢 Giá trị hex      : {value}")
            print(f"🔣 Giá trị unsigned : {uint_val}")
            print(f"💡 Mở file trong VS Code và nhấn Ctrl+G → nhập {line_idx + 1}")
    except FileNotFoundError:
        print(f"❌ Không tìm thấy file: {file_path}")

# KIỂM TRA FILE NÀO THÌ TẮT COMMENT FILE ĐẤY
# =======================
# 💡 Ví dụ gọi kiểm tra:
# =======================

# --- (1) IFM đầu vào ---
# check_hex_value("IFM.hex", b=0, h=2, w=14, c=0, H=56, W=56, C=32)

# --- (2) Weight expand ---
# check_hex_value("Weight_expand.hex", b=0, h=0, w=0, c=12, H=3, W=3, C=32)

# --- (3) Golden output của expand ---
# check_hex_value("Golden_OFM_expand.hex", b=0, h=5, w=20, c=7, H=56, W=56, C=128)

# --- (4) Weight project ---
# check_hex_value("Weight_project.hex", b=0, h=0, w=0, c=99, H=1, W=1, C=128)

# --- (5) Golden output của project ---
check_hex_value("Golden_OFM_project.hex", b=0, h=10, w=10, c=3, H=56, W=56, C=32)

