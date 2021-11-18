#pragma once
#include <string>
#include "util.hpp"
#include <iomanip>
#include <iostream>
#include <fstream>

#define MEMADDR_BITS 25
#define CACHEINDEX_BITS 12
#define CACHETAG_BITS 11

#define MEMSIZE (1 << MEMADDR_BITS)
#define CACHESIZE (1 << CACHEINDEX_BITS)

using namespace std;

typedef struct cache_elem
{
    bool valid;
    unsigned int tag;
}Cache_elem;


class Memory
{
private:
    Cache_elem* cache;
    int *memory;
    int access;
    int hitnum;
    int validnum;
    int replacenum;
    bool cachehit;
public:
    Memory();
    ~Memory();
    inline void write(int index, int data);
    inline int read(int index);
    void print_memory(string filename);
    void print_cache_summary();
    int read_without_cache(unsigned int index);
    void reset();
    double getValidRate();
    double getHitRate();
    double getReplaceRate();
    inline bool checkCacheHit(){
        return cachehit;
    }

private:
    inline void update_cache(int index){
        unsigned int tag = getBits(index, MEMADDR_BITS - 1, MEMADDR_BITS - CACHETAG_BITS);
        unsigned int cindex = getBits(index, MEMADDR_BITS - CACHETAG_BITS - 1, MEMADDR_BITS - CACHETAG_BITS - CACHEINDEX_BITS);
        access++;

        if(!cache[cindex].valid){
            validnum++;
            cache[cindex].tag = tag;
            cache[cindex].valid = true;
        }
        else if(tag == cache[cindex].tag){
            cachehit = true;
            hitnum++;
        }else{
            replacenum++;
            cache[cindex].tag = tag;
        }
    }
};


inline void Memory::write(int index, int data){
    if(index < 0 || index >= MEMSIZE){
        stringstream ss;
        ss << "Memory index out of range (write): " << index;
        throw std::out_of_range(ss.str());
    }
    cachehit = false;
    update_cache(index);
    memory[index] = data;
}

inline int Memory::read(int index){
    if(index < 0 || index >= MEMSIZE){
        stringstream ss;
        ss << "Memory index out of range (read): " << index;
        throw std::out_of_range(ss.str());
    }
    cachehit = false;
    update_cache(index);
    return memory[index];
}
