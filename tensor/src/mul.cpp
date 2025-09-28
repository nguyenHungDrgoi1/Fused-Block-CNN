#include "tensor/include/mul.h"
#include "ultis/include/MakeQuantParams.h"
#include "ultis/include/ReadFile.h"
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cstdint>
#include <stdexcept>
#include <algorithm>
#include <filesystem>

// TFLite-style quantized multiplier implementation
int32_t MultiplyByQuantizedMultiplier(int32_t x, int32_t quantized_multiplier, int shift) {
    int left_shift  = shift > 0 ? shift : 0;
    int right_shift = shift > 0 ? 0 : -shift;

    int64_t shifted = static_cast<int64_t>(x) * (1ll << left_shift);
    int64_t prod = shifted * quantized_multiplier;
    int64_t nudge = (prod >= 0) ? (1ll << 30) : -(1ll << 30);
    int32_t high = static_cast<int32_t>((prod + nudge) >> 31);

    if (right_shift != 0) {
        int32_t mask = (1 << right_shift) - 1;
        int32_t remainder = high & mask;
        int32_t threshold = (mask >> 1) + ((high < 0) ? 1 : 0);
        high = (high >> right_shift) + (remainder > threshold);
    }
    return high;
}

void MUL(const std::string& Si_address, const std::string& Sw_address, const std::string& So_address,
         const std::string& Zi_address, const std::string& Zw_address, const std::string& Zo_address,
         const std::string& qin0_address, const std::string& qin1_address, 
         const std::string& output_name, const std::string& mode) {
    
    try {
        // Read scale and zero-point parameters
        double Si = readSingleDouble(Si_address);
        double Sw = readSingleDouble(Sw_address);
        double So = readSingleDouble(So_address);

        int Zi = readSingleInt(Zi_address);
        int Zw = readSingleInt(Zw_address);
        int Zo = readSingleInt(Zo_address);

        // Read input values
        auto qin0 = readIntVector(qin0_address);
        auto qin1 = readIntVector(qin1_address);

        // Validate inputs based on mode
        if (mode == "enough" && qin0.size() != qin1.size()) {
            throw std::runtime_error("Input sizes must match in 'enough' mode");
        }
        if (mode == "one" && qin1.size() != 1) {
            throw std::runtime_error("Input1 must have exactly one value in 'one' mode");
        }
        if (mode != "one" && mode != "enough") {
            throw std::runtime_error("Invalid mode: must be 'one' or 'enough'");
        }

        // Calculate quantization parameters
        int32_t M0; 
        int shift;
        MakeQuantParams(Si, Sw, So, M0, shift);

        // Perform element-wise multiplication
        std::vector<int> ofm;
        ofm.reserve(qin0.size());
        
        for (size_t i = 0; i < qin0.size(); i++) {
            int32_t acc;
            if (mode == "one") {
                acc = (qin0[i] - Zi) * (qin1[0] - Zw);
            } else { // mode == "enough"
                acc = (qin0[i] - Zi) * (qin1[i] - Zw);
            }
            
            int32_t scaled = MultiplyByQuantizedMultiplier(acc, M0, shift);
            int32_t q_pre = scaled + Zo;
            ofm.push_back(q_pre);
        }

        // Create output directory if it doesn't exist
        std::filesystem::create_directories("ops_output");
        
        // Write results to output file
        std::ofstream fout("ops_output/" + output_name + ".txt");
        if (!fout) {
            throw std::runtime_error("Cannot create output file");
        }
        
        for (size_t i = 0; i < ofm.size(); i++) {
            fout << ofm[i];
            if (i + 1 < ofm.size()) fout << ",";
        }
        fout.close();
        
    } catch (const std::exception& e) {
        std::cout << "Error in " << output_name << " layer: " << e.what() << std::endl;
    }
}



