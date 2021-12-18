#ifndef MEMORY_H_INCLUDED
#define MEMORY_H_INCLUDED
#include <string>
#include <sstream>
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
    inline static vector<uint32_t> inbuf;
    inline static unsigned long long inbufIdx;
    inline static vector<uint32_t> outbuf;
    inline static unsigned long long outbufIdx;
public:
    UART(){
        inbufIdx = 0;
        outbufIdx = 0;
    }
    void setup(string input_fname){
        in.open(input_fname, ios::in);
        inbuf = vector<uint32_t> ();
        outbuf = vector<uint32_t> ();

        inbuf.reserve(16384);
        outbuf.reserve(16384);

        uint32_t code;
        while(in.read((char *) &code, sizeof(uint32_t))){
            inbuf.push_back(code);
        }
    }

    inline static int pop(){
        if(inbufIdx >= inbuf.size()){
            throw invalid_argument("No more uart input");
        }
        int res = inbuf[inbufIdx];
        inbufIdx++;
        return res;
    }

    inline static void push(int n){
        outbuf.push_back(n);
        outbufIdx++;
    }

    inline int getInbufIdx(){
        return inbufIdx;
    }

    inline int getOutbufIdx(){
        return outbufIdx;
    }

    inline int getInbuf(long long index){
        if(index < 0 || index >= (long long) inbuf.size()){
            throw out_of_range("");
        }
        else{
            return inbuf[index];
        }
    }

    inline void setInbuf(long long index, uint32_t data){
        if(index < 0){
            throw out_of_range("");
        }else if(index == (long long)inbuf.size()){
            inbuf.push_back(data);
        }else if(index > (long long)inbuf.size()){
            throw out_of_range("");
        }else{
            inbuf[index] = data;
        }
    }

    inline int getOutbuf(long long index){
        if(index < 0 || index >= (long long)outbufIdx){
            throw out_of_range("");
        }
        else{
            return outbuf[index];
        }
    }

    void revert(){
        if(inbufIdx > 0) inbufIdx--;
        if(outbufIdx > 0) outbufIdx--;
    }
};

class Memory
{
private:
    inline static Cache_elem* cache;
    inline static uint64_t access;
    inline static uint64_t hitnum;
    inline static uint64_t validnum;
    inline static uint64_t replacenum;
    inline static bool cachehit;
public:
    inline static int32_t *memory;
    Memory();
    ~Memory();
    UART uart;
    inline void write(uint32_t index, int32_t data);
    inline int32_t read(uint32_t index);
    static inline void writeJit(uint32_t index, int32_t data);
    static inline int32_t readJit(uint32_t index);

    void setup_uart(string);
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

    inline static uint64_t getMemAddr(uint32_t index){
        return (uint64_t)&memory[index];
    }

    uint32_t getContentSize(){
        return sizeof(memory[0]);
    }

private:
    inline static void update_cache(uint32_t index){
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


inline void Memory::write(uint32_t index, int32_t data){
    if(index >= MEMSIZE){
        stringstream ss;
        ss << "Memory index out of range (write): " << index;
        throw std::out_of_range(ss.str());
    }
    if(index == 0){
        uart.push(data);
        return;
    }
    cachehit = false;
    update_cache(index);
    memory[index] = data;
}

inline int32_t Memory::read(uint32_t index){
    if(index >= MEMSIZE){
        stringstream ss;
        ss << "Memory index out of range (read): " << index;
        throw std::out_of_range(ss.str());
    }
    if(index == 0){
        try{
            return uart.pop();
        }catch(std::exception &e){
            cerr << e.what() << endl;
            return 0;
        }        
    }
    cachehit = false;
    update_cache(index);
    return memory[index];
}

inline void Memory::writeJit(uint32_t index, int32_t data){
    update_cache(index);
    memory[index] = data;    
}

inline int32_t Memory::readJit(uint32_t index){
    update_cache(index);
    return memory[index];
}

#endif