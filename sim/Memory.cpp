#include "Memory.hpp"

using namespace std;

Memory::Memory(unsigned int size_, unsigned int cache_size_)
:size(size_), cache_size(cache_size_)
{
    cache = new cache_elem[cache_size_ >> 2];
    memory = new int[size >> 2];
}

Memory::~Memory(){
    delete cache;
    delete memory;
}

void Memory::write(unsigned int index, int data){
    memory[index >> 2] = data;
}

int Memory::read(unsigned int index){
    return memory[index >> 2];
}