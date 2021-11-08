#include "Memory.hpp"

using namespace std;

Memory::Memory(unsigned int size_, unsigned int cache_size_)
:size(size_), cache_size(cache_size_), access(0), hitnum(0), validnum(0), replacenum(0)
{
    cache = new cache_elem[cache_size_];
    for(unsigned int i=0; i<cache_size_; i++){
        cache[i].valid = false;
        cache[i].tag = 0;
    }
    memory = new int[size];
}

Memory::~Memory(){
    delete cache;
    delete memory;
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
        memres << setw(8) << hex << memory[i] << " ";
    }
    memres.close();
}

void Memory::print_cache_summary(){
    cout << "Cache summary" << endl;
    cout << "\tValid rate   : " << (double)validnum / (double)cache_size << endl;
    cout << "\tHit rate     : " << (double)hitnum / (double)access << endl;
    cout << "\tReplace rate : " << (double)replacenum / (double)access << endl;
}

int Memory::read_without_cache(unsigned int index){
    return memory[index];
}

void Memory::reset(){
    delete cache;
    delete memory;
    cache = new cache_elem[cache_size];
    for(int i=0; i<cache_size; i++){
        cache[i].valid = false;
        cache[i].tag = 0;
    }
    memory = new int[size];    
    access = 0;
    hitnum = 0;
    validnum = 0;
    replacenum = 0;
}