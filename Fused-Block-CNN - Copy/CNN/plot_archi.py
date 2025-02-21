from tensorflow.keras.utils import plot_model
from tensorflow.keras.applications import EfficientNetB0

# Tạo mô hình EfficientNetB0
model = EfficientNetB0(weights="imagenet")

# Vẽ sơ đồ kiến trúc và lưu thành file
plot_model(
    model,
    to_file="efficientnetb0_architecture.png",
    show_shapes=True,       # Hiển thị kích thước đầu vào/đầu ra
    show_layer_names=True,  # Hiển thị tên lớp
    dpi=96                  # Độ phân giải
)
