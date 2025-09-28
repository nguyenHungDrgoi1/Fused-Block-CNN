#ifndef ULTIS_MAKE_QUANT_PARAMS_H_
#define ULTIS_MAKE_QUANT_PARAMS_H_

#include <cstdint>

/**
 * @brief Calculate quantization parameters for TensorFlow Lite operations
 * @param Si Input scale factor
 * @param Sw Weight scale factor  
 * @param So Output scale factor
 * @param M Reference to store quantized multiplier
 * @param shift Reference to store bit shift value
 */
void MakeQuantParams(double Si, double Sw, double So, int32_t& M, int& shift);

#endif // ULTIS_MAKE_QUANT_PARAMS_H_
