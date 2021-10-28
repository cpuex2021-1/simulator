#pragma once
#include <string>
#include "util.hpp"
#include <iomanip>
#include <iostream>
#include <fstream>

using namespace std;

typedef struct cache_elem
{
    bool valid;
    unsigned int tag;
}Cache_elem;


class Memory
{
private:
    unsigned int size;
    unsigned int cache_size;
    Cache_elem* cache;
    int *memory;
    int access;
    int hitnum;
    int validnum;
    int replacenum;
public:
    Memory(unsigned int size, unsigned int cache_size);
    ~Memory();
    inline void write(unsigned int index, int data);
    int read(unsigned int index);
    void print_memory(string filename);
    void print_cache_summary();
    int read_without_cache(unsigned int index);
};


inline void Memory::write(unsigned int index, int data){
    unsigned int tag = getBits(index, 24, 14);
    unsigned int cindex = getBits(index, 13, 2);
    access++;

    if(!cache[cindex].valid){
        validnum++;
        cache[cindex].tag = tag;
        cache[cindex].valid = true;
    }
    else if(tag == cache[cindex].tag){
        hitnum++;
    }else{
        replacenum++;
        cache[cindex].tag = tag;
    }
    memory[index] = data;
}