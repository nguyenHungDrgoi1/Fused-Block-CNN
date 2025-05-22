import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import tensorflow as tf

# === 0. CONFIG ===
INT_BITS    = 4          # total integer bits (including sign)
TOTAL_BITS  = 8
FRAC_BITS   = TOTAL_BITS - INT_BITS    # = 4
STRIDE_H    = 2
STRIDE_W    = 2

# === Enable pandas to print every row/column ===
pd.set_option('display.max_rows',    None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width',       None)
pd.set_option('display.max_colwidth', None)

# === 1. Define input & kernel so that output is 112×112×32 ===
batch_size = 1
H, W, Cin  = 224, 224, 3
kh, kw, Cout = 2, 2, 32

# input: [1,224,224,3]
input_tensor = np.random.uniform(-2, 2, (batch_size, H, W, Cin)).astype(np.float32)
# kernel: [2,2,3,32]
kernel       = np.random.uniform(-1, 1, (kh, kw, Cin, Cout)).astype(np.float32)

# === 2. Fixed-point helpers ===
def to_twos_complement(val, total_bits):
    if val < 0:
        val = (1 << total_bits) + val
    return format(val & ((1 << total_bits) - 1), f'0{total_bits}b')

def dfp_quantize(x, int_bits=INT_BITS, total_bits=TOTAL_BITS):
    frac_bits = total_bits - int_bits
    scale     = 1 << frac_bits
    x_int     = np.round(x * scale).astype(np.int32)
    max_val   = (1 << (total_bits - 1)) - 1
    min_val   = - (1 << (total_bits - 1))
    x_clip    = np.clip(x_int, min_val, max_val).astype(np.int8)
    return x_clip, frac_bits

def dfp_multiply(a_q, b_q):
    return int(a_q) * int(b_q)

# === 3. Quantize input & kernel ===
input_q,  input_frac  = dfp_quantize(input_tensor)
kernel_q, kernel_frac = dfp_quantize(kernel)
shift_bits = input_frac + kernel_frac - FRAC_BITS

# === 4. TF Conv2D on quantized floats for reference ===
scale   = 1 << FRAC_BITS
input_qf  = input_q.astype(np.float32) / scale
kernel_qf = kernel_q.astype(np.float32) / scale

conv = tf.keras.layers.Conv2D(
    filters=Cout,
    kernel_size=(kh, kw),
    strides=(STRIDE_H, STRIDE_W),
    padding='valid',
    use_bias=False,
    dtype='float32'
)
_ = conv(tf.convert_to_tensor(input_qf[:1]))  # build
conv.set_weights([kernel_qf])
output_tf = conv(tf.convert_to_tensor(input_qf)).numpy()

# === 5. Print Input Tensor (Float, Q-int, Binary) ===
input_display = []
for b in range(batch_size):
    for i in range(H):
        for j in range(W):
            for c in range(Cin):
                val_f = input_tensor[b,i,j,c]
                val_q = input_q[b,i,j,c]
                bin8  = to_twos_complement(int(val_q), TOTAL_BITS)
                input_display.append({
                    'b': b, 'i': i, 'j': j, 'c': c,
                    'Float':   val_f,
                    'Q-int':   val_q,
                    'Binary8': bin8
                })
df_input = pd.DataFrame(input_display)
print("\n=== INPUT Tensor (all elements) ===")
print(df_input.to_string(index=False))

# === 6. Print Kernel Tensor (Float, Q-int, Binary) ===
kernel_display = []
for u in range(kh):
    for v in range(kw):
        for ci in range(Cin):
            for co in range(Cout):
                val_f = kernel[u,v,ci,co]
                val_q = kernel_q[u,v,ci,co]
                bin8  = to_twos_complement(int(val_q), TOTAL_BITS)
                kernel_display.append({
                    'u':u, 'v':v, 'cin':ci, 'cout':co,
                    'Float':   val_f,
                    'Q-int':   val_q,
                    'Binary8': bin8
                })
df_kernel = pd.DataFrame(kernel_display)
print("\n=== KERNEL Tensor (all elements) ===")
print(df_kernel.to_string(index=False))

# === 7. Manual convolution with stride and single rounding ===
H_out = (H - kh)//STRIDE_H + 1
W_out = (W - kw)//STRIDE_W + 1

y_dfp = np.zeros((batch_size, H_out, W_out, Cout), dtype=np.float32)
ofm_display = []

for b in range(batch_size):
    for i_o in range(H_out):
        for j_o in range(W_out):
            for co in range(Cout):
                acc = 0
                for u in range(kh):
                    for v in range(kw):
                        for ci in range(Cin):
                            i_in = i_o * STRIDE_H + u
                            j_in = j_o * STRIDE_W + v
                            acc += dfp_multiply(
                                input_q[b, i_in, j_in, ci],
                                kernel_q[u, v, ci, co]
                            )
                # signed rounding once
                if shift_bits > 0:
                    half = 1 << (shift_bits - 1)
                    if acc >= 0:
                        acc_r = (acc + half) >> shift_bits
                    else:
                        acc_r = -(((-acc) + half) >> shift_bits)
                else:
                    acc_r = acc << (-shift_bits)
                # clip to 8-bit
                acc_c = np.clip(
                    acc_r,
                    -(1 << (TOTAL_BITS-1)),
                    (1 << (TOTAL_BITS-1))-1
                ).astype(np.int8)
                # float back
                y_dfp[b,i_o,j_o,co] = acc_c / float(scale)

                ofm_display.append({
                    'b': b, 'i': i_o, 'j': j_o, 'co': co,
                    'DFP8_f':    y_dfp[b,i_o,j_o,co],
                    'Bin8':      to_twos_complement(int(acc_c), TOTAL_BITS),
                    'TF_ref':    output_tf[b,i_o,j_o,co]
                })

df_ofm = pd.DataFrame(ofm_display)
print("\n=== OUTPUT Feature Map (all elements) ===")
print(df_ofm.to_string(index=False))

# === 8. Optionally, you can still plot a subset to verify ===
flat_tf  = output_tf.flatten()
flat_dfp = y_dfp.flatten()

plt.figure(figsize=(6,4))
plt.scatter(range(min(1000,len(flat_tf))), flat_tf[:1000], label='TF', s=5)
plt.scatter(range(min(1000,len(flat_dfp))), flat_dfp[:1000], marker='x', label='DFP8', s=5)
plt.title('TF vs Manual DFP8 (first up to 1000 elems)')
plt.legend(); plt.grid(True, linestyle='--', alpha=0.5)
plt.show()
