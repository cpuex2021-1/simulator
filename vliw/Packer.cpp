#include <string>
#include <regex>
#include <sstream>
#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <queue>

#define PSUEDO "\\.([\\w|\\.|\\-|\\d]+)\\s*([\\w|\\.|\\-|\\d]+)"
#define LABEL_EXPR "([\\w|\\.|\\-|\\d]+):\\s*"
#define THREE_ARGS_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s+([\\w|\\.|\\-|\\d]+)\\s*,\\s*([\\w|\\.|\\-|\\d]+)\\s*,\\s*([\\w|\\.|\\-|\\d]+)\\s*"
#define TWO_ARGS_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s+([\\w|\\.|\\-|\\d]+)\\s*,\\s*([\\w|\\.|\\-|\\d]+)\\s*"
#define ONE_ARGS_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s+([\\w|\\.|\\-|\\d]+)\\s*" 
#define NO_ARGS_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s*"
#define SW_LIKE_EXPR "\\s*([\\w|\\.|\\-|\\d]+)\\s+([\\w|\\.|\\-|\\d]+)\\s*,\\s*([\\-]*\\d+)\\(([\\w|\\.|\\-|\\d]+)\\)\\s*"

using namespace std;

enum {b_j, alu, fpu, uart, ma, nop};

vector<string> types = {"b_j", "alu", "fpu", "uart", "ma", "nop"};

fstream input;
fstream output;

template<typename T>
bool exists(vector<T>& vec, T val){
    return (vec.end() == find(vec.begin(), vec.end(), val));
}

template<typename T>
void add(vector<T>& vec, T val){
    auto pos = find(vec.begin(), vec.end(), val);
    if(pos == vec.end()){
        vec.emplace_back(val);
    }
}

template<typename T>
void del(vector<T>& vec, T val){
    auto pos = find(vec.begin(), vec.end(), val);
    if(pos != vec.end()){
        vec.erase(pos);
    }
}

class InstInfo{
public:
    int id;
    int type;
    string str;
    string opcode;
    string rd;
    bool isMemory;
    string rs1;
    string rs2;
    bool isAnchor;

    vector<int> parent_wawraw;
    vector<int> children_wawraw;
    
    vector<int> parent_war;
    vector<int> children_war;

    bool isAlreadyPacked;

    InstInfo(const InstInfo& i)
    : id(i.id), type(i.type), str(i.str), opcode(i.opcode), rd(i.rd), \
    isMemory(i.isMemory), rs1(i.rs1), rs2(i.rs2), isAnchor(i.isAnchor), isAlreadyPacked(false){
    }


    InstInfo()
    : type(nop), str("nop"), opcode("nop"), isMemory(false), isAnchor(false), isAlreadyPacked(false)
    {}

    InstInfo(int type, string str, string opcode, string rd, bool isMemory, string rs1, string rs2, bool isAnchor)
    : type(type), str(str), opcode(opcode), rd(rd), isMemory(isMemory), rs1(rs1), rs2(rs2), isAnchor(isAnchor)
    {}

    void setAnchor(){
        isAnchor = true;
    }

    bool isfree(){
        return (parent_war.size() == 0 && parent_wawraw.size() == 0);
    }

    void debug_print(){
        cerr << "ID: " << id << "\n";
        cerr << "Type: " << types[type] << "\n";
        cerr << "Opcode: " << opcode << "\n";
        cerr << "rd: " << rd << "\n";
        cerr << "rs1: " << rs1 << "\n";
        cerr << "rs2: " << rs2 << "\n";
        cerr << "war parent: ";
        for(auto i=0; i<parent_war.size(); i++){
            cerr << parent_war[i] << " ";
        }
        cerr << "\n";
        cerr << "wawraw parent: ";
        for(auto i=0; i<parent_wawraw.size(); i++){
            cerr << parent_wawraw[i] << " ";
        }
        cerr << "\n";
    }
};

vector<InstInfo*> insts;

class Pack{
public:
    vector<bool> filled;
    vector<int> instr;
    Pack()
    :filled(4, false), instr(4, -1)
    {}
    string print(){
        string ret = "";
        for(int i=0; i<4; i++){
            if(instr.at(i) == -1) ret += "nop; ";
            else ret = ret + insts.at(instr.at(i))->str + "; ";
        }
        return ret;
    }
    
    void print_debug(){
        string ret = "";
        for(int i=0; i<4; i++){
            if(instr.at(i) == -1) ret += "nop; ";
            else ret = ret + insts.at(instr.at(i))->str + "; ";
        }
        output << ret << endl;        
    }
};
vector<Pack*> packs;

class CodeSection{
private:
    queue<int> freeq;
    queue<int> waitq;
public:
    vector<string> labels;
    bool haslabel;
    int startIdx;
    int endIdx;
    int size;

    int packstartIdx;
    int packendIdx;
    vector<bool> isAlreadyPacked;
    int needToBePackedNum;
    
    void add_instr(InstInfo* i){
        //cerr << "instruction num: " << insts.size() << endl;
        //cerr << "added instruction: " << i->str << endl;
        
        insts.push_back(i);
        size++;
        endIdx++;
        needToBePackedNum++;
        //cerr << "size: " << size << " endIdx: " << endIdx << endl;
    }

    void finalize(){
        for(size_t i=startIdx; i<endIdx; i++){
            insts.at(i)->id = i;
        }
        insts.at(endIdx-1)->isAnchor = true; 
    }

    void setWawRaW();
    void setWar();
    void pack();
    Pack* cwPack(){
        if(packs.size() == 0) packs.push_back(new Pack());
        return packs.at(packs.size() - 1);
    }
    bool fit(int);

    void debug_print(){
        for(auto i=0; i<insts.size(); i++){
            insts[i]->debug_print();
        }
    }

    string print_packs(){
        string ret = "";
        for(size_t i=0; i<labels.size(); i++){
            auto label = labels[i];
            ret += ((label == "")? "" : (label + ":\n"));
        }

        for(size_t i=packstartIdx; i<packendIdx; i++){
            ret += packs.at(i)->print();
            ret += "\n";
        }
        return ret;
    }

    CodeSection()
    : startIdx(insts.size()), endIdx(insts.size()), size(0), needToBePackedNum(0)
    {}
};

vector<CodeSection*> wholecode;

void remove_comment(string& str){
    const auto pos = str.find_first_of('#');
    if(pos != string::npos){
        str = str.substr(0, pos) + "\n";
    }
}


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

InstInfo* checkInfo(string str, smatch& match){
    if(match[1].str() == "add"){
        return new InstInfo(alu, str, match[1].str(), match[2].str(), false, match[3].str(), match[4].str(), false);
    }else if(match[1].str() == "sub"){
        return new InstInfo(alu, str, match[1].str(), match[2].str(), false, match[3].str(), match[4].str(), false);
    }    
    else if(match[1].str() == "fadd"){
        return new InstInfo(fpu, str, match[1].str(), match[2].str(), false, match[3].str(), match[4].str(), false);
    }else if(match[1].str() == "fsub"){
        return new InstInfo(fpu, str, match[1].str(), match[2].str(), false, match[3].str(), match[4].str(), false);
    }else if(match[1].str() == "fmul"){
        return new InstInfo(fpu, str, match[1].str(), match[2].str(), false, match[3].str(), match[4].str(), false);
    }else if(match[1].str() == "fdiv"){
        return new InstInfo(fpu, str, match[1].str(), match[2].str(), false, match[3].str(), match[4].str(), false);          
    }else if(match[1].str() == "fsqrt"){
        return new InstInfo(fpu, str, match[1].str(), match[2].str(), false, match[3].str(), "zero", false);        
    }else if(match[1].str() == "fneg"){
        return new InstInfo(fpu, str, match[1].str(), match[2].str(), false, match[3].str(), "zero", false);           
    }else if(match[1].str() == "fabs"){
        return new InstInfo(fpu, str, match[1].str(), match[2].str(), false, match[3].str(), "zero", false);          
    }else if(match[1].str() == "floor"){
        return new InstInfo(fpu, str, match[1].str(), match[2].str(), false, match[3].str(), "zero", false);
    }            
    else if(match[1].str() == "feq"){
        return new InstInfo(fpu, str, match[1].str(), match[2].str(), false, match[3].str(), match[4].str(), false);
    }else if(match[1].str() == "flt"){
        return new InstInfo(fpu, str, match[1].str(), match[2].str(), false, match[3].str(), match[4].str(), false);
    }else if(match[1].str() == "fle"){
        return new InstInfo(fpu, str, match[1].str(), match[2].str(), false, match[3].str(), match[4].str(), false);
    }else if(match[1].str() == "itof"){
        return new InstInfo(fpu, str, match[1].str(), match[2].str(), false, match[3].str(), "zero", false);            
    }else if(match[1].str() == "ftoi"){
        return new InstInfo(fpu, str, match[1].str(), match[2].str(), false, match[3].str(), "zero", false);              
    }

    else if(match[1].str() == "addi"){
        return new InstInfo(alu, str, match[1].str(), match[2].str(), false, match[3].str(), "zero", false);
    }else if(match[1].str() == "slli"){
        return new InstInfo(alu, str, match[1].str(), match[2].str(), false, match[3].str(), "zero", false);
    }else if(match[1].str() == "srli"){
        return new InstInfo(alu, str, match[1].str(), match[2].str(), false, match[3].str(), "zero", false);
    }
    
    else if(match[1].str() == "lw"){
        if(match[4].str() == "zero" && stoi(match[3].str()) == 0){
            return new InstInfo(uart, str, match[1].str(), match[2].str(), false, "zero", "zero", false); 
        }else{
            return new InstInfo(ma, str, match[1].str(), match[2].str(), true, "zero", match[4].str(), false);
        }
    }else if(match[1].str() == "lui"){
        return new InstInfo(alu, str, match[1].str(), match[2].str(), false, match[3].str(), "zero", false);      
    }

    else if(match[1].str() == "beq"){
        return new InstInfo(b_j, str, match[1].str(), "zero", false, match[2].str(), match[3].str(), true);
    }else if(match[1].str() == "bne"){                
        return new InstInfo(b_j, str, match[1].str(), "zero", false, match[2].str(), match[3].str(), true);
    }else if(match[1].str() == "blt"){
        return new InstInfo(b_j, str, match[1].str(), "zero", false, match[2].str(), match[3].str(), true);
    }else if(match[1].str() == "bge"){                
        return new InstInfo(b_j, str, match[1].str(), "zero", false, match[2].str(), match[3].str(), true);
    }else if(match[1].str() == "bnei"){
        return new InstInfo(b_j, str, match[1].str(), "zero", false, match[2].str(), match[3].str(), true);
                        
    }else if(match[1].str() == "sw"){
        if(match[4].str() == "zero" && stoi(match[3].str()) == 0){
            return new InstInfo(uart, str, match[1].str(), "zero", false, match[2].str(), "zero", false);
        }else{
            return new InstInfo(ma, str, match[1].str(), "zero", true, match[2].str(), match[4].str(), false);
        }
        
    }else if(match[1].str() == "jump"){
        return new InstInfo(b_j, str, match[1].str(), "zero", false, "zero", "zero", true);    
    }else if(match[1].str() == "jumpr"){
        return new InstInfo(b_j, str, match[1].str(), "zero", false, match[2].str(), "zero", true);
    }else if(match[1].str() == "call"){
        return new InstInfo(b_j, str, match[1].str(), "zero", false, "zero", "zero", true);
    }else if(match[1].str() == "callr"){
        return new InstInfo(b_j, str, match[1].str(), "zero", false, match[2].str(), "zero", true);
    }else if(match[1].str() == "ret"){
        return new InstInfo(b_j, str, match[1].str(), "zero", false, "zero", "zero", true);
    }
    
    //psuedo instructions
    else if(match[1].str() == "li"){
        return new InstInfo(alu, str, match[1].str(), match[2].str(), false, "zero", "zero", false);
    }else if(match[1].str() == "lui.float"){
        return new InstInfo(alu, str, match[1].str(), match[2].str(), false, "zero", "zero", false);
        
    }else if(match[1].str() == "addi.float"){
        return new InstInfo(alu, str, match[1].str(), match[2].str(), false, "zero", "zero", false);
        
    }else if(match[1].str() == "lui.label"){
        return new InstInfo(alu, str, match[1].str(), match[2].str(), false, "zero", "zero", false);

    }else if(match[1].str() == "addi.label"){
        return new InstInfo(alu, str, match[1].str(), match[2].str(), false, "zero", "zero", false);
    }else if(match[1].str() == "nop"){
        return new InstInfo(nop, str, match[1].str(), match[2].str(), false, "zero", "zero", false);
    }else{
        cerr << "Unknown Opecode: " << str << endl;
        exit(1);
    }    
}

bool CodeSection::fit(int idx){
    auto& instinfo = *insts.at(idx);
    auto nowpack = cwPack();
    if(instinfo.type == alu || instinfo.type == fpu){
        if(!nowpack->filled[1]){
            nowpack->instr[1] = idx;
            nowpack->filled[1] = true;
            return true;
        }else if(!nowpack->filled[0]){
            nowpack->instr[0] = idx;
            nowpack->filled[0] = true;
            return true;
        }else{
            return false;
        }
    }else if(instinfo.type == b_j){
        if(!nowpack->filled[0] && needToBePackedNum == 1){
            nowpack->instr[0] = idx;
            nowpack->filled[0] = true;
            return true;
        }else{
            return false;
        }
    }else if(instinfo.type == ma){
        if(!nowpack->filled[3]){
            nowpack->instr[3] = idx;
            nowpack->filled[3] = true;
            return true;
        }else if(!nowpack->filled[2]){
            nowpack->instr[2] = idx;
            nowpack->filled[2] = true;
            return true;
        }else{
            return false;
        }
    }else if(instinfo.type == uart){
        if(!nowpack->filled[2]){
            nowpack->instr[2] = idx;
            nowpack->filled[2] = true;
            return true;
        }else{
            return false;
        }
    }else if(instinfo.type == nop){
        return true;
    }else{
        cerr << "Type matching failed while packing" << endl;
        exit(1);
    }    
}

CodeSection* cs;

void CodeSection::pack(){
    //waitq: queue for whole section
    //freeq: queue for one vliw pack

    packstartIdx = packs.size();
    packendIdx = packs.size();

    for(size_t i=startIdx; i<endIdx; i++){
        if(insts.at(i)->isfree()){
            waitq.push(i);
        }
    }

    while(!waitq.empty()){
        //push into freeq
        while(!waitq.empty()){
            freeq.push(waitq.front());
            waitq.pop();
        }

        vector<int> packedIdx(0);

        while(!freeq.empty()){        
            auto instIdx = freeq.front();
            freeq.pop();
            
            //fetch instruction
            auto& instinfo = *insts.at(instIdx);

            //fit instruction
            if(!instinfo.isAlreadyPacked){
                if(fit(instIdx)){
                    //update war relations
                    for(size_t i=0; i<instinfo.children_war.size(); i++){
                        auto chldidx = instinfo.children_war.at(i);
                        auto& chld = *insts.at(chldidx);
                        del(chld.parent_war, instIdx);
                        if(chld.isfree()){
                            freeq.push(chldidx);
                        }                        
                    }
                    instinfo.isAlreadyPacked = true;
                    needToBePackedNum--;
                    packedIdx.push_back(instIdx);
                }else{
                    waitq.push(instIdx);
                }
            }
        }

        cwPack()->print_debug();
        packs.push_back(new Pack());
        packendIdx++;

        for(size_t i=0; i<packedIdx.size(); i++){
            auto& packedinst = *insts.at(packedIdx.at(i));
            for(size_t j=0; j<packedinst.children_wawraw.size(); j++){
                auto chldidx = packedinst.children_wawraw.at(j);
                auto& chld = *insts.at(chldidx);
                del(chld.parent_wawraw, packedinst.id);
                if(chld.isfree()){
                    waitq.push(chldidx);
                }
            }
        }
    }
}


void translate(string str){
    remove_comment(str);
    smatch match;

    //cerr << "Reading: " << str << endl;

    if(regex_match(str, match, regex(PSUEDO))){
    } else if(regex_match(str, match, regex(LABEL_EXPR))){
        if(cs->size == 0){
            cs->labels.push_back(match[1].str());
            cerr << "added label: " << match[1].str() << endl;
        }else{
            //cerr << "found Anchor" << endl;
            //cerr << "found label: " << str << endl << "finalize code section, size " << cs->size << endl;
            cs->finalize();
            wholecode.push_back(cs);
            cs = new CodeSection();
            cs->labels.push_back(match[1].str());
            cerr << "added label: " << match[1].str() << endl;
        }
    } else if(regex_match(str, match, regex(THREE_ARGS_EXPR)) || regex_match(str, match, regex(TWO_ARGS_EXPR)) || regex_match(str, match, regex(SW_LIKE_EXPR)) || regex_match(str, match, regex(ONE_ARGS_EXPR)) || regex_match(str, match, regex(NO_ARGS_EXPR))){
        auto info = checkInfo(str, match);
        cs->add_instr(info);
        if(info->isAnchor){
            //cerr << "found Anchor" << endl;
            cs->finalize();
            wholecode.push_back(cs);
            cs = new CodeSection();
        }
    } else if(regex_match(str, match, regex("\\s*"))){
    } else {
        cerr << "Match Error" << endl;
        exit(1);
    }
}

void resolveDependensies(){
    cerr << "Whole section size: " << wholecode.size() << endl;
    for(size_t i=0; i<wholecode.size(); i++){
        cerr << "\rresolving section " << i << "          " << flush;
        wholecode[i]->setWawRaW();
        wholecode[i]->setWar();
    }
    cerr << endl;
}

void pack(){
    for(size_t i=0; i<wholecode.size(); i++){
        for(size_t j=0; j<wholecode[i]->labels.size();j++){
            if(wholecode[i]->labels[j] != "") output << wholecode[i]->labels[j] << ":" << endl;
        }
        wholecode[i]->pack();
    }
}

void singleWaW(InstInfo* par, InstInfo* chld){
        //cerr << "checking waw: " << par->str << " -> " << chld->str << endl;
    if(par->rd != "zero" && (par->rd == chld->rd)){
        add(par->children_wawraw, chld->id);
        add(chld->parent_wawraw, par->id);
        //cerr << "found waw: " << par->str << " -> " << chld->str << endl;
    }
}

void singleRaW(InstInfo* par, InstInfo* chld){
        //cerr << "checking raw: " << par->str << " -> " << chld->str << endl;
    if(par->rd != "zero" && (par->rd == chld->rs1 || par->rd == chld->rs2)){
        add(par->children_wawraw, chld->id);
        add(chld->parent_wawraw, par->id);
        //cerr << "found raw: " << par->str << " -> " << chld->str << endl;
    }
}

void singleWaR(InstInfo* par, InstInfo* chld){
        //cerr << "checking war: " << par->str << " -> " << chld->str << endl;
    if(chld->rd != "zero" && (chld->rd == par->rs1 || chld->rd == par->rs2)){
        add(par->children_war, chld->id);
        add(chld->parent_war, par->id);
        //cerr << "found war: " << par->str << " -> " << chld->str << endl;
    }
}

void CodeSection::setWawRaW(){
    for(size_t i=startIdx; i<endIdx-1; i++){
        for(size_t j=i+1; j<endIdx; j++){
            singleWaW(insts.at(i), insts.at(j));
            singleRaW(insts.at(i), insts.at(j));
        }
    }
}

void CodeSection::setWar(){
    for(size_t i=startIdx; i<endIdx-1; i++){
        for(size_t j=i+1; j<endIdx; j++){
            singleWaR(insts.at(i), insts.at(j));
        }
    }
}

int main(int argc, char* argv[]){
    
    if(argc < 3) {
        cerr << "Usage: assembler [input file] [output file]" << endl;
        exit(1);
    }

    string infile(argv[1]);
    string outfile(argv[2]);

    ifstream test(infile); 
    if (!test)
    {
        std::cerr << "[ERROR] The file \"" << infile << "\" doesn't exist" << std::endl;
        return -1;
    }

    input.open(infile, ios::in);
    output.open(outfile, ios::out);
    
    string str;
    cs = new CodeSection(); 

    cerr << "init complete" << endl;

    while (getline(input, str))
    {
        //store information
        translate(str);
    }

    //resolve dependensies
    resolveDependensies();

    /*
    cerr << "Whole section size: " << wholecode.size() << endl;
    for(size_t i=0; i<wholecode.size(); i++){
        cerr << "Section Summary: " << i << endl;
        wholecode.at(i)->debug_print();
    }
    */

    //pack into vliw codes
    cerr << "Packing" << endl;
    pack();

    /*
    //write into output files
    for(size_t i=0; i<wholecode.size(); i++){
        output << wholecode.at(i)->print_packs() << flush;
    }*/
}