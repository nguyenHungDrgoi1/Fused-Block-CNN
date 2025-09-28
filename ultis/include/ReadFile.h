#ifndef ULTIS_READ_FILE_H_
#define ULTIS_READ_FILE_H_

#include <vector>
#include <string>

// Đọc vector các số nguyên từ file (phân tách bằng dấu phẩy)
std::vector<int> readIntVector(const std::string& path);

// Đọc một số thực từ file
double readSingleDouble(const std::string& path);

// Đọc một số nguyên từ file
int readSingleInt(const std::string& path);

#endif // ULTIS_READ_FILE_H_
