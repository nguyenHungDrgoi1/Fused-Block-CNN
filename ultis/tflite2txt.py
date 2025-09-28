# -*- coding: utf-8 -*-
import os, numpy as np, tensorflow as tf

MODEL_PATH = "bnless_int8.tflite"
OUT_ROOT   = "./ops_dump_csv"
os.makedirs(OUT_ROOT, exist_ok=True)
assert os.path.exists(MODEL_PATH), f"Không thấy file: {MODEL_PATH}"

def get_qparams(td):
    if td is None: return None
    qp = td.get("quantization_parameters", {}) or {}
    scales = qp.get("scales", None)
    zps    = qp.get("zero_points", None)
    stuple, ztuple = td.get("quantization", (None, None))

    def to_list_float(x):
        if x is None: return None
        arr = np.array(x).reshape(-1).astype(np.float64)
        return arr.tolist() if arr.size > 0 else None

    def to_list_int(x):
        if x is None: return None
        arr = np.array(x).reshape(-1).astype(np.int64)
        return arr.tolist() if arr.size > 0 else None

    if stuple is not None: s_list = [float(stuple)]
    else:                  s_list = to_list_float(scales)

    if ztuple is not None: zp_list = [int(ztuple)]
    else:                  zp_list = to_list_int(zps)

    return {"scales": s_list, "zero_points": zp_list}

def get_tensor(interpreter, td):
    if td is None: return None
    try:
        return interpreter.get_tensor(int(td["index"]))
    except Exception:
        return None

def write_number_list(path, arr_like, force_int=False):
    if arr_like is None:
        return False  # không tạo file
    arr = np.array(arr_like)
    if arr.size == 0:
        return False  # không tạo file
    arr = arr.ravel(order="C")
    if force_int:
        arr = arr.astype(np.int64, copy=False)
        s = ",".join(str(int(x)) for x in arr.tolist())
    else:
        s = ",".join(str(x) for x in arr.tolist())
    with open(path, "w", encoding="utf-8") as f:
        f.write(s)
    return True

def dump_tensor_triplet(op_dir, tag_prefix, tensor_detail, interpreter):
    q = get_qparams(tensor_detail) if tensor_detail is not None else None
    scales = None if (q is None or q.get("scales") is None) else np.array(q["scales"], dtype=np.float64)
    zps    = None if (q is None or q.get("zero_points") is None) else np.array(q["zero_points"], dtype=np.int64)

    if not write_number_list(os.path.join(op_dir, f"{tag_prefix}_scales.txt"), scales, force_int=False):
        pass  # bỏ qua file rỗng
    if not write_number_list(os.path.join(op_dir, f"{tag_prefix}_zero_points.txt"), zps, force_int=True):
        pass

    arr = get_tensor(interpreter, tensor_detail)
    write_number_list(os.path.join(op_dir, f"{tag_prefix}_values(int).txt"), arr, force_int=True)

# ===== Load & run =====
interpreter = tf.lite.Interpreter(model_path=MODEL_PATH, experimental_preserve_all_tensors=True)
interpreter.allocate_tensors()

for din in interpreter.get_input_details():
    shape, dt = din["shape"], din["dtype"]
    if dt == np.int8:
        interpreter.set_tensor(din["index"], np.zeros(shape, dtype=np.int8))
    elif dt == np.uint8:
        interpreter.set_tensor(din["index"], np.zeros(shape, dtype=np.uint8))
    else:
        interpreter.set_tensor(din["index"], np.zeros(shape, dtype=np.float32))

interpreter.invoke()

tensor_details = interpreter.get_tensor_details()
tensor_by_idx = {int(t["index"]): t for t in tensor_details}
ops = interpreter._get_ops_details()

for op_id, op in enumerate(ops):
    op_name = op.get("op_name", "UNKNOWN")
    up = op_name.upper()
    if up.startswith("DELEGATE") or up.startswith("CUSTOM") or up.startswith("SELECT_"):
        continue

    in_ids  = list(op.get("inputs", []))
    out_ids = list(op.get("outputs", []))

    td0 = tensor_by_idx.get(int(in_ids[0])) if len(in_ids) >= 1 else None
    td1 = tensor_by_idx.get(int(in_ids[1])) if len(in_ids) >= 2 else None
    td2 = tensor_by_idx.get(int(in_ids[2])) if len(in_ids) >= 3 else None
    tdo = tensor_by_idx.get(int(out_ids[0])) if len(out_ids) >= 1 else None

    op_tag = f"op{op_id:03d}_{op_name}"
    op_dir = os.path.join(OUT_ROOT, op_tag)
    os.makedirs(op_dir, exist_ok=True)

    if op_name in ("CONV_2D", "DEPTHWISE_CONV_2D", "FULLY_CONNECTED"):
        dump_tensor_triplet(op_dir, f"{op_tag}_IFM",     td0, interpreter)
        dump_tensor_triplet(op_dir, f"{op_tag}_WEIGHTS", td1, interpreter)
        dump_tensor_triplet(op_dir, f"{op_tag}_BIAS",    td2, interpreter)
        dump_tensor_triplet(op_dir, f"{op_tag}_OFM",     tdo, interpreter)
    else:
        dump_tensor_triplet(op_dir, f"{op_tag}_INPUT0", td0, interpreter)
        dump_tensor_triplet(op_dir, f"{op_tag}_INPUT1", td1, interpreter)
        dump_tensor_triplet(op_dir, f"{op_tag}_BIAS",   td2, interpreter)
        dump_tensor_triplet(op_dir, f"{op_tag}_OFM",    tdo, interpreter)

print("Hoàn tất. Chỉ tạo file có dữ liệu.")
