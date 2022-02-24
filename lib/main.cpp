#include "DisAssembler.hpp"
#include <string>
#include <fstream>
#include <iostream>
using namespace std;

int main(int argc, char* argv[]){
    string filename(argv[1]);
    std::ifstream test(filename); 
    if (!test)
    {
        std::cout << "[ERROR] The file \"" << filename << "\" doesn't exist" << std::endl;
        return -1;
    }

    fstream input;

    input.open(filename, ios::in);

    int code;
    int now_addr = 0;
    int slot = 0;

    while(input.read((char*) &code, sizeof(int)))
    {
        cout << (now_addr) << ": ";
        cout << disassemble(code) << endl;
        if(slot == 3) now_addr++;
        slot = (slot + 1) % 4;
    }

    input.close();
}