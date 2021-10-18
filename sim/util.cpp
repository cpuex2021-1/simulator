#include "util.hpp"
#include <iostream>
using namespace std;

int getBits(int num, int start, int end, bool sext){
    unsigned int mask = ((1 << (start - end + 1)) - 1) << end;
    int ans = (num & mask) >> end;
    if(sext && ((num >> start) & 1 == 1)){
        int newmask = ((1 << (32 - (start - end + 1))) - 1) << (start - end + 1);
        ans |= newmask;
    }
    return ans;
}

void print_instruction(unsigned int instruction){
    for(int i=31; i>=0; i--){
        cout << ((instruction >> i) & 1);
    }
    cout << endl;
}

void get_filesize(fstream& f, int& fsize){
    f.seekg(0, ios_base::end);
    fsize = f.tellg();
    f.seekg(0, ios_base::beg);
}