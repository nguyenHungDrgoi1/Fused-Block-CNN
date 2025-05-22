import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import tensorflow as tf

# === CONFIG  NUMBER OF BITS HERE===
INT_BITS = 2
TOTAL_BITS = 8
FRAC_BITS = TOTAL_BITS - INT_BITS

# === 1. Define input tensors ===
input_tensor = np.random.uniform(-2, 2, (1, 4, 4, 3)).astype(np.float32)
kernel = np.random.randn(2, 2, 3, 2).astype(np.float32)

# === 2. Fixed-point helpers ===
def to_twos_complement(val, total_bits):
    if val < 0:
        val = (1 << total_bits) + val
    return format(val & ((1 << total_bits) - 1), f'0{total_bits}b')

def dfp_quantize(x, int_bits=INT_BITS, total_bits=TOTAL_BITS):
    frac_bits = total_bits - int_bits
    scale = 2 ** frac_bits
    x_int = np.round(x * scale).astype(np.int32)
    max_val = 2**(total_bits - 1) - 1
    min_val = -2**(total_bits - 1)
    x_clip = np.clip(x_int, min_val, max_val).astype(np.int8)
    return x_clip, frac_bits

def dfp_multiply(a_q, b_q, frac_a, frac_b, out_frac, out_bits=8):
    product_q = a_q * b_q
    shift = frac_a + frac_b - out_frac
    result_q = product_q >> shift if shift >= 0 else product_q << (-shift)
    max_val = 2**(out_bits - 1) - 1
    min_val = -2**(out_bits - 1)
    return np.clip(result_q, min_val, max_val)

# === 3. Quantize input & kernel
input_tensor_q, input_frac = dfp_quantize(input_tensor)
kernel_q, kernel_frac = dfp_quantize(kernel)
output_frac = input_frac + kernel_frac

# === 4. TensorFlow Conv2D reference
conv_layer = tf.keras.layers.Conv2D(filters=2, kernel_size=(2, 2), strides=(1, 1),
                                    padding='valid', use_bias=False, dtype='float32')
_ = conv_layer(tf.convert_to_tensor(input_tensor[0:1]))
conv_layer.set_weights([kernel])
output_tf = conv_layer(tf.convert_to_tensor(input_tensor)).numpy()

# === 5. Print Input Tensor (Float + DFP8 + Binary)
input_display = []
for b in range(input_tensor.shape[0]):
    for i in range(input_tensor.shape[1]):
        for j in range(input_tensor.shape[2]):
            for c in range(input_tensor.shape[3]):
                val_f = input_tensor[b, i, j, c]
                val_q = input_tensor_q[b, i, j, c]
                val_bin = to_twos_complement(int(val_q), TOTAL_BITS)
                input_display.append({
                    'b': b, 'h': i, 'w': j, 'c': c,
                    'Input float': val_f,
                    'Input DFP int': val_q,
                    'Binary (DFP8)': val_bin
                })
df_input = pd.DataFrame(input_display)
print("\n=== Input Tensor (Float, DFP8, Binary) ===")
print(df_input.to_string(index=False))

# === 6. Print Kernel Tensor
kernel_display = []
for kh_i in range(kernel.shape[0]):
    for kw_i in range(kernel.shape[1]):
        for c in range(kernel.shape[2]):
            for k in range(kernel.shape[3]):
                val_f = kernel[kh_i, kw_i, c, k]
                val_q = kernel_q[kh_i, kw_i, c, k]
                val_bin = to_twos_complement(int(val_q), TOTAL_BITS)
                kernel_display.append({
                    'kh': kh_i, 'kw': kw_i, 'Cin': c, 'Cout': k,
                    'Kernel float': val_f,
                    'Kernel DFP int': val_q,
                    'Binary (DFP8)': val_bin
                })
df_kernel = pd.DataFrame(kernel_display)
print("\n=== Kernel Tensor (Float, DFP8, Binary) ===")
print(df_kernel.to_string(index=False))

# === 7. Convolution using dfp_multiply
batch, H, W, Cin = input_tensor.shape
kh, kw, _, Cout = kernel.shape
H_out = H - kh + 1
W_out = W - kw + 1

y_dfp = np.zeros((batch, H_out, W_out, Cout), dtype=np.float32)
y_bin = np.empty_like(y_dfp, dtype=object)

for b in range(batch):
    for i in range(H_out):
        for j in range(W_out):
            for k in range(Cout):
                acc = 0
                for u in range(kh):
                    for v in range(kw):
                        for c in range(Cin):
                            a_q = int(input_tensor_q[b, i+u, j+v, c])
                            b_q = int(kernel_q[u, v, c, k])
                            acc += dfp_multiply(a_q, b_q, input_frac, kernel_frac, FRAC_BITS, TOTAL_BITS)

                acc_clipped = np.clip(acc, -128, 127).astype(np.int8)
                y_dfp[b, i, j, k] = acc_clipped / (2 ** FRAC_BITS)
                y_bin[b, i, j, k] = to_twos_complement(int(acc_clipped), TOTAL_BITS)

# === 8. Display OFM
ofm_display = []
for b in range(y_dfp.shape[0]):
    for i in range(y_dfp.shape[1]):
        for j in range(y_dfp.shape[2]):
            for k in range(y_dfp.shape[3]):
                ofm_display.append({
                    'b': b, 'i': i, 'j': j, 'k': k,
                    'DFP8 value': y_dfp[b, i, j, k],
                    'Binary (DFP8)': y_bin[b, i, j, k],
                    'Float32 (TF)': output_tf[b, i, j, k]
                })

df_ofm = pd.DataFrame(ofm_display)
print("\n=== Output Feature Map (DFP8 vs TF Conv2D) ===")
print(df_ofm.to_string(index=False))

# === 9. Plot comparison
flat_tf = output_tf.flatten()
flat_dfp = y_dfp.flatten()

plt.figure(figsize=(6,4))
plt.scatter(range(len(flat_tf)), flat_tf, c='blue', label='TensorFlow Conv2D', s=40)
plt.scatter(range(len(flat_dfp)), flat_dfp, c='red', marker='x', label='DFP8 (manual)', s=40)
plt.title(f'Conv2D Output: TensorFlow vs DFP8 (INT_BITS={INT_BITS})')
plt.xlabel('Index')
plt.ylabel('Value')
plt.legend()
plt.grid(True, linestyle='--', alpha=0.5)
plt.tight_layout()
plt.show()
