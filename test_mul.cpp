#include "tensor/include/mul.h"
#include <iostream>

int main() {
    try {
        std::cout << "Testing MUL function..." << std::endl;
        
        MUL("ops_in/op000_MUL_INPUT0_scales.txt",
            "ops_in/op000_MUL_INPUT1_scales.txt", 
            "ops_in/op000_MUL_OFM_scales.txt",
            "ops_in/op000_MUL_INPUT0_zero_points.txt",
            "ops_in/op000_MUL_INPUT1_zero_points.txt",
            "ops_in/op000_MUL_OFM_zero_points.txt",
            "ops_in/op000_MUL_INPUT0_values(int).txt",
            "ops_in/op000_MUL_INPUT1_values(int).txt",
            "mul_result",
            "enough");
            
        std::cout << "MUL function completed successfully!" << std::endl;
        std::cout << "Check ops_output/mul_result.txt for results" << std::endl;
        
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}
