#include "ultis/include/MakeQuantParams.h"
#include <cmath>

static inline void QuantizeMultiplier_TFLite(double double_multiplier,
                                             int32_t* quantized_multiplier,
                                             int* shift) {
  if (double_multiplier == 0.0) {
    *quantized_multiplier = 0;
    *shift = 0;
    return;
  }
  int s;
  const double q = std::frexp(double_multiplier, &s);
  long long q_fixed = llround(q * (1ll << 31));

  if (q_fixed == (1ll << 31)) {
    q_fixed >>= 1;
    ++s;
  }
  *quantized_multiplier = static_cast<int32_t>(q_fixed);
  *shift = s;
}

void MakeQuantParams(double Si, double Sw, double So, int32_t& M, int& shift) {
  const double real_M = (Si * Sw) / So;
  QuantizeMultiplier_TFLite(real_M, &M, &shift);
}