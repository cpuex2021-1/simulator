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
#define NO_ARGS_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s*"
#define SW_LIKE_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s+([\\w|\\.|\\-|\\d]+)\\s*,\\s*([\\-]*\\d+)\\(([\\w|\\.|\\-|\\d]+)\\)\\s*"

using namespace std;

int32_t Parse::label_to_addr(string str, int now_addr){
    try{
       return labels.at(str) - now_addr;
    }catch(out_of_range &e) {
        try{
           return stoi(str);
        }catch(invalid_argument &e){
            stringstream err;
            err << "[ERROR] Unknown label: " << str;
            throw label_not_found(err.str());
        }
    }
   return -1;
}

uint32_t Parse::regname_to_addr(string str){
    try {
        return regs.at(str);
    } catch (exception &e){
        stringstream err;
        err << "[ERROR] Unknown register: " << str;
        throw invalid_argument(err.str());
    }
}

void remove_comment(string& str){
    const auto pos = str.find_first_of('#');
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
    } else if(regex_match(str, match, regex(THREE_ARGS_EXPR)) || regex_match(str, match, regex(TWO_ARGS_EXPR)) || regex_match(str, match, regex(SW_LIKE_EXPR)) || regex_match(str, match, regex(ONE_ARGS_EXPR)) || regex_match(str, match, regex(NO_ARGS_EXPR))){
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


Parse :: Parse(string str, int now_addr)
{
    remove_comment(str);
    smatch match;
    if(regex_match(str, match, regex(PSUEDO))){
        type = none;
    } else if(regex_match(str, match, regex(LABEL_EXPR))){
        type = label;
        labl = match[1].str();
    } else if(regex_match(str, match, regex(THREE_ARGS_EXPR)) || regex_match(str, match, regex(TWO_ARGS_EXPR)) || regex_match(str, match, regex(SW_LIKE_EXPR)) || regex_match(str, match, regex(ONE_ARGS_EXPR)) || regex_match(str, match, regex(NO_ARGS_EXPR))){
        type = instruction;
    } else if(regex_match(str, match, regex("\\s*"))){
        type = none;
    } else {
        type = error;
    }

    try{
        if(type == instruction){
            if(match[1].str() ==  "add"){
                code = (Rtype(
                    0,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                codetype = alu;
                writetoreg = regname_to_addr(match[2].str());
            }else if(match[1].str() ==  "sub"){
                code = (Rtype(
                    0,
                    1,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                codetype = alu;
                writetoreg = regname_to_addr(match[2].str());
            }
            
            else if(match[1].str() ==  "fadd"){
                code = (Rtype(
                    2,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                
            }else if(match[1].str() ==  "fsub"){
                code = (Rtype(
                    2,
                    1,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                
            }else if(match[1].str() ==  "fmul"){
                code = (Rtype(
                    2,
                    2,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                
            }else if(match[1].str() ==  "fdiv"){
                code = (Rtype(
                    2,
                    3,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                
            }else if(match[1].str() ==  "fsqrt"){
                code = (Rtype(
                    2,
                    4,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                
            }else if(match[1].str() ==  "fneg"){
                code = (Rtype(
                    2,
                    5,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                
            }else if(match[1].str() ==  "fabs"){
                code = (Rtype(
                    2,
                    6,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                
            }else if(match[1].str() ==  "floor"){
                code = (Rtype(
                    2,
                    7,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());
            }            
            else if(match[1].str() ==  "feq"){
                code = (Rtype(
                    3,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                
            }else if(match[1].str() ==  "flt"){
                code = (Rtype(
                    3,
                    1,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                
            }else if(match[1].str() ==  "fle"){
                code = (Rtype(
                    3,
                    2,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                
            }else if(match[1].str() ==  "itof"){
                code = (Rtype(
                    3,
                    6,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                
            }else if(match[1].str() ==  "ftoi"){
                code = (Rtype(
                    3,
                    7,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                
            }

            else if(match[1].str() ==  "addi"){
                code = (ILtype(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    stoi(match[4].str())
                ));
                codetype = alu;
                writetoreg = regname_to_addr(match[2].str());                
            }else if(match[1].str() ==  "slli"){
                code = (ILtype(
                    4,
                    1,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    stoi(match[4].str()) & 0b11111
                ));
                codetype = alu;
                writetoreg = regname_to_addr(match[2].str());                
            }else if(match[1].str() ==  "srli"){
                code = (ILtype(
                    4,
                    2,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    stoi(match[4].str()) & 0b11111
                ));
                codetype = alu;
                writetoreg = regname_to_addr(match[2].str());                
            }
            
            else if(match[1].str() ==  "lw"){
                code = (ILtype(
                    5,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[4].str()),
                    stoi(match[3].str())
                ));
                if(match[4].str() == "zero" && stoi(match[3].str()) == 0){
                    codetype = uart;
                    writetoreg = regname_to_addr(match[2].str());           
                }else{
                    codetype = ma;
                    writetoreg = regname_to_addr(match[2].str());
                }
            }else if(match[1].str() ==  "vlw"){
                //tbd
                code = (ILtype(
                    5,
                    1,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[4].str()),
                    stoi(match[3].str())
                ));
                
            }else if(match[1].str() ==  "lui"){
                int imm = stoi(match[3].str());
                code = (ILtype(
                    5,
                    2,
                    regname_to_addr(match[2].str()),
                    ((uint32_t)imm >> 16),
                    imm & ((1 << 16) -1)
                ));
                codetype = alu;
                writetoreg = regname_to_addr(match[2].str());                                
            }

            //only on simulator
            else if(match[1].str() ==  "fsin"){
                code = (Rtype(
                    5,
                    5,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());
            }else if(match[1].str() ==  "fcos"){
                code = (Rtype(
                    5,
                    6,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                                
            }else if(match[1].str() ==  "atan"){
                code = (Rtype(
                    5,
                    7,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));                    
                codetype = fpu;
                writetoreg = regname_to_addr(match[2].str());                                
            }

            else if(match[1].str() ==  "beq"){
                code = (SBtype(
                    6,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    label_to_addr(match[4].str(), now_addr)
                ));
                codetype = b_j;
                writetoreg = reg_dfl;                                
            }else if(match[1].str() ==  "bne"){
                code = (SBtype(
                    6,
                    1,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    label_to_addr(match[4].str(), now_addr)
                ));
                codetype = b_j;
                writetoreg = reg_dfl;                
            }else if(match[1].str() ==  "blt"){
                code = (SBtype(
                    6,
                    2,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    label_to_addr(match[4].str(), now_addr)
                ));
                codetype = b_j;
                writetoreg = reg_dfl;                
            }else if(match[1].str() ==  "bge"){
                code = (SBtype(
                    6,
                    3,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    label_to_addr(match[4].str(), now_addr)
                ));
                codetype = b_j;
                writetoreg = reg_dfl;                
            }else if(match[1].str() ==  "bnei"){
                code = (SBtype(
                    6,
                    5,
                    regname_to_addr(match[2].str()),
                    stoi(match[3].str()),
                    label_to_addr(match[4].str(), now_addr)
                ));
                codetype = b_j;
                writetoreg = reg_dfl;                
            }else if(match[1].str() ==  "sw"){
                code = (SBtype(
                    6,
                    6,
                    regname_to_addr(match[4].str()),
                    regname_to_addr(match[2].str()),
                    stoi(match[3].str())
                ));
                if(match[4].str() == "zero" && stoi(match[3].str()) == 0){
                    codetype = uart;
                    writetoreg = reg_dfl;
                }else{
                    codetype = ma;
                    writetoreg = reg_dfl;
                }
                
            }else if(match[1].str() ==  "vsw"){
                //tbd
                code = (SBtype(
                    6,
                    7,
                    regname_to_addr(match[4].str()),
                    regname_to_addr(match[2].str()),
                    stoi(match[3].str())
                ));
                
            }

            else if(match[1].str() ==  "jump"){
                int addr = label_to_addr(match[2].str(), 0);
                code = (Jtype(
                    7,
                    0,
                    addr & ((1 << 25) - 1)
                ));
                codetype = b_j;
                writetoreg = reg_dfl;                
            }else if(match[1].str() ==  "jumpr"){
                int rs1 = regname_to_addr(match[2].str()) & 0b11111;
                code = (Jtype(
                    7,
                    1,
                    (rs1 << 20)
                ));
                codetype = b_j;
                writetoreg = reg_dfl;                
            }else if(match[1].str() ==  "call"){
                int addr = label_to_addr(match[2].str(), 0);
                code = (Jtype(
                    7,
                    2,
                    addr & ((1 << 25) - 1)
                ));
                codetype = b_j;
                writetoreg = reg_dfl;                
            }else if(match[1].str() ==  "callr"){
                int rs1 = regname_to_addr(match[2].str()) & 0b11111;
                code = (Jtype(
                    7,
                    3,
                    (rs1 << 20)
                ));
                codetype = b_j;
                writetoreg = reg_dfl;                
            }else if(match[1].str() ==  "ret"){
                code = (Jtype(
                    7,
                    4,
                    0
                ));               
                codetype = b_j;
                writetoreg = reg_dfl;
            }
            
            //psuedo instructions
            else if(match[1].str() ==  "li"){
                code = (ILtype(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[2].str()),
                    stoi(match[3].str())
                ));
                codetype = alu;
                writetoreg = regname_to_addr(match[2].str());
            }else if(match[1].str() == "lui.float"){
                float imm = stof(match[3].str());
                uint32_t* immint = (uint32_t *)&imm;
                uint32_t luiimm = (*immint) >> 12;
                code = (ILtype(
                    5,
                    2,
                    regname_to_addr(match[2].str()),
                    ((uint32_t)luiimm >> 14),
                    luiimm & ((1 << 14) -1)
                ));
                codetype = alu;
                writetoreg = regname_to_addr(match[2].str()); 
            }else if(match[1].str() == "addi.float"){
                float imm = stof(match[4].str());
                uint32_t* immint = (uint32_t *)&imm;
                int32_t addiimm = (*immint) & ((1 << 12) - 1);
                code = (ILtype(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[2].str()),
                    addiimm
                ));
                codetype = alu;
                writetoreg = regname_to_addr(match[2].str()); 
            }else if(match[1].str() == "lui.label"){
                int imm = label_to_addr(match[3].str(), 0);
                int luiimm = imm >> 12;
                
                code = (ILtype(
                    5,
                    2,
                    regname_to_addr(match[2].str()),
                    ((uint32_t)luiimm >> 14),
                    luiimm & ((1 << 14) -1)
                ));
                codetype = alu;
                writetoreg = regname_to_addr(match[2].str()); 
            }else if(match[1].str() == "addi.label"){
                int imm = label_to_addr(match[4].str(), 0);
                int addiimm = imm & ((1 << 12) - 1);
                
                code = (ILtype(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[2].str()),
                    addiimm
                ));
                codetype = alu;
                writetoreg = regname_to_addr(match[2].str()); 
            }else if(match[1].str() == "nop"){
                code = 0;
                codetype = nop;
                writetoreg = reg_dfl;
            }
            
            else{
                stringstream err;
                err << "[ERROR] Unknown Opecode: " << match[1].str() << endl;
                code = (0);
                throw invalid_instruction(err.str());
            }
        }
    }catch(label_not_found &e){
        type = unresolved;
    }
}

void Parse::print_instr(){
    for(int i=31; i>=0; i--){
        cout << (code >> i & 1);
    }
    cout << endl;
}