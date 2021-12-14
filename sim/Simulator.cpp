#include "Simulator.hpp"

using std::cout;
using std::cerr;
using std::endl;
using std::string;
using std::map;

Simulator::Simulator() 
: CPU(), sectionid(0), funcid(0), mode(accurate), ready(false), uart_ready(false)
{
    isasm = false;
}

Simulator::~Simulator()
{
}

void Simulator::full_reset(){
    reset();
    instructions = vector<int>();
    l_to_p = vector<int>();
    p_to_l = vector<int>();
    break_pc = map<int,bool>();
    break_clk = vector<unsigned long long>();
    str_instr = vector<string>();
}

int Simulator::read_asm(string filename){
    std::ifstream test(filename); 
    if (!test)
    {
        std::cout << "The file \"" << filename << "\" doesn't exist" << std::endl;
        return -1;
    }
    cout << "Reading " << filename << "...";
    setup(filename, true);
    isasm = true;
    if(instructions.size() <= 0){
        ready = false;
        return -1;
    }
    ready = true;
    cout << " complete!" << endl;
    return 0;
}
int Simulator::eat_bin(string filename){
    std::ifstream test(filename); 
    if (!test)
    {
        std::cout << "The file \"" << filename << "\" doesn't exist" << std::endl;
        return -1;
    }
    cout << "Eating " << filename << "...";
    setup(filename, false);
    if(instructions.size() <= 0){
        ready = false;
        return -1;
    }
    ready = true;
    cout << " complete!" << endl;
    isasm = false;
    return 0;
}
int Simulator::set_brk(string bp){
    int bp_pc;
    try
    {
        bp_pc = stoi(bp);
    }
    catch(std::invalid_argument& e)
    {
        try
        {
            bp_pc = labels.at(bp);
        }
        catch(std::out_of_range& e)
        {
            cerr << "Label not found : " << bp << endl;
            return -1;
        }                
    }
    break_pc[bp_pc] = true;
    return bp_pc;
}
int Simulator::del_brk(string bp){
    int bp_pc;
    try
    {
        bp_pc = stoi(bp);
    }
    catch(std::invalid_argument& e)
    {
        try
        {
            bp_pc = labels.at(bp);
        }
        catch(std::out_of_range& e)
        {
            cerr << "Label not found : " << bp << endl;
            return -1;
        }                
    }
    break_pc.erase(bp_pc);
    return bp_pc;
}
void Simulator::clk_set_brk(int new_br){
    break_clk.push_back(new_br);
    sort(break_clk.begin(), break_clk.end());
}
void Simulator::clk_del_brk(int new_br){
    break_clk.erase(find(break_clk.begin(), break_clk.end(), new_br));
}
int Simulator::run(){
    return cont();
}

int Simulator::rerun(){
    reset();
    return cont();
}
int Simulator::cont_fast(){
    if(step()){
        while(pc < instructions.size()){
            #ifdef DEBUG
            cout << "PC:" << pc << endl << "Instruction:";
            print_register();
            #endif

            if(break_pc.size() != 0 && break_pc[pc]){
                return 1;
            }else if(break_clk.size() != 0 && break_clk[0] <= clk){
                clk_del_brk(break_clk[0]);
                return 2;
            }
            
            simulate_fast();
            
            #ifdef DEBUG
            cout << endl;
            #endif
        }
    }
    return 0;
}

int Simulator::cont_acc(){
    if(step()){
        while(pc < instructions.size()){
            #ifdef DEBUG
            cout << "PC:" << pc << endl << "Instruction:";
            print_register();
            #endif

            if(break_pc.size() != 0 && break_pc[pc]){
                return 1;
            }else if(break_clk.size() != 0 && break_clk[0] <= clk){
                clk_del_brk(break_clk[0]);
                return 2;
            }

            simulate_acc();
            
            #ifdef DEBUG
            cout << endl;
            #endif
        }
    }
    return 0;
}

int Simulator::cont(){
    if(mode == accurate) return cont_acc();
    else if(mode == fast) return cont_fast();
    else return -1;
}

int Simulator::step(){
    if(mode == accurate) simulate_acc();
    else if(mode == fast) simulate_fast();
    if(pc >= instructions.size()){
        return 0;
    }else{
        return 1;
    }

}
void Simulator::show_reg(){
    print_register();
}
void Simulator::dump(string filename){
    mem->print_memory(filename);
}
void Simulator::show_mem(int index){
    mem->read_without_cache(index);
}
void Simulator::show_pc(){
    cout << "PC: " << pc << endl;
}
void Simulator::show_clock(){
    cout << "Clock: " << clk << endl;
}
void Simulator::show_instruction(){
    if(isasm){
        cout << "Instruction (Assembly): " << str_instr[pc] << endl;        
        cout << "Instruction (Binary): "; print_instr(instructions[p_to_l[pc]]);
    }else{
        cout << "Instruction (Binary): "; print_instr(instructions[p_to_l[pc]]);
    }
}
void Simulator::show_cache(){
    mem->print_cache_summary();
}

void Simulator::show_result(){
    cout << endl << "Result Summary" << endl << "Clock count: " << get_clock() << endl;
    /* << "Time: " << (end_time - start_time) << endl << */
    cout << "Register:" << endl;
    show_reg();
    //cout << "Writing memory state into memResult.txt... " << endl;
    //dump("memResult.txt");
    show_cache();
}

int Simulator::get_clock(){
    return clk;
}
int Simulator::get_pc(){
    return pc;
}

int Simulator::brk_unified(int bp){
    if(break_pc[bp]){
        del_brk(to_string(bp));
        return 0;
    }else{
        set_brk(to_string(bp));
        return 1;
    }
}

int Simulator::line_to_pc(int l){
    if(l < 0) return 0;
    else if(l >= (int)l_to_p.size()){
        return l_to_p.at(l_to_p.size() - 1);
    }else{
        return l_to_p.at(l);
    }
}

int Simulator::pc_to_line(int pc){
    if(pc < 0) return 0;
    else if(pc >= (int)p_to_l.size()){
        return p_to_l.at(p_to_l.size()-1);
    }else{
        return p_to_l.at(pc);
    }
}

bool Simulator::isbrk(int pc){
    return break_pc[pc];
}

vector<string> stages = {
    "IF",
    "Dec & RF",
    "ALU + MA",
    "WB"
};

bool Simulator::getPipelineInfoByLineNum(int l, string& s, bool& flushed){
    vector<pinfo> P(PIPELINE_STAGES);
    getPipelineInfo(P);
    for(int i=0; i<PIPELINE_STAGES; i++){
        if(P[i].pc == line_to_pc(l) && pc_to_line(line_to_pc(l)) == l){
            s = stages[i];
            flushed = P[i].flushed;
            return true;
        }
    }
    return false;
}

void Simulator::setMode(int m){
    mode = m;
}

void Simulator::setup(string filename, bool isasm){
    fstream input;
    input.open(filename, ios::in);
    if(isasm){
        int now_addr = 2;
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
            }else if(pres.type == none){
                line_num++;
            }else if(pres.type == instruction){
                line_num++;
                now_addr += pres.size;
            }
        }
        input.close();
        input.open(filename, ios::in);

        stringstream init_ra_str1;
        init_ra_str1 << "\tlui ra, " << ((now_addr) >> 12);

        stringstream init_ra_str2;
        init_ra_str2 << "\taddi ra, ra, " << ((now_addr) & ((1 << 12) - 1));

        str_instr.push_back(init_ra_str1.str());
        str_instr.push_back(init_ra_str2.str());
        
        Parse init_ra1(init_ra_str1.str(), false, 0);
        Parse init_ra2(init_ra_str2.str(), false, 0);

        line_num = 1;
        now_addr = 0;

        l_to_p.push_back(now_addr);
        p_to_l.push_back(line_num - 1);
        instructions.push_back(init_ra1.codes[0]);
        line_num++;
        now_addr++;

        l_to_p.push_back(now_addr);
        p_to_l.push_back(line_num - 1);
        instructions.push_back(init_ra2.codes[0]);
        line_num++;
        now_addr++;

        while(getline(input, str)){
            str_instr.push_back(str);
            #ifdef DEBUG
            cout << "line:" << line_num << " ";
            Debug_parse(str);
            #endif
            l_to_p.push_back(now_addr);
            Parse pres(str, false, now_addr);
            if(pres.type == instruction){
                #ifdef DEBUG
                pres.print_instr();
                #endif
                for(unsigned int i=0; i<pres.codes.size(); i++){
                    instructions.push_back(pres.codes[i]);
                    p_to_l.push_back(line_num - 1);
                    now_addr += 1;
                }
                line_num++;
            }else if(pres.type == none || pres.type == label){
                line_num++;
            }else if(pres.type == error){
                cerr << "Parsing Error at line " << line_num << endl;
                exit(1);
            }
        }

        //instructions.pop_back();
        //instructions.push_back(0);
        
    }else{
        int code;
        input.read((char *) &code, sizeof(unsigned int));
        while(input.read((char *) &code, sizeof(unsigned int))){
            instructions.push_back(code);
        }
    }
    input.close();
}

int Simulator::getNewSectionId(){
    sectionid++;
    return sectionid;
}
int Simulator::getNewFuncId(){
    funcid++;
    return funcid;
}

