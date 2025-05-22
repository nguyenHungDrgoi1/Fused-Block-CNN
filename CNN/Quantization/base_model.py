import os
import numpy as np
import tensorflow as tf
import tensorflow_datasets as tfds
from tensorflow.keras.applications import EfficientNetV2B0
from tensorflow.keras.applications.efficientnet_v2 import preprocess_input
from tensorflow_datasets import download
from tqdm import tqdm

# 0) Chỉnh lại đường dẫn này cho đúng chỗ bạn để tar_validation
manual_dir = r"D:\Code_code\verilog_and_systemverilog\Fused_Block"

# 1) Cho TFDS biết chúng ta đã có sẵn file .tar validation
download_config = download.DownloadConfig(manual_dir=manual_dir)

# 2) Tạo builder và prepare dataset (nó sẽ unpack từ manual_dir)
builder = tfds.builder("imagenet2012")
builder.download_and_prepare(download_config=download_config)

# 3) Lấy số ảnh validation
num_val = builder.info.splits["validation"].num_examples
print(f"Found {num_val} validation images in ImageNet2012")

# 4) Tạo pipeline: resize → preprocess → batch
ds = builder.as_dataset(split="validation", as_supervised=True)
ds = ds.map(lambda img, lbl: (tf.image.resize(img, (224,224)), lbl),U
            num_parallel_calls=tf.data.AUTOTUNE)
ds = ds.map(lambda img, lbl: (preprocess_input(img), lbl),
            num_parallel_calls=tf.data.AUTOTUNE)
ds = ds.batch(1).prefetch(tf.data.AUTOTUNE)

# 5) Load model EfficientNetV2B0 (include_top=True để có 1000 classes)
model = EfficientNetV2B0(weights="imagenet", include_top=True,
                         input_shape=(224,224,3))

# 6) Chạy inference và đếm đúng/sai
correct = 0
for img, lbl in tqdm(ds, total=num_val, desc="Inference"):
    preds = model.predict(img, verbose=0)
    if np.argmax(preds, axis=1)[0] == lbl.numpy()[0]:
        correct += 1

# 7) In kết quả
acc = correct / num_val * 100
print(f"\nTop-1 Accuracy on ImageNet2012 validation: {acc:.2f}%")