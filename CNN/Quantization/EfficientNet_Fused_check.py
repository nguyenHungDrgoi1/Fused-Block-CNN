import os
import numpy as np
import tensorflow as tf
import tensorflow_datasets as tfds
from tensorflow.keras.models import load_model
from tensorflow.keras.applications.efficientnet_v2 import preprocess_input

# 1) Load Keras model gốc (không compile)
model_path = "/home/tquocanh/Code/CNN/Fused_Blocked/CNN/Quantization/efficientnetv2b0_imagenet.h5"
model = load_model(model_path, compile=False)
print("✅ Loaded Keras model.")

# 2) Chuyển sang TFLite với BN folding (Optimize.DEFAULT)
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()
tflite_path = os.path.join(os.path.dirname(model_path), "efficientnetv2b0_fused.tflite")
with open(tflite_path, "wb") as f:
    f.write(tflite_model)
print(f"✅ TFLite model (fused) saved to: {tflite_path}")

# 3) Khởi tạo TFLite Interpreter
interpreter = tf.lite.Interpreter(model_path=tflite_path)
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()[0]
output_details = interpreter.get_output_details()[0]

# 4) Load ImageNetV2 từ TFDS
print("📥 Loading ImageNetV2...")
ds = tfds.load("imagenet_v2", split="test", as_supervised=True)
ds = ds.map(lambda x, y: (tf.image.resize(x, (224, 224)), y))
ds = ds.map(lambda x, y: (preprocess_input(x), y))
ds = ds.batch(1)  # batch 1 để dễ chạy trong TFLite
ds = ds.prefetch(tf.data.AUTOTUNE)

# 5) Evaluate Top-1 / Top-5 Accuracy
def evaluate_tflite(ds, interpreter, input_details, output_details):
    top1, top5 = 0, 0
    total = 0
    for x, y in ds:
        # chuẩn hoá đầu vào cho interpreter
        inp = x.numpy().astype(input_details["dtype"])
        interpreter.set_tensor(input_details["index"], inp)
        interpreter.invoke()
        out = interpreter.get_tensor(output_details["index"])[0]
        # top-5 indices
        top5_idx = np.argsort(out)[-5:][::-1]
        gt = int(y.numpy())
        if gt == top5_idx[0]:
            top1 += 1
        if gt in top5_idx:
            top5 += 1
        total += 1
        if total % 1000 == 0:
            print(f"Processed {total} images...")
    return top1/total, top5/total

print("🚀 Evaluating fused (TFLite) model on ImageNetV2...")
t1, t5 = evaluate_tflite(ds, interpreter, input_details, output_details)
print(f"\n✅ ImageNetV2 TFLite-Fused Top-1 Acc: {t1:.4f}")
print(f"✅ ImageNetV2 TFLite-Fused Top-5 Acc: {t5:.4f}")
