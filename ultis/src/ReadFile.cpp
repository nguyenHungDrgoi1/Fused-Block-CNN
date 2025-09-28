#include "ultis/include/ReadFile.h"
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <algorithm>
#include <cctype>

std::string Trim(const std::string& s) {
    size_t b = 0;
    while (b < s.size() && std::isspace(static_cast<unsigned char>(s[b]))) ++b;
    size_t e = s.size();
    while (e > b && std::isspace(static_cast<unsigned char>(s[e - 1]))) --e;
    return s.substr(b, e - b);
}

bool ReadFileToString(const std::string& path, std::string& out) {
    std::ifstream ifs(path);
    if (!ifs) return false;
    std::ostringstream oss;
    oss << ifs.rdbuf();
    out = oss.str();
    return true;
}

std::vector<std::string> Split(const std::string& s, char delim) {
    std::vector<std::string> tokens;
    std::string token;
    std::stringstream ss(s);
    while (std::getline(ss, token, delim)) {
        token = Trim(token);
        if (!token.empty()) tokens.push_back(token);
    }
    return tokens;
}

static bool ParseFloatLine(const std::string& line, std::vector<float>& out) {
    out.clear();
    if (line.find(',') != std::string::npos) {
        auto parts = Split(line, ',');
        try { for (auto& p : parts) out.push_back(std::stof(p)); }
        catch (...) { return false; }
        return true;
    }
    std::stringstream ss(line);
    float v;
    while (ss >> v) out.push_back(v);
    return !out.empty();
}

static bool ParseIntLine(const std::string& line, std::vector<int32_t>& out) {
    out.clear();
    if (line.find(',') != std::string::npos) {
        auto parts = Split(line, ',');
        try { for (auto& p : parts) out.push_back(static_cast<int32_t>(std::stol(p))); }
        catch (...) { return false; }
        return true;
    }
    std::stringstream ss(line);
    int32_t v;
    while (ss >> v) out.push_back(v);
    return !out.empty();
}

bool ReadFirstLineFloats(const std::string& path, std::vector<float>& out) {
    std::ifstream f(path);
    if (!f) return false;
    std::string line;
    if (!std::getline(f, line)) return false;
    line = Trim(line);
    if (line.empty()) return false;
    return ParseFloatLine(line, out);
}

bool ReadFirstLineInts(const std::string& path, std::vector<int32_t>& out) {
    std::ifstream f(path);
    if (!f) return false;
    std::string line;
    if (!std::getline(f, line)) return false;
    line = Trim(line);
    if (line.empty()) return false;
    return ParseIntLine(line, out);
}

bool ReadAllFloats(const std::string& path, std::vector<float>& out) {
    std::ifstream f(path);
    if (!f) return false;
    std::string line;
    std::vector<float> all;
    while (std::getline(f, line)) {
        line = Trim(line);
        if (line.empty()) continue;
        std::vector<float> tmp;
        if (!ParseFloatLine(line, tmp)) return false;
        all.insert(all.end(), tmp.begin(), tmp.end());
    }
    if (all.empty()) return false;
    out.swap(all);
    return true;
}

bool ReadAllInts(const std::string& path, std::vector<int32_t>& out) {
    std::ifstream f(path);
    if (!f) return false;
    std::string line;
    std::vector<int32_t> all;
    while (std::getline(f, line)) {
        line = Trim(line);
        if (line.empty()) continue;
        std::vector<int32_t> tmp;
        if (!ParseIntLine(line, tmp)) return false;
        all.insert(all.end(), tmp.begin(), tmp.end());
    }
    if (all.empty()) return false;
    out.swap(all);
    return true;
}

std::vector<int> readIntVector(const std::string& path) {
    std::ifstream fin(path);
    if (!fin) throw std::runtime_error("Cannot open file " + path);
    
    std::vector<int> data;
    std::string token;
    while (std::getline(fin, token, ',')) {
        if (!token.empty()) {
            data.push_back(std::stoi(token));
        }
    }
    return data;
}

double readSingleDouble(const std::string& path) {
    std::ifstream fin(path);
    if (!fin) throw std::runtime_error("Cannot open file " + path);
    
    double val;
    fin >> val;
    return val;
}

int readSingleInt(const std::string& path) {
    std::ifstream fin(path);
    if (!fin) throw std::runtime_error("Cannot open file " + path);
    
    int val;
    fin >> val;
    return val;
}