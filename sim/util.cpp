#include "util.hpp"

int getBits(int num, int start, int end){
    unsigned int mask = (1 << (start - end + 1)) << end;
    return num & end;
}