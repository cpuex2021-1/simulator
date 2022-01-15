#include "Assembler.hpp"
#include "../lib/DisAssembler.hpp"
#include <iostream>
#include <sstream>

template<typename T>
void add_to_vector(vector<T> &vec, uint64_t index, T value){
    if(vec.size() == index){
        vec.push_back(value);
    }else{
        vec.at(index) = value;
    }
}

void Assembler::read_one_line(int &line_num, int &now_addr, string str){
        #ifdef DEBUG
        cout << "PC:" << now_addr << endl;
        cout << "line:" << line_num << " ";
        Debug_parse(str);
        cout << endl;
        #endif    
        add_to_vector(l_to_p, line_num, now_addr);
        Parse pres(str, now_addr);
        if(pres.type == Parse::instruction){
            for(unsigned int i=0; i < pres.codes.size(); i++){
                add_to_vector<uint32_t>(instructions, now_addr, pres.codes[i]);
                add_to_vector(p_to_l, now_addr, line_num);
                now_addr += 1;
            }
        }else if(pres.type == Parse::none){
        }else if(pres.type == Parse::unresolved){
            unresolved.push(tobeAssembled(now_addr, str));
            for(int i=0; i<pres.size; i++){
                add_to_vector<uint32_t>(instructions, now_addr, 0);
                add_to_vector(p_to_l, now_addr, line_num);
                now_addr += 1;
            }
            
        }else if(pres.type == Parse::label){
            labels[pres.labl] = now_addr;
        }else if(pres.type == Parse::error){
            stringstream err;
            err << "Parsing Error at line " << (line_num) << ": " << str << endl;
            throw parsing_error(err.str());
        }
        add_to_vector(str_instr, line_num, str);
        line_num++;
}

int Assembler::read_asm(string filename){
    fstream ainput;
    ainput.open(filename, ios::in);

    cerr << "Reading " << filename << flush;

    string str;
    int line_num = 0;
    int now_addr = 0;
    
    string nop = "addi zero, zero, 0";

    read_one_line(line_num, now_addr, nop);
    read_one_line(line_num, now_addr, nop);
  
    while(getline(ainput, str)){
        try{  
            read_one_line(line_num, now_addr, str);
        }catch(exception &e){
            stringstream err;
            err << "Parsing Error at line " << (line_num) << ": " << str << "\n\t" << e.what() << endl;
            throw parsing_error(err.str());
        }
    }

    while(!unresolved.empty()){
        auto& unr = unresolved.front();
        Parse pres(unr.str, unr.addr);
        if(pres.type == Parse::instruction){
            #ifdef DEBUG
            pres.print_instr();
            #endif
            for(unsigned int i=0; i < pres.codes.size(); i++){
                instructions.at(unr.addr+i) = pres.codes[i];
            }
        }else{
            stringstream err;
            err << "Label resolution Failed at line " << pc_to_line(unr.addr) << ":\n" << unr.str << endl;
            throw parsing_error(err.str());
        }

        unresolved.pop();
    }

    if(instructions.size() <= 0){
        return -1;
    }

    stringstream luistr;
    luistr << "\tlui ra, " << ((instructions.size()) >> 12) << " #initialize ra (added by assembler)";
    line_num = 0; now_addr = 0;
    read_one_line(line_num, now_addr, luistr.str());

    stringstream addistr;
    addistr << "\taddi ra, ra, " << ((instructions.size()) & ((1 << 12) - 1)) << " #initialize ra (added by assembler)";
    read_one_line(line_num, now_addr, addistr.str());
    
    cout << " complete!" << endl;
    return 0;
    ainput.close();
}

int Assembler::eat_bin(string filename){
    std::ifstream test(filename); 
    if (!test)
    {
        std::cout << "The file \"" << filename << "\" doesn't exist" << std::endl;
        return -1;
    }
    cout << "Eating " << filename << "...";
    
    fstream binput;

    binput.open(filename);

    uint32_t code = 0;
    int now_addr = 0;

    while(binput.read((char *) &code, sizeof(uint32_t))){
        add_to_vector(instructions, now_addr, code);
        add_to_vector(str_instr, now_addr, disassemble(code));
        add_to_vector(p_to_l, now_addr, now_addr);
        add_to_vector(l_to_p, now_addr, now_addr);
        now_addr++;
    }

    binput.close();

    if(instructions.size() <= 0){
        return -1;
    }
    cout << " complete!" << endl;
    return 0;
}

void Assembler::write_to_file(string filename){
    fstream output;
    output.open(filename, ios::binary | ios::out);
    for(uint32_t i=0; i<instructions.size(); i++){
        output.write(reinterpret_cast<char *> (&instructions[i]), sizeof(instructions[i]));
    }
    output.close();
}

int Assembler::line_to_pc(int l){
    if(l < 0) return 0;
    else if(l >= (int)l_to_p.size()){
        return l_to_p.at(l_to_p.size() - 1);
    }else{
        return l_to_p.at(l);
    }
}

int Assembler::pc_to_line(int pc){
    if(pc < 0) return 0;
    else if(pc >= (int)p_to_l.size()){
        return p_to_l.at(p_to_l.size()-1);
    }else{
        return p_to_l.at(pc);
    }
}

void Assembler::full_reset(){
    instructions = vector<uint32_t>();
    str_instr = vector<string>();
    unresolved = queue<tobeAssembled>();
    l_to_p = vector<int>();
    p_to_l = vector<int>();
}