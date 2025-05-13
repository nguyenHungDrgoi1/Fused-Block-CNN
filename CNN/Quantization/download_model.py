from tensorflow.keras.applications import EfficientNetV2B0

model = EfficientNetV2B0(weights='imagenet', input_shape=(224, 224, 3))
model.save('efficientnetv2b0_imagenet.h5')  # Save tại thư mục hiện tại
