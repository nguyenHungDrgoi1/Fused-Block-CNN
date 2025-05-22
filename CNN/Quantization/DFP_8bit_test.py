import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import tensorflow as tf

# === CONFIG: NUMBER OF BITS HERE ===
INT_BITS   = 4          # total integer bits (including sign)
TOTAL_BITS = 8
FRAC_BITS  = TOTAL_BITS - INT_BITS  # = 5

# === 1. Define input tensors ===
input_tensor = np.random.uniform(-2, 2, (1, 224, 224, 3)).astype(np.float32)
kernel       = np.random.uniform(-1, 1, (1, 112, 112, 32)).astype(np.float32)

# === 2. Fixed-point helpers ===
def to_twos_complement(val, total_bits):
    if val < 0:
        val = (1 << total_bits) + val
    return format(val & ((1 << total_bits) - 1), f'0{total_bits}b')

def dfp_quantize(x, int_bits=INT_BITS, total_bits=TOTAL_BITS):
    """Quantize inputs/kernels once, with FRAC_BITS = total_bits - int_bits."""
    frac_bits = total_bits - int_bits
    scale     = 1 << frac_bits
    x_int     = np.round(x * scale).astype(np.int32)
    max_val   = (1 << (total_bits - 1)) - 1
    min_val   = - (1 << (total_bits - 1))
    x_clip    = np.clip(x_int, min_val, max_val).astype(np.int8)
    return x_clip, frac_bits

def dfp_multiply(a_q, b_q):
    """Raw integer multiplication (no shifting/rounding here)."""
    return int(a_q) * int(b_q)

# === 3. Quantize input & kernel ===
input_q,  input_frac  = dfp_quantize(input_tensor)
kernel_q, kernel_frac = dfp_quantize(kernel)

# === 4. Run Conv2D in TF on **quantized** floats for reference ===
#    (so that TF and manual DFP8 use the same quantized inputs)
scale = 1 << FRAC_BITS
input_qf  = input_q.astype(np.float32) / scale
kernel_qf = kernel_q.astype(np.float32) / scale

conv = tf.keras.layers.Conv2D(
    filters=2,
    kernel_size=(2,2),
    strides=(1,1),
    padding='valid',
    use_bias=False,
    dtype='float32'
)
_ = conv(tf.convert_to_tensor(input_qf[0:1]))  # build layer
conv.set_weights([kernel_qf])
output_tf = conv(tf.convert_to_tensor(input_qf)).numpy()

# === 5. Print Input & Kernel quantization (optional) ===
# … reuse your DataFrame printing here if desired …

# === 6. Manual convolution + single signed rounding at end ===
batch, H, W, Cin = input_tensor.shape
kh, kw, _, Cout = kernel.shape
H_out = H - kh + 1
W_out = W - kw + 1

# total fractional bits after multiplying input_frac + kernel_frac,
# we need to shift right by this minus FRAC_BITS to return to FRAC_BITS.
shift_bits = input_frac + kernel_frac - FRAC_BITS

y_dfp = np.zeros((batch, H_out, W_out, Cout), dtype=np.float32)
ofm_display = []

for b in range(batch):
    for i in range(H_out):
        for j in range(W_out):
            for k in range(Cout):
                # 1) Accumulate raw integer products
                acc = 0
                for u in range(kh):
                    for v in range(kw):
                        for c in range(Cin):
                            acc += dfp_multiply(
                                input_q[b, i+u, j+v, c],
                                kernel_q[u, v, c, k]
                            )
                # 2) Signed rounding ONE TIME
                if shift_bits > 0:
                    half = 1 << (shift_bits - 1)
                    if acc >= 0:
                        acc_rounded = (acc + half) >> shift_bits
                    else:
                        acc_rounded = -(((-acc) + half) >> shift_bits)
                else:
                    acc_rounded = acc << (-shift_bits)
                # 3) Clip into 8-bit signed two's-complement
                acc_clipped = np.clip(
                    acc_rounded,
                    -(1 << (TOTAL_BITS - 1)),
                    (1 << (TOTAL_BITS - 1)) - 1
                ).astype(np.int8)
                # 4) Convert back to float32 for comparison/plot
                y_dfp[b, i, j, k] = acc_clipped / float(scale)

                # 5) Extract integer-part bits (3-bit signed) from the fixed-point result
                int_part = acc_clipped >> FRAC_BITS
                # Saturate integer part to range [-(2^(INT_BITS-1)) .. 2^(INT_BITS-1)]
                sat_min  = -(1 << (INT_BITS - 1))
                sat_max  =  (1 << (INT_BITS - 1))
                int_part = max(min(int_part, sat_max), sat_min)
                bin3_int = to_twos_complement(int_part, INT_BITS)

                ofm_display.append({
                    'b':            b,
                    'i':            i,
                    'j':            j,
                    'k':            k,
                    'DFP8(float)':  y_dfp[b, i, j, k],
                    'Bin8':         to_twos_complement(int(acc_clipped), TOTAL_BITS),
                    'Int3':         int_part,
                    'Bin3(int)':    bin3_int,
                    'TF on q-floats': output_tf[b, i, j, k]
                })

df_ofm = pd.DataFrame(ofm_display)
print("\n=== Output Feature Map (Manual DFP8 vs TF Conv2D) ===")
print(df_ofm.to_string(index=False))

# === 7. Plot comparison ===
flat_tf  = output_tf.flatten()
flat_dfp = y_dfp.flatten()

plt.figure(figsize=(6,4))
plt.scatter(range(len(flat_tf)),  flat_tf,  label='TF Conv2D (on quantized)', s=40)
plt.scatter(range(len(flat_dfp)), flat_dfp, marker='x', label='Manual DFP8', s=40)
plt.title(f'Conv2D Output: Manual DFP8 vs TF (INT_BITS={INT_BITS})')
plt.xlabel('Index')
plt.ylabel('Value')
plt.legend()
plt.grid(True, linestyle='--', alpha=0.5)
plt.tight_layout()
plt.show()
