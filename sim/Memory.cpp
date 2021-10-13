#include "Memory.hpp"
#include <iomanip>
#include <fstream>

using namespace std;

Memory::Memory(unsigned int size_, unsigned int cache_size_)
:size(size_), cache_size(cache_size_)
{
    cache = new cache_elem[cache_size_];
    memory = new int[size];
}

Memory::~Memory(){
    delete cache;
    delete memory;
}

void Memory::write(unsigned int index, int data){
    memory[index] = data;
}

int Memory::read(unsigned int index){
    return memory[index];
}

void Memory::print_memory(string filename){
    fstream memres;
    memres.open(filename, ios::out);
    memres << "address   " << "\t";
    for (int i=0; i < 8; i++) memres << setw(8) << hex << i << " ";
    memres << " ";
    for (int i=8; i < 16; i++) memres << setw(8) << hex << i << " ";

    for(int i=0; i<(int)size; i++){
        if(i % 16 == 0){
            memres.fill('0');
            memres << endl << "0x" << setw(8) << hex << i << "\t";
        }else if(i % 16 == 8){
            memres << " ";
        }
        memres.fill('0');
        memres << setw(8) << hex << read(i) << " ";
    }
    memres.close();
}