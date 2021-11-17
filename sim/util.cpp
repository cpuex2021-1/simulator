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


void setup(vector<int>& instr, vector<string>& str_instr, vector<int>& line_to_pc, vector<int>& pc_to_line, map<std::string, unsigned int>& labels, string filename, bool isasm){
    fstream input;
    input.open(filename, ios::in);
    if(isasm){
        int now_addr = 0;
        int line_num = 1;
        string str;
        while(getline(input, str)){
            Parse pres(str, true, now_addr);
            str_instr.push_back(str);

            if(pres.type == label){
                labels[pres.labl] = now_addr;
                line_num++;
            }else if(pres.type == error){
                cerr << "Parsing Error at line " << line_num << endl;
                exit(1);
            }else if(pres.type == none){
                line_num++;
            }else{
                line_num++;
                now_addr += 1;
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
            line_to_pc.push_back(now_addr);
            Parse pres(str, false, now_addr);
            if(pres.type == instruction){
                #ifdef DEBUG
                pres.print_instr();
                #endif
                instr.push_back(pres.code);
                pc_to_line.push_back(line_num - 1);
                line_num++;
                now_addr += 1;
            }else if(pres.type == none || pres.type == label){
                line_num++;
            }else if(pres.type == error){
                cerr << "Parsing Error at line " << line_num << endl;
                exit(1);
            }
        }
    }else{
        int code;
        input.read((char *) &code, sizeof(unsigned int));
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

double elapsed(){
    struct timespec tm;
    clock_gettime(CLOCK_REALTIME, &tm);
    return tm.tv_sec + (tm.tv_nsec * 10e-9);
}
