#include "util.hpp"
#include <iostream>
using namespace std;

int getBits(int num, int start, int end){
    unsigned int mask = (1 << (start - end + 1)) << end;
    return num & mask;
}

void print_instruction(unsigned int instruction){
    for(int i=31; i>=0; i--){
        cout << (instruction >> i);
    }
    cout << endl;
}