cmake_minimum_required(VERSION 3.10)
project(TensorProject LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Cho phép #include "tensor/include/mul.h"
include_directories(
    ${CMAKE_SOURCE_DIR}             # để hỗ trợ #include "tensor/include/..."
    ${CMAKE_SOURCE_DIR}/tensor/include
    ${CMAKE_SOURCE_DIR}/ultis/include
)

# Nguồn
set(SRC_FILES
    tensor/src/mul.cpp
    ultis/src/MakeQuantParams.cpp
    ultis/src/ReadFile.cpp
)

# Tạo thư viện
add_library(tensorlib ${SRC_FILES})

# Executable test_mul
add_executable(test_mul test_mul.cpp)
target_link_libraries(test_mul PRIVATE tensorlib)

# Copy thư mục ops_in vào build khi build xong
add_custom_command(TARGET test_mul POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
            ${CMAKE_SOURCE_DIR}/ops_in
            $<TARGET_FILE_DIR:test_mul>/ops_in
)

# tạo ops_output trống trong build
add_custom_command(TARGET test_mul POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory
            $<TARGET_FILE_DIR:test_mul>/ops_output
)

