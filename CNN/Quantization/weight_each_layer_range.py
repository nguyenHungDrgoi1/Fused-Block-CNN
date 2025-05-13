import os
import numpy as np
import matplotlib.pyplot as plt
from tensorflow.keras.models import load_model
from tensorflow.keras.layers import Conv2D, BatchNormalization

# 1. Load model
model = load_model(r"D:/Code_code/verilog_and_systemverilog/Fused_Block/efficientnetv2b0_imagenet.h5")

# 2. Hàm fuse Conv + BN
def fuse_weights(conv_layer, bn_layer):
    W = conv_layer.get_weights()[0]
    if conv_layer.use_bias:
        b = conv_layer.get_weights()[1]
    else:
        b = np.zeros(W.shape[-1])

    gamma = bn_layer.gamma.numpy()
    beta  = bn_layer.beta.numpy()
    mean  = bn_layer.moving_mean.numpy()
    var   = bn_layer.moving_variance.numpy()
    eps   = bn_layer.epsilon

    std   = np.sqrt(var + eps)
    scale = gamma / std

    W_fused = W * scale.reshape((1,1,1,-1))
    b_fused = beta + (b - mean) * scale
    return W_fused, b_fused

# 3. Tạo thư mục lưu plots
out_dir = r"D:/Code_code/verilog_and_systemverilog/Fused_Block/layer_weight_plots"
os.makedirs(out_dir, exist_ok=True)

# 4. Duyệt qua các layer, tạo plot và lưu file
layers = model.layers
counter = 1

for idx, layer in enumerate(layers):
    if not isinstance(layer, Conv2D):
        continue

    # Kiểm tra có BN ngay sau không
    if idx + 1 < len(layers) and isinstance(layers[idx+1], BatchNormalization):
        W_plot, _ = fuse_weights(layer, layers[idx+1])
        suffix = f"fused_{layer.name}_with_{layers[idx+1].name}"
    else:
        W_plot = layer.get_weights()[0]
        suffix = f"raw_{layer.name}"

    all_w = W_plot.flatten()

    # Vẽ scatter
    plt.figure(figsize=(6,4))
    plt.scatter(np.zeros_like(all_w), all_w, alpha=0.3, s=1)
    plt.title(suffix)
    plt.ylabel("Weight value")
    plt.xticks([])
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout()

    # Lưu file với số thứ tự 3 chữ số
    filename = f"{counter:03d}_{suffix}.png"
    plt.savefig(os.path.join(out_dir, filename), dpi=150)
    plt.close()

    print(f"Saved plot: {filename}")
    counter += 1

print("Done! All plots are in:", out_dir)
