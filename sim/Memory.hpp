#include <string>
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
    void write(unsigned int index, int data);
    int read(unsigned int index);
    void print_memory(string filename);
    void print_cache_summary();
    int read_without_cache(unsigned int index);
};
