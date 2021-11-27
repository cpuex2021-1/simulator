#include "util.hpp"
#include <random>
#include <ctime>
#include <iostream>
using namespace std;

void print_instruction(unsigned int instruction){
    for(int i=31; i>=0; i--){
        cout << ((instruction >> i) & 1);
    }
    cout << endl;
}

void get_filesize(fstream& f, unsigned long long& fsize){
    f.seekg(0, ios_base::end);
    fsize = f.tellg();
    f.seekg(0, ios_base::beg);
}

static bool is_first = true;
vector<string> faces = {
    "(^_^) ",
    "(^o^) ",
    "(^^;) ",
    "(^v^) ",
    "(o_o) "
};

string joking_face(){
    if(is_first){
        is_first = false;
        srand(time(nullptr));
    }
    int i = rand() % faces.size();
        
    return faces[i];
}

void print_instr(unsigned int code){
    for(int i=31; i>=0; i--){
        cout << (code >> i & 1);
    }
    cout << endl;
}

double elapsed(){
    struct timespec tm;
    clock_gettime(CLOCK_REALTIME, &tm);
    return tm.tv_sec + (tm.tv_nsec * 10e-9);
}
