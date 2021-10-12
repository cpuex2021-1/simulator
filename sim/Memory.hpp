#include <vector>
using namespace std;

class Cache_elem{
private:
    int data, tag;
public:
    Cache_elem(int data, int tag);
};

class Memory
{
private:
    unsigned int size;
    unsigned int cache_size;
    vector<Cache_elem> cache;
    vector<int> memory;
public:
    Memory(unsigned int size, unsigned int cache_size);
    void write(unsigned int index, int data);
    int read(unsigned int index);
};
