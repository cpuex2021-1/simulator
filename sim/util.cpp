#include "util.hpp"
#include <random>
#include <ctime>
#include <iostream>
using namespace std;

int getBits(int num, int start, int end){
    unsigned int mask = ((1 << (start - end + 1)) - 1);
    int ans = (num >> end) & mask;
    return ans;
}

int getSextBits(int num, int start, int end){
    unsigned int mask = ((1 << (start - end + 1)) - 1);
    int ans = (num >> end) & mask;
    if(((num >> start) & 1) == 1){
        int newmask = ((1 << (32 - (start - end + 1))) - 1) << (start - end + 1);
        ans |= newmask;
    }
    return ans;
}

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


void setup(vector<int>& instr, map<std::string, unsigned int>& labels, string filename, bool isasm){
    fstream input;
    input.open(filename, ios::in);
    if(isasm){
        int now_addr = 0;
        int line_num = 1;
        string str;
        while(getline(input, str)){
            Parse pres(str, true, now_addr);
            if(pres.type == label){
                labels[pres.labl] = now_addr;
                line_num++;
            }else if(pres.type == error){
                cerr << "Parsing Error at line " << line_num << endl;
                exit(1);
            }else{
                line_num++;
                now_addr += 0x4;
            }
        }
        input.close();
        input.open(filename, ios::in);
        line_num = 1;
        now_addr = 0;

        while(getline(input, str)){
            #ifdef DEBUG
            cout << "line:" << line_num << " ";
            Debug_parse(str);
            #endif

            Parse pres(str, false, now_addr);
            if(pres.type == instruction){
                #ifdef DEBUG
                pres.print_instr();
                #endif
                instr.push_back(pres.code);
                line_num++;
                now_addr += 0x4;
            }else if(pres.type == none || pres.type == label){
                line_num++;
            }else if(pres.type == error){
                cerr << "Parsing Error at line " << line_num << endl;
                exit(1);
            }
        }
    }else{
        int code;
        while(input.read((char *) &code, sizeof(unsigned int))){
            instr.push_back(code);
        }
    }
    input.close();
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