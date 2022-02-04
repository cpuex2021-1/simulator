#ifndef MEMORY_H_INCLUDED
#define MEMORY_H_INCLUDED
#include <string>
#include <sstream>
#include "../lib/util.hpp"
#include <iomanip>
#include <iostream>
#include <fstream>
#include <queue>

#define MEMADDR_BITS 25
#define CACHEINDEX_BITS 12
#define CACHETAG_BITS 11

#define GLOBALSMEMSIZE 512
#define MEMSIZE ((1 << MEMADDR_BITS) + GLOBALSMEMSIZE)
#define MAXMEMINDEX (MEMSIZE - GLOBALSMEMSIZE)
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

        uint32_t code = 0;
        while(in.read((char *) &code, sizeof(char))){
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
        outbuf.push_back(n & ((1 << 8) - 1));
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

    uint32_t getInbufSize(){
        return inbuf.size();
    }

    void revertPush(){
        if(outbufIdx > 0) outbufIdx--;
    }

    void revertPop(){
        if(inbufIdx > 0) inbufIdx--;
    }

    void reset(){
        inbufIdx = 0;
        outbufIdx = 0;
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
    bool pushed;
    bool popped;
    int32_t latest_write_index;
    int32_t latest_read_index;
public:
    inline static int32_t *memory;
    Memory();
    ~Memory();
    UART uart;
    inline void write(int32_t index, int32_t data);
    inline int32_t read(int32_t index);
    static inline void writeJit(int32_t index, int32_t data);
    static inline int32_t readJit(int32_t index);

    void setup_uart(string);
    void print_memory(string filename);
    void print_cache_summary();
    uint64_t totalstall();
    int read_without_cache(int index);
    void write_without_cache(int index, int data);
    void reset();
    double getValidRate();
    double getHitRate();
    double getReplaceRate();
    inline bool checkCacheHit(){
        return cachehit;
    }

    inline static uint64_t getMemAddr(int32_t index){
        index += GLOBALSMEMSIZE;
        return (uint64_t)&memory[index];
    }

    uint32_t getContentSize(){
        return sizeof(memory[0]);
    }

    int32_t getLatestReadIndex(){
        return latest_read_index;
    }

    int32_t getLatestWriteIndex(){
        return latest_write_index;
    }

    void setLatestWriteIndex(uint32_t i){
        latest_write_index = i;
    }

    void setLatestReadIndex(uint32_t i){
        latest_read_index = i;
    }

private:
    inline static void update_cache(uint32_t index){
        if(index <= GLOBALSMEMSIZE){
            access++;
            hitnum++;
            return;
        }
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


inline void Memory::write(int32_t index, int32_t data){
    pushed = false;
    if(index == 0){
        pushed = true;
        return uart.push(data);
    }
    index += GLOBALSMEMSIZE;
    if(index >= MEMSIZE){
        stringstream ss;
        ss << "Memory index out of range (write): " << (index - GLOBALSMEMSIZE);
        throw std::out_of_range(ss.str());
    }
    cachehit = false;
    update_cache(index);
    latest_write_index = index;
    memory[index] = data;
}

inline int32_t Memory::read(int32_t index){
    popped = false;
    if(index == 0){
        popped = true;
        return uart.pop();        
    }
    index += GLOBALSMEMSIZE;
    if(index >= MEMSIZE){
        stringstream ss;
        ss << "Memory index out of range (read): " << (index - GLOBALSMEMSIZE);
        throw std::out_of_range(ss.str());
    }
    cachehit = false;
    update_cache(index);
    latest_read_index = index;
    return memory[index];
}

inline void Memory::writeJit(int32_t index, int32_t data){
    index += GLOBALSMEMSIZE;
    update_cache(index);
    memory[index] = data;    
}

inline int32_t Memory::readJit(int32_t index){
    index += GLOBALSMEMSIZE;
    update_cache(index);
    return memory[index];
}

#endif
