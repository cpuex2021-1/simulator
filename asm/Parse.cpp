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
            err << "Unknown label: " << str;
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
        err << "Unknown register: " << str;
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
:size(1)
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

    try{
        if(type == instruction){
            if(match[1].str() ==  "add"){
                codes.push_back(Rtype(
                    0,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                
            }else if(match[1].str() ==  "sub"){
                codes.push_back(Rtype(
                    0,
                    1,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                
            }
            
            else if(match[1].str() ==  "fadd"){
                codes.push_back(Rtype(
                    2,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                
            }else if(match[1].str() ==  "fsub"){
                codes.push_back(Rtype(
                    2,
                    1,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                
            }else if(match[1].str() ==  "fmul"){
                codes.push_back(Rtype(
                    2,
                    2,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                
            }else if(match[1].str() ==  "fdiv"){
                codes.push_back(Rtype(
                    2,
                    3,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                
            }else if(match[1].str() ==  "fsqrt"){
                codes.push_back(Rtype(
                    2,
                    4,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                
            }else if(match[1].str() ==  "fneg"){
                codes.push_back(Rtype(
                    2,
                    5,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                
            }else if(match[1].str() ==  "fabs"){
                codes.push_back(Rtype(
                    2,
                    6,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                
            }else if(match[1].str() ==  "floor"){
                codes.push_back(Rtype(
                    2,
                    7,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                
            }
            
            else if(match[1].str() ==  "feq"){
                codes.push_back(Rtype(
                    3,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                
            }else if(match[1].str() ==  "flt"){
                codes.push_back(Rtype(
                    3,
                    1,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                
            }else if(match[1].str() ==  "fle"){
                codes.push_back(Rtype(
                    3,
                    2,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    regname_to_addr(match[4].str()),
                    0));
                
            }else if(match[1].str() ==  "itof"){
                codes.push_back(Rtype(
                    3,
                    6,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                
            }else if(match[1].str() ==  "ftoi"){
                codes.push_back(Rtype(
                    3,
                    7,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                
            }

            else if(match[1].str() ==  "addi"){
                codes.push_back(ILtype(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    stoi(match[4].str())
                ));
                
            }else if(match[1].str() ==  "slli"){
                codes.push_back(ILtype(
                    4,
                    1,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    stoi(match[4].str()) & 0b11111
                ));
                
            }else if(match[1].str() ==  "srai"){
                codes.push_back(ILtype(
                    4,
                    2,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    stoi(match[4].str()) & 0b11111
                ));
                
            }
            
            else if(match[1].str() ==  "lw"){
                codes.push_back(ILtype(
                    5,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[4].str()),
                    stoi(match[3].str())
                ));
                
            }else if(match[1].str() ==  "vlw"){
                codes.push_back(ILtype(
                    5,
                    1,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[4].str()),
                    stoi(match[3].str())
                ));
                
            }else if(match[1].str() ==  "lui"){
                int imm = stoi(match[3].str());
                codes.push_back(ILtype(
                    5,
                    2,
                    regname_to_addr(match[2].str()),
                    ((uint32_t)imm >> 16),
                    imm & ((1 << 16) -1)
                ));
                
            }

            //only on simulator
            else if(match[1].str() ==  "fsin"){
                codes.push_back(Rtype(
                    5,
                    5,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                
            }else if(match[1].str() ==  "fcos"){
                codes.push_back(Rtype(
                    5,
                    6,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                
            }else if(match[1].str() ==  "atan"){
                codes.push_back(Rtype(
                    5,
                    7,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
                
            }

            else if(match[1].str() ==  "beq"){
                codes.push_back(SBtype(
                    6,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    label_to_addr(match[4].str(), now_addr)
                ));
                
            }else if(match[1].str() ==  "bne"){
                codes.push_back(SBtype(
                    6,
                    1,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    label_to_addr(match[4].str(), now_addr)
                ));
                
            }else if(match[1].str() ==  "blt"){
                codes.push_back(SBtype(
                    6,
                    2,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    label_to_addr(match[4].str(), now_addr)
                ));
                
            }else if(match[1].str() ==  "bge"){
                codes.push_back(SBtype(
                    6,
                    3,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    label_to_addr(match[4].str(), now_addr)
                ));
                
            }else if(match[1].str() ==  "bnei"){
                codes.push_back(SBtype(
                    6,
                    5,
                    regname_to_addr(match[2].str()),
                    stoi(match[3].str()),
                    label_to_addr(match[4].str(), now_addr)
                ));
                
            }else if(match[1].str() ==  "sw"){
                codes.push_back(SBtype(
                    6,
                    6,
                    regname_to_addr(match[4].str()),
                    regname_to_addr(match[2].str()),
                    stoi(match[3].str())
                ));
                
            }else if(match[1].str() ==  "vsw"){
                codes.push_back(SBtype(
                    6,
                    7,
                    regname_to_addr(match[4].str()),
                    regname_to_addr(match[2].str()),
                    stoi(match[3].str())
                ));
                
            }

            else if(match[1].str() ==  "jump"){
                int addr = label_to_addr(match[2].str(), 0);
                codes.push_back(Jtype(
                    7,
                    0,
                    addr & ((1 << 25) - 1)
                ));
                
            }else if(match[1].str() ==  "jumpr"){
                int rs1 = regname_to_addr(match[2].str()) & 0b11111;
                codes.push_back(Jtype(
                    7,
                    1,
                    (rs1 << 20)
                ));
                
            }else if(match[1].str() ==  "call"){
                int addr = label_to_addr(match[2].str(), 0);
                codes.push_back(Jtype(
                    7,
                    2,
                    addr & ((1 << 25) - 1)
                ));
                
            }else if(match[1].str() ==  "callr"){
                int rs1 = regname_to_addr(match[2].str()) & 0b11111;
                codes.push_back(Jtype(
                    7,
                    3,
                    (rs1 << 20)
                ));
                
            }else if(match[1].str() ==  "ret"){
                codes.push_back(Jtype(
                    7,
                    4,
                    0
                ));                
            }
            
            //psuedo instructions
            else if(match[1].str() == "lui.float"){
                float imm = stof(match[3].str());
                uint32_t* immint = (uint32_t *)&imm;
                uint32_t luiimm = (*immint) >> 12;
                codes.push_back(ILtype(
                    5,
                    2,
                    regname_to_addr(match[2].str()),
                    ((uint32_t)luiimm >> 14),
                    luiimm & ((1 << 14) -1)
                ));
            }else if(match[1].str() == "addi.float"){
                float imm = stof(match[3].str());
                uint32_t* immint = (uint32_t *)&imm;
                uint32_t addiimm = (*immint) & ((1 << 12) - 1);
                codes.push_back(ILtype(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[2].str()),
                    addiimm
                ));
            }else if(match[1].str() == "lui.label"){
                int imm = label_to_addr(match[3].str(), 0);
                int luiimm = imm >> 12;
                
                codes.push_back(ILtype(
                    5,
                    2,
                    regname_to_addr(match[2].str()),
                    ((uint32_t)luiimm >> 14),
                    luiimm & ((1 << 14) -1)
                ));
            }else if(match[1].str() == "addi.label"){
                int imm = label_to_addr(match[3].str(), 0);
                int addiimm = imm & ((1 << 12) - 1);
                
                codes.push_back(ILtype(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[2].str()),
                    addiimm
                ));
            }
            
            //1st -> 2nd psuedo instructions
            else if(match[1].str() == "fli"){
                float imm = stof(match[3].str());
                uint32_t* immint = (uint32_t *)&imm;
                uint32_t luiimm = (*immint) >> 12;
                uint32_t addiimm = (*immint) & ((1 << 12) - 1);
                codes.push_back(ILtype(
                    5,
                    2,
                    regname_to_addr("a21"),
                    ((unsigned int)luiimm >> 14),
                    luiimm & ((1 << 14) -1)
                ));
                codes.push_back(ILtype(
                    4,
                    0,
                    regname_to_addr("a21"),
                    regname_to_addr("a21"),
                    addiimm
                ));
                codes.push_back(Rtype(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr("a21"),
                    0,
                    0));
            }else if(match[1].str() == "li"){
                uint32_t imm = (uint32_t)stoi(match[3].str());

                if(imm >= (1 << 16)){
                    int luiimm = imm >> 12;
                    int addiimm = imm & ((1 << 12) - 1);
                    
                    codes.push_back(ILtype(
                        5,
                        2,
                        regname_to_addr(match[2].str()),
                        ((unsigned int)luiimm >> 16),
                        luiimm & ((1 << 16) -1)
                    ));
                    
                    codes.push_back(ILtype(
                        4,
                        0,
                        regname_to_addr(match[2].str()),
                        regname_to_addr(match[2].str()),
                        addiimm
                    ));
                }else{
                    codes.push_back(ILtype(
                        4,
                        0,
                        regname_to_addr(match[2].str()),
                        regname_to_addr("zero"),
                        imm
                    ));
                }
                
            }else if(match[1].str() == "la"){
                size = 2;
                int imm = label_to_addr(match[3].str(), 0);

                int luiimm = imm >> 12;
                int addiimm = imm & ((1 << 12) - 1);
                
                codes.push_back(ILtype(
                    5,
                    2,
                    regname_to_addr(match[2].str()),
                    ((unsigned int)luiimm >> 16),
                    luiimm & ((1 << 16) -1)
                ));
                
                codes.push_back(ILtype(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[2].str()),
                    addiimm
                ));
            }else if(match[1].str() ==  "fmv.x.w"){
                codes.push_back(Rtype(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
            }else if(match[1].str() ==  "fmv.w.x"){
                codes.push_back(Rtype(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
            }else if(match[1].str() ==  "fmv"){
                codes.push_back(Rtype(
                    4,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    0,
                    0));
            }            
            else if(match[1].str() ==  "flw"){
                codes.push_back(ILtype(
                    5,
                    0,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[4].str()),
                    stoi(match[3].str())
                ));
            }else if(match[1].str() ==  "fsw"){
                codes.push_back(SBtype(
                    6,
                    6,
                    regname_to_addr(match[4].str()),
                    regname_to_addr(match[2].str()),
                    stoi(match[3].str())
                ));
            }else if(match[1].str() ==  "jal"){
                int lab = label_to_addr(match[3].str(), 0);
                codes.push_back(Jtype(
                    7,
                    2,
                    lab
                ));
            }else if(match[1].str() ==  "jalr"){
                int rs1 = regname_to_addr(match[3].str()) & 0b11111;
                if(match[2].str() == "ra"){
                    codes.push_back(Jtype(
                        7,
                        3,
                        (rs1 << 20)
                    ));
                }else if(match[2].str() == "zero"){
                    if(match[3].str() == "swp"){
                        codes.push_back(Jtype(
                            7,
                            1,
                            (rs1 << 20)
                        ));
                    }else if(match[3].str() == "ra"){
                        codes.push_back(Jtype(
                            7,
                            4,
                            0
                        ));
                    }
                }                
            }else if(match[1].str() ==  "srli"){
                codes.push_back(ILtype(
                    4,
                    2,
                    regname_to_addr(match[2].str()),
                    regname_to_addr(match[3].str()),
                    stoi(match[4].str()) & 0b11111
                ));
                
            }

            else{
                cerr << "Unknown Opecode: " << match[1].str() << endl;
                exit(1);
                codes.push_back(0);
            }
        }
    }catch(label_not_found &e){
        type = unresolved;
    }
}

void Parse::print_instr(){
    for(size_t j=0; j<codes.size(); j++){
        for(int i=31; i>=0; i--){
            cout << (codes[j] >> i & 1);
        }
        cout << endl;
    }
}