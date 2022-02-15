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
: CPU(), break_clk(0), hasclkbrk(false), sectionid(0), funcid(0), mode(accurate), ready(false), uart_ready(false)
{
    isasm = false;
    stop = false;
}

Simulator::~Simulator()
{
}

void Simulator::full_reset(){
    reset();
    Reader::full_reset();
    break_pc = map<int,bool>();
    break_clk = 0;
}

int Simulator::read_asm(string filename){
    isasm = true;
    int ret = Reader::read_asm(filename);
    ready = (ret == 0);
    initProfiler();
    return ret;
}

int Simulator::eat_bin(string filename){
    int ret = Reader::eat_bin(filename);

    if(ret == -1){
        ready = false;
        return ret;
    }
    ready = true;
    isasm = false;
    initProfiler();
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
            cerr << "[ERROR] Label not found : " << bp << endl;
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
            cerr << "[ERROR] Label not found : " << bp << endl;
            return -1;
        }                
    }
    break_pc.erase(bp_pc);
    return bp_pc;
}
void Simulator::clk_set_brk(uint64_t new_br){
    break_clk = new_br;
    hasclkbrk = true;
}
void Simulator::clk_del_brk(){
    hasclkbrk = false;
}
int Simulator::run(){
    int ret = cont();

    updateProfilerResult();
    update_clkcount();
    return ret;
}

int Simulator::rerun(){
    reset();
    return run();
}

int Simulator::cont(){

    #ifndef WINDOWS
    if(signal(SIGINT, handler) == SIG_ERR){
        cerr << "[ERROR] signal init error" << endl;
        exit(1);
    }
    #endif

    if(step()){
        while(pc < instructions.size() / VLIW_SIZE){
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
            }else if(hasclkbrk && break_clk <= numInstruction){
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


int Simulator::step(){
    simulate_acc();
    updateProfilerResult();
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
    mem.print_memory(filename);
}
void Simulator::show_mem(int index){
    mem.read_without_cache(index);
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
    mem.print_cache_summary();
}

void Simulator::show_result(){
    cerr << endl << "Result Summary" << endl << "Clock count: " << get_clock() << \
    "\nEstimated Time: " << get_estimated_time() << "\n\n Statistics\n";
    //show statistics
    stringstream ssstats;
    ssstats << "\tNumber of Instructions:                      \t" << numInstruction << "\n" \
            << "\tNumber of 1 cycle stalls (non-memory-access):\t" << num2stall << "\n" \
            << "\tNumber of 2 cycle stalls (non-memory-access):\t" << num3stall << "\n" \
            << "\tNumber of 3 cycle stalls (non-memory-access):\t" << num4stall << "\n" \
            << "\tNumber of data hazards:                      \t" << numDataHazard << "\n" \
            << "\tNumber of branch prediction miss:            \t" << numFlush << "\n" \
            << "\tNumber of cache miss:                        \t" << mem.totalstall() << "\n";
    ssstats << "\tCache valid rate:                            \t" << mem.getValidRate() << "\n" \
            << "\tCache hit rate:                              \t" << mem.getHitRate()  << "\n" \
            << "\tCache replace rate:                          \t" << mem.getReplaceRate() << endl;
    /* << "Time: " << (end_time - start_time) << endl << */

    cerr << ssstats.str() << endl;
    
    exportToCsv();

    cerr << "Register:" << endl;
    show_reg();
    //cout << "Writing memory state into memResult.txt... " << endl;
    //dump("memResult.txt");
}

uint64_t Simulator::get_clock(){
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
    for(int i=0; i<mem.uart.getOutbufIdx(); i++){
        cout << (char)mem.uart.getOutbuf(i);
    }
    cout << endl;
}

void Simulator::show_line(){
    if(isasm){
        cout << "Line " << pc_to_line(pc) << endl;
    }
}
