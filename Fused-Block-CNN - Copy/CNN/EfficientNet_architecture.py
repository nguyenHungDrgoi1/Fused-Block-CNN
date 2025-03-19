from tensorflow.keras.applications import EfficientNetB0
from contextlib import redirect_stdout

# Tạo model EfficientNetB0
model = EfficientNetB0(weights="imagenet")

# Đường dẫn tới file lưu kết quả
output_file = "efficientnetb0_architecture.txt"

# Ghi kết quả vào file
with open(output_file, "w") as f:
    with redirect_stdout(f):  # Chuyển hướng toàn bộ stdout vào file
        # Hiển thị thông tin kiến trúc của model
        model.summary()

        # Duyệt qua từng lớp và in thông tin
        for i, layer in enumerate(model.layers):
            print(f"Layer {i}: {layer.name}")
            
            # Lấy input shape nếu tồn tại
            input_shape = getattr(layer, 'input_shape', getattr(layer, 'batch_input_shape', None))
            print(f"  Input shape: {input_shape}")
            
            # Lấy output shape nếu tồn tại
            output_shape = getattr(layer, 'output_shape', None)
            print(f"  Output shape: {output_shape}")
            
            # Số lượng tham số
            print(f"  Number of parameters: {layer.count_params()}")
            print("-" * 50)

print(f"Thông tin kiến trúc EfficientNetB0 đã được lưu vào file: {output_file}")
