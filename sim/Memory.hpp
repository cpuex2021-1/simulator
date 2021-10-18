#include <string>
using namespace std;

typedef struct cache_elem
{
    bool exist;
    int tag;
}Cache_elem;


class Memory
{
private:
    unsigned int size;
    unsigned int cache_size;
    Cache_elem* cache;
    int *memory;
    bool hit;
public:
    Memory(unsigned int size, unsigned int cache_size);
    ~Memory();
    void write(unsigned int index, int data);
    int read(unsigned int index);
    void print_memory(string filename);
};
