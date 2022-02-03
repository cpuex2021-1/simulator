#include "Instructions.hpp"
using namespace std;

map<string, uint32_t> regs = {
    {"zero", 0},
    {"ra", 1},
    {"sp", 2},
    {"hp", 3},
    {"cl", 4},
    {"swp", 5},
    {"a0", 6},
    {"a1", 7},
    {"a2", 8},
    {"a3", 9},
    {"a4", 10},
    {"a5", 11},
    {"a6", 12},
    {"a7", 13},
    {"a8", 14},
    {"a9", 15},
    {"a10", 16},
    {"a11", 17},
    {"a12", 18},
    {"a13", 19},
    {"a14", 20},
    {"a15", 21},
    {"a16", 22},
    {"a17", 23},
    {"a18", 24},
    {"a19", 25},
    {"a20", 26},
    {"a21", 27},
    {"a22", 28},
    {"r0", 29},
    {"r1", 30},
    {"r2", 31},
    {"fzero", 32},
    {"fsw", 33},
    {"f0", 34},
    {"f1", 35},
    {"f2", 36},
    {"f3", 37},
    {"f4", 38},
    {"f5", 39},
    {"f6", 40},
    {"f7", 41},
    {"f8", 42},
    {"f9", 43},
    {"f10", 44},
    {"f11", 45},
    {"f12", 46},
    {"f13", 47},
    {"f14", 48},
    {"f15", 49},
    {"f16", 50},
    {"f17", 51},
    {"f18", 52},
    {"f19", 53},
    {"f20", 54},
    {"f21", 55},
    {"f22", 56},
    {"f23", 57},
    {"f24", 58},
    {"f25", 59},
    {"f26", 60},
    {"fr0", 61},
    {"fr1", 62},
    {"fr2", 63}    
};
map<string, uint32_t> labels;