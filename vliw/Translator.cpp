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

void instTranslate(string& str, smatch& match, stringstream& ss){
    //1st -> 2nd psuedo instructions        
    if(match[1].str() == "fli"){
        ss << "\tlui.float " << match[2].str() << ", " << match[3].str() << "\n";
        ss << "\taddi.float " << match[2].str() << ", " << match[2].str() << ", " << match[3].str();
    }else if(match[1].str() == "li"){
        uint32_t imm = (uint32_t)stoi(match[3].str());

        if(imm >= (1 << 16)){
            int luiimm = imm >> 12;
            int addiimm = imm & ((1 << 12) - 1);
            
            ss << "\tlui " << match[2].str() << ", " << luiimm << "\n";
            ss << "\taddi " << match[2].str() << ", " << match[2].str() << ", " << addiimm;
        }else{            
            ss << "\taddi " << match[2].str() << ", " << "zero" << ", " << imm;
        }
        
    }else if(match[1].str() == "la"){
        ss << "\tlui.label " << match[2].str() << ", " << match[3].str() << "\n";
        ss << "\taddi.label " << match[2].str() << ", " << match[2].str() << ", " << match[3].str();
    }
    
    else if(match[1].str() ==  "fmv.x.w"){
        ss << "\taddi " << match[2].str() << ", " << match[3].str() << ", " << "0";
    }else if(match[1].str() ==  "fmv.w.x"){
        ss << "\taddi " << match[2].str() << ", " << match[3].str() << ", " << "0";
    }else if(match[1].str() ==  "fmv"){
        ss << "\taddi " << match[2].str() << ", " << match[3].str() << ", " << "0";
    }            
    else if(match[1].str() ==  "flw"){
        ss << "\tlw " << match[2].str() << ", " << match[3].str() << "(" << match[4].str() << ")";
    }else if(match[1].str() ==  "fsw"){
        ss << "\tsw " << match[2].str() << ", " << match[3].str() << "(" << match[4].str() << ")";
    }else if(match[1].str() ==  "jal"){
        ss << "\tcall " << match[3].str();
    }else if(match[1].str() ==  "jalr"){
        if(match[2].str() == "ra"){
            ss << "\tcallr " << match[3].str();
        }else if(match[2].str() == "zero"){
            if(match[3].str() == "swp"){
                ss << "\tjumpr " << match[3].str();
            }else if(match[3].str() == "ra"){
                ss << "\tret";
            }
        }                
    }else if(match[1].str() ==  "srli"){
        ss << "\tsrli " << match[2].str() << ", " << match[3].str() << ", " << match[4].str();
    }else if((match[1].str() == "sw" || match[1].str() == "lw") && match[2].str() == "ra"){
        ss << "";
    }else{
        ss << str;
    }
}

string translate(string str){
    //cout << str << " -> " << flush;
    stringstream ss;
    
    remove_comment(str);
    smatch match;
    if(regex_match(str, match, regex(PSUEDO))){
        ss << "";
    } else if(regex_match(str, match, regex(LABEL_EXPR))){
        ss << match[1].str() << ":";
    } else if(regex_match(str, match, regex(THREE_ARGS_EXPR)) || regex_match(str, match, regex(TWO_ARGS_EXPR)) || regex_match(str, match, regex(SW_LIKE_EXPR)) || regex_match(str, match, regex(ONE_ARGS_EXPR)) || regex_match(str, match, regex(NO_ARGS_EXPR))){
        instTranslate(str, match, ss);
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