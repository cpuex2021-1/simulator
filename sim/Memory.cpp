#include "Memory.hpp"

using namespace std;

Memory::Memory()
:access(0), hitnum(0), validnum(0), replacenum(0), cachehit(false)
{
    cache = new cache_elem[CACHESIZE];
    for(unsigned int i=0; i<CACHESIZE; i++){
        cache[i].valid = false;
        cache[i].tag = 0;
    }
    memory = new int[MEMSIZE];
}

Memory::~Memory(){
    delete cache;
    delete memory;
}

void Memory::setup_uart(string in){
    uart.setup(in);
}

void Memory::print_memory(string filename){
    fstream memres;
    memres.open(filename, ios::out);
    memres << "address   " << "\t";
    for (int i=0; i < 8; i++) memres << setw(8) << hex << i << " ";
    memres << " ";
    for (int i=8; i < 16; i++) memres << setw(8) << hex << i << " ";

    for(int i=0; i<(int)MEMSIZE; i++){
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
    cout << "\tValid rate   : " << getValidRate() << endl;
    cout << "\tHit rate     : " << getHitRate() << endl;
    cout << "\tReplace rate : " << getReplaceRate() << endl;
}

double Memory::getValidRate(){
    return (double)validnum / (double)CACHESIZE;
}

double Memory::getHitRate(){
    return (double)hitnum / (double)access;
}

double Memory::getReplaceRate(){
    return (double)replacenum / (double)access;
}

int Memory::read_without_cache(unsigned int index){
    return memory[index];
}

void Memory::write_without_cache(unsigned int index, int data){
    memory[index] = data;
}

void Memory::reset(){
    delete cache;
    delete memory;
    cache = new cache_elem[CACHESIZE];
    for(int i=0; i<CACHESIZE; i++){
        cache[i].valid = false;
        cache[i].tag = 0;
    }
    memory = new int[MEMSIZE];    
    access = 0;
    hitnum = 0;
    validnum = 0;
    replacenum = 0;
}