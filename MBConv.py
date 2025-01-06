import tensorflow as tf
from tensorflow.keras import layers, Model

# DepthWiseSeparableConv Implementation
class DepthWiseSeparableConv(layers.Layer):
    def __init__(self, in_features, out_features):
        super(DepthWiseSeparableConv, self).__init__()
        self.depthwise = layers.DepthwiseConv2D(kernel_size=3, padding="same", depth_multiplier=1)
        self.pointwise = layers.Conv2D(out_features, kernel_size=1, padding="same")

    def call(self, inputs):
        x = self.depthwise(inputs)
        x = self.pointwise(x)
        return x

# MBConv Implementation
class MBConv(layers.Layer):
    def __init__(self, in_features, out_features, expansion=4, use_se=False):
        super(MBConv, self).__init__()
        self.residual = in_features == out_features
        expanded_features = in_features * expansion
        
        self.expand_conv = layers.Conv2D(expanded_features, kernel_size=1, padding="same", activation="relu")
        self.depthwise_conv = layers.DepthwiseConv2D(kernel_size=3, padding="same", activation="relu")
        self.project_conv = layers.Conv2D(out_features, kernel_size=1, padding="same")
        self.relu = layers.ReLU()
        self.use_se = use_se
        
        if self.use_se:
            self.se = SqueezeExcitation(expanded_features)  # Define SE block separately if required

    def call(self, inputs):
        x = self.expand_conv(inputs)
        x = self.depthwise_conv(x)
        if self.use_se:
            x = self.se(x)
        x = self.project_conv(x)
        
        if self.residual:
            x = layers.add([x, inputs])
        x = self.relu(x)
        return x

# Example Usage
inputs = tf.keras.Input(shape=(224, 224, 32))  # Example input shape (height, width, channels)
x = DepthWiseSeparableConv(32, 64)(inputs)
x = MBConv(32, 64)(x)
model = Model(inputs, x)

model.summary()
