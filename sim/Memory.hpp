#pragma once
#include <string>
#include "util.hpp"
#include <iomanip>
#include <iostream>
#include <fstream>
#include <queue>

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

class UART
{
private:
    fstream in;
    fstream out;
    queue<int> inbuf;
public:
    void setup(string input_fname, string output_fname){
        in.open(input_fname);
        out.open(output_fname);

        while(!inbuf.empty()){
            inbuf.pop();
        }

        int code;
        while(in.read((char *) &code, sizeof(unsigned int))){
            inbuf.push(code);
        }
    }

    inline int pop(){
        if(inbuf.empty()){
            throw invalid_argument("No more uart input");
        }
        int res = inbuf.front();
        inbuf.pop();
        return res;
    }

    inline void push(int n){
        out.write(reinterpret_cast<char *>(&n), sizeof(n));
    }
};

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
    UART uart;
public:
    Memory();
    ~Memory();
    inline void write(int index, int data);
    inline int read(int index);

    void setup_uart(string, string);
    void print_memory(string filename);
    void print_cache_summary();
    int read_without_cache(unsigned int index);
    void write_without_cache(unsigned int index, int data);
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
    if(index == 0){
        uart.push(data);
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
    if(index == 0){
        return uart.pop();
    }
    cachehit = false;
    update_cache(index);
    return memory[index];
}
