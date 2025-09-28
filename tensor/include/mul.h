#ifndef TENSOR_MUL_H_
#define TENSOR_MUL_H_

#include <string>

/**
 * @brief Performs quantized element-wise multiplication
 * @param Si_address Path to input0 scale file
 * @param Sw_address Path to input1 scale file  
 * @param So_address Path to output scale file
 * @param Zi_address Path to input0 zero point file
 * @param Zw_address Path to input1 zero point file
 * @param Zo_address Path to output zero point file
 * @param qin0_address Path to input0 values file
 * @param qin1_address Path to input1 values file
 * @param output_name Output file name (without extension)
 * @param mode "one" or "enough" - broadcasting mode
 */
void MUL(const std::string& Si_address, const std::string& Sw_address, const std::string& So_address,
         const std::string& Zi_address, const std::string& Zw_address, const std::string& Zo_address,
         const std::string& qin0_address, const std::string& qin1_address, 
         const std::string& output_name, const std::string& mode);

#endif // TENSOR_MUL_H_
