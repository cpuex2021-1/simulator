#include "Simulator.hpp"

#ifndef WINDOWS
#include <sys/signal.h>
#endif

using std::cout;
using std::cerr;
using std::endl;
using std::string;
using std::map;

bool stop;

void handler(int signum){
    stop = true;
}

Simulator::Simulator() 
: CPU(), sectionid(0), funcid(0), mode(accurate), ready(false), uart_ready(false)
{
    isasm = false;
    stop = false;
}

Simulator::~Simulator()
{
}

void Simulator::full_reset(){
    reset();
    Assembler::full_reset();
    break_pc = map<int,bool>();
    break_clk = vector<unsigned long long>();
}

int Simulator::read_asm(string filename){
    isasm = true;
    int ret = Assembler::read_asm(filename);
    ready = (ret == 0);
    return ret;
}

int Simulator::eat_bin(string filename){
    int ret = Assembler::eat_bin(filename);

    if(ret == -1){
        ready = false;
        return ret;
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

//currently not supported
int Simulator::cont_fast(){
    /*
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
    }*/
    return 0;
}

int Simulator::cont_acc(){

    #ifndef WINDOWS
    if(signal(SIGINT, handler) == SIG_ERR){
        cerr << "signal init error" << endl;
        exit(1);
    }
    #endif

    if(step()){
        while(pc < instructions.size()){
            #ifdef DEBUG
            cout << "PC:" << pc << endl << "Instruction:";
            print_register();
            #endif
            if(stop){
                stop = false;
                throw runtime_error("SIGINT by User");
            }

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
        update_clkcount();
    }
    return 0;
}

int Simulator::cont(){
    if(mode == Simulator::accurate) return cont_acc();
    else if(mode == Simulator::fast) return cont_fast();
    else return -1;
}

int Simulator::step(){
    if(mode == Simulator::accurate) simulate_acc();
    else if(mode == Simulator::fast) simulate_fast();
    
    update_clkcount();
    
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
    cout << "PC " << pc << endl;
}
void Simulator::show_clock(){
    cout << "Clock: " << clk << endl;
}
void Simulator::show_instruction(){
    cout << get_string_instruction_by_line(pc_to_line(pc)) << endl;
}

string Simulator::get_string_instruction_by_line(int l){
    if(isasm){
        return str_instr.at(line_to_pc(l));
    }else{
        return disassemble(instructions.at(line_to_pc(l)));
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

void Simulator::setMode(Mode m){
    mode = m;
}

int Simulator::getNewSectionId(){
    sectionid++;
    return sectionid;
}
int Simulator::getNewFuncId(){
    funcid++;
    return funcid;
}

void Simulator::show_uart_output(){
    for(int i=0; i<mem->uart.getOutbufIdx(); i++){
        cout << (char)mem->uart.getOutbuf(i);
    }
    cout << endl;
}

void Simulator::show_line(){
    if(isasm){
        cout << "Line " << pc_to_line(pc) << endl;
    }
}