import numpy as np
from tensorflow.keras.applications import EfficientNetB0
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications.efficientnet import decode_predictions

# 1. Tạo model EfficientNetB0
# Sử dụng trọng số ImageNet (pretrained)
model = EfficientNetB0(
    include_top=True,          # Bao gồm fully-connected layer (top layer)
    weights="imagenet",        # Trọng số pretrained trên ImageNet
    input_tensor=None,         # Không cung cấp input_tensor
    input_shape=None,          # Input shape tự động tính dựa trên ImageNet
    pooling=None,              # Không sử dụng pooling đặc biệt
    classes=1000,              # Mặc định phân loại 1000 lớp ImageNet
    classifier_activation="softmax",  # Kích hoạt cho top layer
)
# 2. Hàm xử lý và chuẩn bị hình ảnh đầu vào
def load_and_preprocess_image(img_path):
    # Load hình ảnh và resize về (224, 224) - Kích thước EfficientNet yêu cầu
    img = image.load_img(img_path, target_size=(224, 224))
    # Chuyển hình ảnh thành array
    img_array = image.img_to_array(img)
    # Thêm batch dimension (1, 224, 224, 3)
    img_array = np.expand_dims(img_array, axis=0)
    return img_array  # EfficientNet đã tích hợp preprocess_input

# 3. Thực hiện inference (Dự đoán)
def predict_image(img_path):
    # Load và preprocess hình ảnh
    img_array = load_and_preprocess_image(img_path)
    # Dự đoán lớp
    predictions = model.predict(img_array)
    # Giải mã kết quả dự đoán
    decoded_predictions = decode_predictions(predictions, top=1)[0]
    return decoded_predictions

# 4. Test với một hình ảnh
img_path = "dog.png"  # Đường dẫn tới ảnh cần kiểm tra
predictions = predict_image(img_path)

# 5. In kết quả dự đoán
for i, (imagenet_id, label, score) in enumerate(predictions):
    print(f"Top {i+1}: {label} ({score:.2f})")
