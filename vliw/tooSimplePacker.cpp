#include <string>
#include <regex>
#include <sstream>
#include <iostream>
#include <string>
#include <fstream>

#define PSUEDO "\\.([\\w|\\.|\\-|\\d]+)\\s*([\\w|\\.|\\-|\\d]+)"
#define LABEL_EXPR "([\\w|\\.|\\-|\\d]+):\\s*"
#define THREE_ARGS_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s+([\\w|\\.|\\-|\\d]+)\\s*,\\s*([\\w|\\.|\\-|\\d]+)\\s*,\\s*([\\w|\\.|\\-|\\d]+)\\s*"
#define TWO_ARGS_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s+([\\w|\\.|\\-|\\d]+)\\s*,\\s*([\\w|\\.|\\-|\\d]+)\\s*"
#define ONE_ARGS_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s+([\\w|\\.|\\-|\\d]+)\\s*" 
#define NO_ARGS_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s*"
#define SW_LIKE_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s+([\\w|\\.|\\-|\\d]+)\\s*,\\s*([\\-]*\\d+)\\(([\\w|\\.|\\-|\\d]+)\\)\\s*"

using namespace std;

void remove_comment(string& str){
    const auto pos = str.find_first_of('#');
    if(pos != string::npos){
        str = str.substr(0, pos) + "\n";
    }
}

enum {b_j, alu, fpu, uart, ma, nop};

string simplePack(string str, int type){
    stringstream ss;
    int slot;
    if(type == alu || type == fpu || type == b_j) slot = 0;
    else slot = 2;
    for(int i=0; i<4; i++){
        if(i == slot) ss << str << "; ";
        else ss << "nop; ";
    }
    return ss.str();
}

int checktype(string str, smatch& match){
    if(str ==  "add"){
        return alu;
    }else if(str ==  "sub"){
        return alu;
    }
    
    else if(str ==  "fadd"){
        return fpu;
    }else if(str ==  "fsub"){
        return fpu;
    }else if(str ==  "fmul"){
        return fpu;
    }else if(str ==  "fdiv"){
        return fpu;          
    }else if(str ==  "fsqrt"){
        return fpu;        
    }else if(str ==  "fneg"){
        return fpu;           
    }else if(str ==  "fabs"){
        return fpu;          
    }else if(str ==  "floor"){
        return fpu;
    }            
    else if(str ==  "feq"){
        return fpu;
    }else if(str ==  "flt"){
        return fpu;
    }else if(str ==  "fle"){
        return fpu;
    }else if(str ==  "itof"){
        return fpu;            
    }else if(str ==  "ftoi"){
        return fpu;              
    }

    else if(str ==  "addi"){
        return alu;
    }else if(str ==  "slli"){
        return alu;
    }else if(str ==  "srli"){
        return alu;
    }
    
    else if(str ==  "lw"){
        if(match[4].str() == "zero" && stoi(match[3].str()) == 0){
            return uart; 
        }else{
            return ma;
        }
    }else if(str ==  "lui"){
        return alu;      
    }

    else if(str ==  "beq"){
        return b_j;
    }else if(str ==  "bne"){                
        return b_j;
    }else if(str ==  "blt"){
        return b_j;
    }else if(str ==  "bge"){                
        return b_j;
    }else if(str ==  "bnei"){
        return b_j;
                        
    }else if(str ==  "sw"){
        if(match[4].str() == "zero" && stoi(match[3].str()) == 0){
            return uart;
        }else{
            return ma;
        }
        
    }else if(str ==  "jump"){
        return b_j;    
    }else if(str ==  "jumpr"){
        return b_j;
    }else if(str ==  "call"){
        return b_j;
    }else if(str ==  "callr"){
        return b_j;
    }else if(str ==  "ret"){
        return b_j;
    }
    
    //psuedo instructions
    else if(str ==  "li"){
        return alu;
    }else if(str == "lui.float"){
        return alu;
        
    }else if(str == "addi.float"){
        return alu;
        
    }else if(str == "lui.label"){
        return alu;

    }else if(str == "addi.label"){
        return alu;
    }else if(str == "nop"){
        return nop;
    }else{
        cerr << "Unknown Opecode: " << str << endl;
        exit(1);
    }    
}

string translate(string str){
    stringstream ss;
    
    remove_comment(str);
    smatch match;
    if(regex_match(str, match, regex(PSUEDO))){
        ss << "";
    } else if(regex_match(str, match, regex(LABEL_EXPR))){
        ss << str;
    } else if(regex_match(str, match, regex(THREE_ARGS_EXPR)) || regex_match(str, match, regex(TWO_ARGS_EXPR)) || regex_match(str, match, regex(SW_LIKE_EXPR)) || regex_match(str, match, regex(ONE_ARGS_EXPR)) || regex_match(str, match, regex(NO_ARGS_EXPR))){
        auto slot = checktype(match[1].str(), match);
        ss << simplePack(str, slot);
    } else if(regex_match(str, match, regex("\\s*"))){
        ss << "";
    } else {
        cerr << "Match Error" << endl;
        exit(1);
    }
    //cout << ss.str() << endl;
    return ss.str();
}

int main(int argc, char* argv[]){
    
    if(argc < 3) {
        cout << "Usage: assembler [input file] [output file]" << endl;
        exit(1);
    }

    string infile(argv[1]);
    string outfile(argv[2]);

    ifstream test(infile); 
    if (!test)
    {
        std::cout << "[ERROR] The file \"" << infile << "\" doesn't exist" << std::endl;
        return -1;
    }

    fstream input;
    input.open(infile, ios::in);

    fstream output;
    output.open(outfile, ios::out);
    
    string str;

    while (getline(input, str))
    {
        output << translate(str) << endl;
    }
}