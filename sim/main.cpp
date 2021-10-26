#include <iostream>
#include <fstream>
#include <iomanip>
#include <map>
#include <vector>
#include "Simulator.hpp"
#include "util.hpp"
#include "../asm/Instructions.hpp"

#define MEMSIZE (1 << 25)
#define CACHESIZE (1 << 12)

using namespace std;

Simulator sim(MEMSIZE, CACHESIZE, 0);

map<int,bool> break_pc;
vector<unsigned long long> break_clk;
vector<int> instructions;

bool joke;

void CLI(bool& run, bool read_or_eat){
    run = false;
    while (!run)
    {
        cout << ((read_or_eat) ? "(read [assembly] / eat [binary]) " : ((joke)?joking_face():"(sim) "));
        string comm;
        cin >> comm;
        if(comm == "read" && read_or_eat){
            string filename;
            cin >> filename;
            std::ifstream test(filename); 
            if (!test)
            {
                std::cout << "The file \"" << filename << "\" doesn't exist" << std::endl;
                continue;
            }
            cout << "Reading " << filename << "...";
            setup(instructions, labels, filename, true);
            cout << " complete!" << endl;
            break;
        }else if(comm == "eat" && read_or_eat){            
            string filename;
            cin >> filename;
            std::ifstream test(filename); 
            if (!test)
            {
                std::cout << "The file \"" << filename << "\" doesn't exist" << std::endl;
                continue;
            }
            cout << "Eating " << filename << "...";
            setup(instructions, labels, filename, false);
            cout << " complete!" << endl;
            break;
        }else if((!read_or_eat) && comm == "break"){
            string new_br;
            cin >> new_br;
            int new_br_pc;
            try
            {
                new_br_pc = stoi(new_br);
            }
            catch(std::invalid_argument& e)
            {
                try
                {
                    new_br_pc = labels.at(new_br);
                }
                catch(std::out_of_range& e)
                {
                    cerr << "Label not found : " << new_br << endl;
                    continue;
                }                
            }

            break_pc[new_br_pc] = true;
            cout << "set breakpoint at " << new_br << "(PC: " << new_br_pc << ")" << endl;
        }else if((!read_or_eat) && comm == "delete"){
            string new_br;
            cin >> new_br;
            int new_br_pc;
            try
            {
                new_br_pc = stoi(new_br);
            }
            catch(std::invalid_argument& e)
            {
                try
                {
                    new_br_pc = labels.at(new_br);
                }
                catch(std::out_of_range& e)
                {
                    cerr << "Label not found : " << new_br << endl;
                    continue;
                }                
            }
            break_pc.erase(new_br_pc);
            cout << "deleted breakpoint at " << new_br << "(PC: " << new_br_pc << ")" << endl;
        }else if((!read_or_eat) && comm == "clkbr"){
            int new_br;
            cin >> dec >> new_br;
            break_clk.push_back(new_br);
            sort(break_clk.begin(), break_clk.end());
            cout << "set breakpoint at " << new_br << endl;
        }else if((!read_or_eat) && comm == "clkdel"){
            int new_br;
            cin >> dec >> new_br;
            break_clk.erase(find(break_clk.begin(), break_clk.end(), new_br));
            cout << "deleted breakpoint at " << new_br << endl;
        }else if((!read_or_eat) && (comm == "run" || comm == "continue")){
            run = true;
            cout << "running" << endl;
            return;
        }else if((!read_or_eat) && comm == "next"){
            run = false;
            return;
        }else if((!read_or_eat) && comm == "reg"){
            sim.print_register();
        }else if((!read_or_eat) && comm == "dump"){
            string filename;
            cin >> filename;
            cout << "Writing memory state into " << filename << "..." << endl;
            sim.mem->print_memory(filename);
        }else if((!read_or_eat) && comm == "mem"){
            int index;
            cin >> hex >> index;
            cout << sim.mem->read_without_cache(index) << endl;
        }else if(cin.eof() || comm == "exit"){
            if(cin.eof())cout << "exit" << endl;
            exit(0);
        }else if((!read_or_eat) && comm == "pc"){
            cout << "PC: " << sim.pc << endl;
        }else if((!read_or_eat) && comm == "clk"){
            cout << "Clock: " << sim.clk << endl;
        }else if((!read_or_eat) && comm == "instr"){
            cout << "Instruction: "; print_instr(instructions[sim.pc/4]);
        }else if(comm == "help"){
            cout << "List of commands:" << endl;            
            cout << "help            : Show this help again" << endl;
            if(read_or_eat){
                cout << "read [filename] : read an assembly file" << endl;
                cout << "eat [filename]  : eat a binary file" << endl;
                continue;
            }
            cout << "break [pc/label]     : Set breakpoint at [pc/label]" << endl;
            cout << "clkbr [clock cycle]  : Set breakpoint at [clock cycle]" << endl;
            cout << "delete [pc/label]    : Delete breakpoint at [pc/label]" << endl;
            cout << "clkdel [clock cycle] : Delete breakpoint at [clock cycle]" << endl;
            cout << "run             : Run the program" << endl;
            cout << "continue        : Continue the program" << endl;
            cout << "next            : Execute only one instruction" << endl;
            cout << "reg             : Show registers" << endl;
            cout << "mem [memory index (hexadecimal)]: Show the content of the memory at [memory index]" << endl;
            cout << "dump [filename] : Save memory data to [filename]" << endl;
            cout << "pc              : Show PC" << endl;
            cout << "clk             : Show Clock" << endl;
            cout << "exit            : Quit the program" << endl;  
        }else if(comm == ""){
            continue;
        }
        else{
            if(read_or_eat){
                cout << "You must make ☆彡OreOre-V Simulator☆彡 \"read\" assembly or \"eat\" binary!" << endl;
                continue;
            }
            cerr << "Invalid command:" << comm << endl;
            return;
        }
    } 
    
}

int main(int argc, char* argv[]){
    if(argc > 1){
        if(string(argv[1]) == "-j" || string(argv[1]) == "--joke"){
            joke = true;
        }
    }
    if(joke) cout << "\\(^o^)/ ";
    cout << "☆彡OreOre-V Simulator☆彡";
    if(joke) cout << " \\(^o^)/";
    cout << endl << "Type \"help\" to show available commands." << endl;


    bool run = false;

    CLI(run, true);

    if(instructions.size() <= 0){
        exit(1);
    }

    
    while(sim.pc < instructions.size()){
        #ifdef DEBUG
        cout << "PC:" << sim.pc << endl << "Instruction:";
        sim.print_register();
        #endif

        if(run == false){
            CLI(run, false);
        }else if(break_pc.size() != 0 && break_pc[sim.pc]){
            cout << "Stopped at PC " << sim.pc << endl;
            CLI(run, false);
        }else if(break_clk.size() != 0 && break_clk[0] == sim.clk){
            cout << "Stopped at clock " << sim.clk << endl;
            break_clk.erase(break_clk.begin());
            CLI(run, false);
        }
        sim.simulate(instructions[sim.pc]);
        sim.clk++;
        
        #ifdef DEBUG
        cout << endl;
        #endif
    }

    if(true){
        string memfilename = (argc < 4) ? "memResult.txt" : string(argv[4]);
        
        cout << endl << "Result Summary" << endl << "Clock count: " << sim.clk << endl << "Register:" << endl;
        sim.print_register();
        cout << "Writing memory results into " << memfilename << "..." << endl;
        sim.mem->print_memory(memfilename);
        sim.mem->print_cache_summary();
    }
}