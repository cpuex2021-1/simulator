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
    int cache_size;
    Cache_elem* cache;
    int *memory;
    int access;
    int hitnum;
    int validnum;
    int replacenum;
public:
    int size;
    Memory(unsigned int size, unsigned int cache_size);
    ~Memory();
    inline void write(int index, int data);
    inline int read(int index);
    void print_memory(string filename);
    void print_cache_summary();
    int read_without_cache(unsigned int index);
    void reset();
};


inline void Memory::write(int index, int data){
    if(index < 0 || index >= size){
        stringstream ss;
        ss << "Memory index out of range (write): " << index;
        throw std::out_of_range(ss.str());
    }
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

inline int Memory::read(int index){
    if(index < 0 || index >= size){
        stringstream ss;
        ss << "Memory index out of range (read): " << index;
        throw std::out_of_range(ss.str());
    }
    access++;
    unsigned int tag = getBits(index, 24, 14);
    unsigned int cindex = getBits(index, 13, 2);
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
    return memory[index];
}
