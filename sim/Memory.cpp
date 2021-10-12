#include "Memory.hpp"

using namespace std;

Cache_elem::Cache_elem(int data_, int tag_)
:data(data_), tag(tag_)
{}

Memory::Memory(unsigned int size_, unsigned int cache_size_)
:size(size_), cache_size(cache_size_)
{
    cache.reserve(cache_size);
    memory.reserve(size);
}

void Memory::write(unsigned int index, int data){
    memory[index] = data;
}

int Memory::read(unsigned int index){
    return memory[index];
}