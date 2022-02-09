#include "Reader.hpp"
#include "../lib/DisAssembler.hpp"
#include <iostream>
#include <sstream>

template<typename T>
void add_to_vector(vector<T> &vec, uint64_t index, T value){
    if(vec.size() == index){
        vec.emplace_back(value);
    }else{
        vec.at(index) = value;
    }
}

vector<int> Reader::l_to_p;
vector<int> Reader::p_to_l;
vector<string> Reader::str_instr;


Reader::Reader()
:hasDebuggingInfo(false), labellist(0)
{}

int32_t readerLineToRealLine(int32_t line_num){
    return (line_num + 1) / VLIW_SIZE;
}

void Reader::read_one_line(int32_t &line_num, int32_t &now_addr, string str, int8_t &slot){
        #ifdef DEBUG
        cout << "PC:" << now_addr << endl;
        cout << "line:" << line_num << " ";
        Debug_parse(str);
        cout << endl;
        #endif
        
        add_to_vector(l_to_p, line_num, now_addr);
        Parse pres(str, now_addr);
        if(pres.type == Parse::instruction){
            if(!checkSlotPolicy(slot, pres.codetype)){
                stringstream err;
                err << "[ERROR] VLIW slot policy violation: ";
                err << slotTypeName[pres.codetype] << " instruction is not allowed to fit in slot " << (slot + 1);
                throw vliw_slot_policy_violation(err.str());
            }
            add_to_vector<uint32_t>(instructions, now_addr*VLIW_SIZE+slot, pres.code);
            wrt[slot] = pres.writetoreg;

            for(int i=0; i<slot; i++){
                if(wrt[i] == pres.writetoreg && pres.writetoreg != pres.reg_dfl){
                    cerr << "[WARNING] Line: " << readerLineToRealLine(line_num) << " Same destination register " << regName.at(pres.writetoreg) << \
                     " used in slot " << (i+1) << " and slot " << (slot + 1) << endl; 
                }
            }

            if(slot == 0){
                add_to_vector(p_to_l, now_addr, line_num);
            }
            if(slot == VLIW_SIZE - 1){
                writetoRegs.emplace_back(wrt);
                wrt = vector<int8_t>(4, -1);
                now_addr++;
            }
            slot = (slot + 1) % VLIW_SIZE;
        }else if(pres.type == Parse::none){
        }else if(pres.type == Parse::unresolved){
            unresolved.push(tobeAssembled(now_addr, str, slot));
            add_to_vector<uint32_t>(instructions, now_addr*VLIW_SIZE+slot, 0);
            if(slot == 0){
                add_to_vector(p_to_l, now_addr, line_num);
            }
            if(slot == VLIW_SIZE - 1){
                writetoRegs.emplace_back(wrt);
                wrt = vector<int8_t>(4, -1);
                now_addr++;
            }
            slot = (slot + 1) % VLIW_SIZE;
        }else if(pres.type == Parse::label){
            if(slot > 0){
                stringstream err;
                err << "[ERROR] Instructions not aligned properly for VLIW";
                throw vliw_not_alingned(err.str());
            }
            labels[pres.labl] = now_addr;
            pcandlabel linfo(now_addr, pres.labl);
            labellist.emplace_back(linfo);
        }else if(pres.type == Parse::error){
            stringstream err;
            err << "[ERROR] Syntax Error at line " << readerLineToRealLine(line_num) << ": " << str << endl;
            throw parsing_error(err.str());
        }
        add_to_vector(str_instr, line_num, str);
        line_num++;
}

int Reader::read_asm(string filename){

    std::ifstream test(filename); 
    if (!test)
    {
        std::cout << "[ERROR] The file \"" << filename << "\" doesn't exist" << std::endl;
        return -1;
    }

    fstream ainput;
    ainput.open(filename, ios::in);

    cerr << "[INFO] Reading " << filename <<  "... " << endl;

    hasDebuggingInfo = true;

    string str;
    int32_t line_num = 0;
    int32_t now_addr = 0;
    int8_t slot = 0;
    wrt = vector<int8_t>(4, -1);
    
    while(getline(ainput, str)){
        try{
            auto commaPos = str.find_first_of(';');
            do{
                commaPos = str.find_first_of(';');
                auto str_tmp = str.substr(0, commaPos);
                str = str.substr(commaPos + 1);
                read_one_line(line_num, now_addr, str_tmp, slot);
            }while(commaPos != string::npos && slot < VLIW_SIZE);
        }catch(exception &e){
            stringstream err;
            err << "[ERROR] Parsing Error at line " << readerLineToRealLine(line_num) << ": " << str << "\n" << e.what();
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
            for(int i=0; i<VLIW_SIZE; i++){
                if(unr.slot != i && writetoRegs[unr.addr][i] == pres.writetoreg && pres.writetoreg != pres.reg_dfl){
                    cerr << "[WARNING] Line: " << readerLineToRealLine(pc_to_line(unr.addr)+1) << " Same destination register " << regName.at(pres.writetoreg) << \
                     " used in slot " << (i+1) << " and slot " << (unr.slot + 1) << endl; 
                }
            }
            writetoRegs[unr.addr][unr.slot] = pres.writetoreg;
            instructions.at(unr.addr*VLIW_SIZE + unr.slot) = pres.code;
        }else{
            stringstream err;
            err << "[ERROR] Label resolution Failed at line " << pc_to_line(unr.addr) << ":\n" << unr.str << endl;
            throw parsing_error(err.str());
        }

        unresolved.pop();
    }

    if(instructions.size() <= 0){
        return -1;
    }

    cerr << "[INFO] Reading complete!" << endl;
    return 0;
    ainput.close();
}

int Reader::eat_bin(string filename){
    std::ifstream test(filename); 
    if (!test)
    {
        std::cout << "[ERROR] The file \"" << filename << "\" doesn't exist" << std::endl;
        return -1;
    }
    cerr << "[INFO] Eating " << filename << "..." << endl;
    
    fstream binput;

    binput.open(filename);

    uint32_t code = 0;
    int32_t now_addr = 0;
    int32_t line_num = 0;

    int8_t packingidx = 0;

    while(binput.read((char *) &code, sizeof(uint32_t))){
        add_to_vector(instructions, now_addr, code);
        add_to_vector(str_instr, now_addr, disassemble(code));
        add_to_vector(l_to_p, now_addr, line_num);

        line_num++;
        packingidx = (packingidx + 1) % VLIW_SIZE;
        if(packingidx == 0){
            add_to_vector(p_to_l, now_addr, line_num-VLIW_SIZE);
            now_addr++;
        }
    }

    binput.close();

    if(instructions.size() <= 0){
        return -1;
    }
    cerr << "[INFO] Eating complete!" << endl;
    return 0;
}

void Reader::write_to_file(string filename){
    fstream output;
    output.open(filename, ios::binary | ios::out);
    for(size_t i=0; i<instructions.size(); i++){
        output.write(reinterpret_cast<char *> (&instructions[i]), sizeof(instructions[i]));
    }
    output.close();
}

void Reader::export_debugging_info(string filename){    
    if(!hasDebuggingInfo) return;
    fstream output;
    output.open(filename, ios::out);
    
    //write length of file
    output << labellist.size() << "\n";

    //write label position and name
    for(size_t i=0; i<labellist.size();i++){
        output << labellist[i].pc << " " << labellist[i].label << "\n";
    }

    output << flush;
    output.close();
}

void Reader::import_debugging_info(string filename){
    fstream in;
    in.open(filename, ios::in);

    uint32_t length;
    in >> length;

    labellist = vector<pcandlabel>();    
    labellist.reserve(length);

    for(uint32_t i=0; i<length; i++){
        uint32_t p;
        string l;
        in >> p >> l;
        labellist.emplace_back(pcandlabel(p, l));
    }
    
    hasDebuggingInfo = true;
}

int Reader::line_to_pc(int l){
    if(l < 0) return 0;
    else if(l >= (int)l_to_p.size()){
        return l_to_p.at(l_to_p.size() - 1);
    }else{
        return l_to_p.at(l);
    }
}

int Reader::pc_to_line(int pc){
    if(pc < 0) return 0;
    else if(pc >= (int)p_to_l.size()){
        return p_to_l.at(p_to_l.size()-1);
    }else{
        return p_to_l.at(pc);
    }
}

void Reader::full_reset(){
    instructions = vector<uint32_t>();
    str_instr = vector<string>();
    unresolved = queue<tobeAssembled>();
    l_to_p = vector<int>();
    p_to_l = vector<int>();
}