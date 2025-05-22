import os
import io
import tarfile
import numpy as np
from PIL import Image
import tensorflow as tf
from tensorflow.keras.models import load_model, clone_model
from tensorflow.keras.applications.efficientnet_v2 import preprocess_input
from tqdm import tqdm

# ==== 0) Cấu hình đường dẫn ====
MANUAL_DIR = "/home/tquocanh/Code/CNN/ImageNet_dataset"
MODEL_H5   = "/home/tquocanh/Code/CNN/Fused_Blocked/CNN/Quantization/efficientnetv2b0_imagenet.h5"
VAL_TAR    = os.path.join(MANUAL_DIR, "ILSVRC2012_img_val.tar")
GT_PATH    = os.path.join(MANUAL_DIR, "ILSVRC2012_validation_ground_truth.txt")

# ==== 1) Load model gốc từ file .h5 ====
print("🔧 Loading model gốc từ .h5 …")
model_orig = load_model(MODEL_H5, compile=False)

# ==== 2) Tính fused weights cho Conv2D + BatchNormalization ====
def fuse_weights(conv, bn):
    W = conv.get_weights()[0]
    b = conv.get_weights()[1] if conv.use_bias else np.zeros(conv.filters, dtype=W.dtype)
    gamma = bn.gamma.numpy()
    beta  = bn.beta.numpy()
    mean  = bn.moving_mean.numpy()
    var   = bn.moving_variance.numpy()
    eps   = bn.epsilon
    std   = np.sqrt(var + eps)
    scale = gamma / std
    W_f = W * scale.reshape((1,1,1,-1))
    b_f = beta + (b - mean) * scale
    return W_f, b_f

fused_map = {}
skip_bn   = set()
layers    = model_orig.layers
for i, layer in enumerate(layers[:-1]):
    if isinstance(layer, tf.keras.layers.Conv2D) and \
       isinstance(layers[i+1], tf.keras.layers.BatchNormalization):
        Wf, bf = fuse_weights(layer, layers[i+1])
        fused_map[layer.name] = [Wf, bf]
        skip_bn.add(layers[i+1].name)

# ==== 3) Clone model, bỏ BN đã fuse, thêm bias cho Conv2D fused ====
def clone_fn(layer):
    if layer.name in skip_bn:
        return tf.keras.layers.Activation('linear', name=layer.name + '_skipped')
    if layer.name in fused_map:
        cfg = layer.get_config()
        cfg['use_bias'] = True
        return tf.keras.layers.Conv2D.from_config(cfg)
    return layer.__class__.from_config(layer.get_config())

print("🔄 Tạo và gán weight cho model_fused …")
model_fused = clone_model(model_orig, clone_function=clone_fn)
for layer in model_fused.layers:
    if layer.name in fused_map:
        layer.set_weights(fused_map[layer.name])
    else:
        try:
            orig = model_orig.get_layer(layer.name)
            layer.set_weights(orig.get_weights())
        except ValueError:
            pass

print("✅ model_fused đã sẵn sàng.")

# ==== 4) Mở tar validation và load ground-truth ====
print("📂 Mở tar validation …")
tar = tarfile.open(VAL_TAR, 'r')
gt  = np.loadtxt(GT_PATH, dtype=np.int32) - 1  # chuyển về 0-based

members = [
    m for m in tar.getmembers()
    if m.isfile() and m.name.lower().endswith(".jpeg")
]
members.sort(key=lambda m: os.path.basename(m.name))
assert len(members) == len(gt), f"{len(members)} ảnh vs {len(gt)} nhãn"

# ==== 5) Đánh giá Top-1 bằng batch inference ====
batch_size = 8
num_val    = len(members)
correct    = 0

print(f"🚀 Đang đánh giá trên {num_val} ảnh, batch_size={batch_size} …")
for start in tqdm(range(0, num_val, batch_size)):
    end         = min(start + batch_size, num_val)
    batch_mems  = members[start:end]
    imgs, labels = [], []
    for idx, m in enumerate(batch_mems, start):
        fobj = tar.extractfile(m)
        img  = Image.open(io.BytesIO(fobj.read())) \
                    .convert("RGB") \
                    .resize((224,224), Image.BILINEAR)
        arr  = np.array(img, dtype=np.float32)
        arr  = preprocess_input(arr)
        imgs.append(arr)
        labels.append(gt[idx])
    x     = np.stack(imgs, axis=0)
    preds = model_fused.predict(x, verbose=0)
    top1  = np.argmax(preds, axis=1)
    correct += np.sum(top1 == np.array(labels))

acc = correct / num_val * 100
print(f"\n→ Top-1 Accuracy (fused) trên tập validation: {acc:.2f}%")

tar.close()
