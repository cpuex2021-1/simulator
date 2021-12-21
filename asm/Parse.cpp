#include "Parse.hpp"
#include <iostream>
#include <regex>
#include <sstream>
#include <string>

#define PSUEDO "\\.([\\w|\\.|\\-|\\d]+)\\s*([\\w|\\.|\\-|\\d]+)"
#define LABEL_EXPR "([\\w|\\.|\\-|\\d]+):\\s*"
#define THREE_ARGS_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s+([\\w|\\.|\\-|\\d]+)\\s*,\\s*([\\w|\\.|\\-|\\d]+)\\s*,\\s*([\\w|\\.|\\-|\\d]+)\\s*"
#define TWO_ARGS_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s+([\\w|\\.|\\-|\\d]+)\\s*,\\s*([\\w|\\.|\\-|\\d]+)\\s*"
#define ONE_ARGS_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s+([\\w|\\.|\\-|\\d]+)\\s*" 
#define SW_LIKE_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s+([\\w|\\.|\\-|\\d]+)\\s*,\\s*([\\-]*\\d+)\\(([\\w|\\.|\\-|\\d]+)\\)\\s*"

using namespace std;

int label_to_addr(string str, int now_addr){
    try{
        return labels.at(str) - now_addr;
    }catch(out_of_range &e) {
        try{
            return stoi(str);
        }catch(invalid_argument &e){
            cerr << "Unknown label: " << str << endl;
        }
    }
    exit(1);
    return -1;
}

int regname_to_addr(string str){
    try {
        return regs.at(str);
    } catch (out_of_range &e){
        cerr << "Unknown register: " << str << endl;
        exit(1);
    }
}

void remove_comment(string& str){
    const long unsigned int pos = str.find_first_of('#');
    if(pos != string::npos){
        str = str.substr(0, pos) + "\n";
    }
}

void Debug_parse(string str){    
    remove_comment(str);
    smatch match;
    if(regex_match(str, match, regex(PSUEDO))){
        cout << "none" << endl;
    } else if(regex_match(str, match, regex(LABEL_EXPR))){
        cout << "label" << endl;
    } else if(regex_match(str, match, regex(THREE_ARGS_EXPR)) || regex_match(str, match, regex(TWO_ARGS_EXPR)) || regex_match(str, match, regex(SW_LIKE_EXPR)) || regex_match(str, match, regex(ONE_ARGS_EXPR))){
        cout << "instruction" << endl;
    } else if(regex_match(str, match, regex("\\s*"))){
        cout << "none" << endl;
    } else {
        cout << "error" << endl;
    }
    for(int i=0; i<(int)match.size(); i++){
        cout << i <<  ": " << match[i].str() << endl;
    }
}


Parse :: Parse(string str, bool label_only, int now_addr)
:size(1)
{
    remove_comment(str);
    smatch match;
    if(regex_match(str, match, regex(PSUEDO))){
        type = none;
    } else if(regex_match(str, match, regex(LABEL_EXPR))){
        type = label;
        labl = match[1].str();
    } else if(regex_match(str, match, regex(THREE_ARGS_EXPR)) || regex_match(str, match, regex(TWO_ARGS_EXPR)) || regex_match(str, match, regex(SW_LIKE_EXPR)) || regex_match(str, match, regex(ONE_ARGS_EXPR))){
        type = instruction;
        if(match[1].str() == "fli"){
            size = 3;
        }else if(match[1].str() == "li"){
            int imm = stoi(match[3].str());

            if(imm >= (1 << 16)){
                size = 2;
            }else{
                size = 1;
            }
            
        }
    } else if(regex_match(str, match, regex("\\s*"))){
        type = none;
    } else {
        type = error;
    }

    codes = vector<uint32_t>();

    if(type == instruction && !label_only){
        if(match[1].str() ==  "add"){
            Rtype ret(
                0,
                0,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "sub"){
            Rtype ret(
                0,
                0,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                1);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "sll"){
            Rtype ret(
                0,
                1,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "srl"){
            Rtype ret(
                0,
                2,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "sra"){
            Rtype ret(
                0,
                2,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                1);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "slt"){
            Rtype ret(
                0,
                3,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "sltu"){
            Rtype ret(
                0,
                4,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "xor"){
            Rtype ret(
                0,
                5,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "or"){
            Rtype ret(
                0,
                6,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "and"){
            Rtype ret(
                0,
                7,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }
        
        else if(match[1].str() ==  "mul"){
            Rtype ret(
                1,
                0,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "mulh"){
            Rtype ret(
                1,
                1,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "mulhsu"){
            Rtype ret(
                1,
                2,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "mulhu"){
            Rtype ret(
                1,
                3,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "div"){
            Rtype ret(
                1,
                4,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "divu"){
            Rtype ret(
                1,
                5,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "rem"){
            Rtype ret(
                1,
                6,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "remu"){
            Rtype ret(
                1,
                7,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }
        
        else if(match[1].str() ==  "fadd"){
            Rtype ret(
                2,
                0,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "fsub"){
            Rtype ret(
                2,
                1,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "fmul"){
            Rtype ret(
                2,
                2,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "fdiv"){
            Rtype ret(
                2,
                3,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "fsqrt"){
            Rtype ret(
                2,
                4,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                0,
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "fneg"){
            Rtype ret(
                2,
                5,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                0,
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "fmin"){
            Rtype ret(
                2,
                6,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "fmax"){
            Rtype ret(
                2,
                7,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }
        
        else if(match[1].str() ==  "feq"){
            Rtype ret(
                3,
                0,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "flt"){
            Rtype ret(
                3,
                1,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "fle"){
            Rtype ret(
                3,
                2,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                regname_to_addr(match[4].str()),
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "fmv.x.w"){
            Rtype ret(
                3,
                3,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                0,
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "fmv.w.x"){
            Rtype ret(
                3,
                4,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                0,
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "fmv"){
            Rtype ret(
                3,
                5,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                0,
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "itof"){
            Rtype ret(
                3,
                6,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                0,
                0);
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "ftoi"){
            Rtype ret(
                3,
                6,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                0,
                0);
            codes.push_back(ret.assemble());
        }

        else if(match[1].str() ==  "addi"){
            I_Ltype ret(
                4,
                0,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                stoi(match[4].str())
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "slli"){
            I_Ltype ret(
                4,
                1,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                stoi(match[4].str()) & 0b11111
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "srli"){
            I_Ltype ret(
                4,
                2,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                stoi(match[4].str()) & 0b11111
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "srai"){
            I_Ltype ret(
                4,
                2,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                stoi(match[4].str()) & 0b11111
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "slti"){
            I_Ltype ret(
                4,
                3,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                stoi(match[4].str())
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "sltui"){
            I_Ltype ret(
                4,
                4,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                stoi(match[4].str())
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "xori"){
            I_Ltype ret(
                4,
                5,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                stoi(match[4].str())
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "ori"){
            I_Ltype ret(
                4,
                6,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                stoi(match[4].str())
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "andi"){
            I_Ltype ret(
                4,
                7,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                stoi(match[4].str())
            );
            codes.push_back(ret.assemble());
        }
        
        else if(match[1].str() ==  "lw"){
            I_Ltype ret(
                5,
                0,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[4].str()),
                stoi(match[3].str())
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "flw"){
            I_Ltype ret(
                5,
                1,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[4].str()),
                stoi(match[3].str())
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "lui"){
            int imm = stoi(match[3].str());
            I_Ltype ret(
                5,
                2,
                regname_to_addr(match[2].str()),
                ((unsigned int)imm >> 16),
                imm & ((1 << 16) -1)
            );
            codes.push_back(ret.assemble());
        }

        else if(match[1].str() ==  "beq"){
            S_Btype ret(
                6,
                0,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                label_to_addr(match[4].str(), now_addr)
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "bne"){
            S_Btype ret(
                6,
                1,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                label_to_addr(match[4].str(), now_addr)
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "blt"){
            S_Btype ret(
                6,
                2,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                label_to_addr(match[4].str(), now_addr)
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "bge"){
            S_Btype ret(
                6,
                3,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                label_to_addr(match[4].str(), now_addr)
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "bltu"){
            S_Btype ret(
                6,
                4,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                label_to_addr(match[4].str(), now_addr)
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "bgeu"){
            S_Btype ret(
                6,
                5,
                regname_to_addr(match[2].str()),
                regname_to_addr(match[3].str()),
                label_to_addr(match[4].str(), now_addr)
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "sw"){
            S_Btype ret(
                6,
                6,
                regname_to_addr(match[4].str()),
                regname_to_addr(match[2].str()),
                stoi(match[3].str())
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "fsw"){
            S_Btype ret(
                6,
                7,
                regname_to_addr(match[4].str()),
                regname_to_addr(match[2].str()),
                stoi(match[3].str())
            );
            codes.push_back(ret.assemble());
        }

        else if(match[1].str() ==  "jump"){
            int addr = label_to_addr(match[2].str(), 0);
            Jtype ret(
                7,
                0,
                addr & ((1 << 25) - 1)
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "jal"){
            int lab = label_to_addr(match[3].str(), 0);
            int rd = regs[match[2].str()];
            Jtype ret(
                7,
                1,
                ((lab & (0b11111 << 16)) << 21) | ((rd & 0b11111) << 16) | (lab & ((1 << 16) -1))
            );
            codes.push_back(ret.assemble());
        }else if(match[1].str() ==  "jalr"){
            int rd = regs[match[2].str()] & 0b11111;
            int rs1 = regs[match[3].str()] & 0b11111;
            Jtype ret(
                7,
                2,
                (rs1 << 21) | (rd << 16) | (label_to_addr(match[4].str(), 0) & ((1 << 16) -1))
            );
            codes.push_back(ret.assemble());
        }
        
        else if(match[1].str() == "fli"){
            float imm = stof(match[3].str());
            int* immint = (int *)&imm;
            int luiimm = (*immint) >> 12;
            int addiimm = (*immint) & ((1 << 12) - 1);
            I_Ltype ret1(
                5,
                2,
                regname_to_addr("a21"),
                ((unsigned int)luiimm >> 16),
                luiimm & ((1 << 16) -1)
            );
            codes.push_back(ret1.assemble());
            I_Ltype ret2(
                4,
                0,
                regname_to_addr("a21"),
                regname_to_addr("a21"),
                addiimm
            );
            codes.push_back(ret2.assemble());
            Rtype ret3(
                3,
                4,
                regname_to_addr(match[2].str()),
                regname_to_addr("a21"),
                0,
                0);
            codes.push_back(ret3.assemble());
        }else if(match[1].str() == "li"){
            int imm = stoi(match[3].str());

            if(imm >= (1 << 16)){
                int luiimm = imm >> 12;
                int addiimm = imm & ((1 << 12) - 1);
                
                I_Ltype ret1(
                    5,
                    2,
                    regname_to_addr(match[2].str()),
                    ((unsigned int)luiimm >> 16),
                    luiimm & ((1 << 16) -1)
                );
                codes.push_back(ret1.assemble());        
                
                I_Ltype ret2(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[2].str()),
                    addiimm
                );
                codes.push_back(ret2.assemble());
            }else{
                 I_Ltype ret2(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr("zero"),
                    imm
                );
                codes.push_back(ret2.assemble());
            }
            
        }else if(match[1].str() == "la"){
            int imm = label_to_addr(match[3].str(), 0);

            if(imm >= (1 << 16)){
                int luiimm = imm >> 12;
                int addiimm = imm & ((1 << 12) - 1);
                
                I_Ltype ret1(
                    5,
                    2,
                    regname_to_addr(match[2].str()),
                    ((unsigned int)luiimm >> 16),
                    luiimm & ((1 << 16) -1)
                );
                codes.push_back(ret1.assemble());        
                
                I_Ltype ret2(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[2].str()),
                    addiimm
                );
                codes.push_back(ret2.assemble());
            }else{
                 I_Ltype ret2(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr("zero"),
                    imm
                );
                codes.push_back(ret2.assemble());
            }
            
        }
        
        else{
            cerr << "Unknown Opecode: " << match[1].str() << endl;
            codes.push_back(0);
        }
    }
}

void Parse :: print_instr(){
    for(unsigned int j=0; j<codes.size(); j++){
        for(int i=31; i>=0; i--){
            cout << (codes[j] >> i & 1);
        }
        cout << endl;
    }
}