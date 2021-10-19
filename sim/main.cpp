#include <iostream>
#include <fstream>
#include <iomanip>
#include <map>
#include "Simulator.hpp"
#include "util.hpp"

#define MEMSIZE (1 << 25)
#define CACHESIZE (1 << 12)

using namespace std;

Simulator sim(MEMSIZE, CACHESIZE, 0);

map<int,bool> break_pc, break_clk;

void CLI(bool& run){
    run = false;
    while (!run)
    {
        cout << "(sim) ";
        string comm;
        cin >> comm;
        if(comm == "break"){
            int new_br;
            cin >> dec >> new_br;
            break_pc[new_br] = true;
            cout << "set breakpoint at " << new_br << endl;
        }else if(comm == "delete"){
            int new_br;
            cin >> dec >> new_br;
            break_pc[new_br] = false;
            cout << "deleted breakpoint at " << new_br << endl;
        }else if(comm == "clkbr"){
            int new_br;
            cin >> dec >> new_br;
            break_clk[new_br] = true;
            cout << "set breakpoint at " << new_br << endl;
        }else if(comm == "clkdel"){
            int new_br;
            cin >> dec >> new_br;
            break_clk[new_br] = false;
            cout << "deleted breakpoint at " << new_br << endl;
        }else if(comm == "run" || comm == "continue"){
            run = true;
            cout << "running" << endl;
            return;
        }else if(comm == "next"){
            run = false;
            return;
        }else if(comm == "reg"){
            sim.print_register();
        }else if(comm == "dump"){
            string filename;
            cin >> filename;
            sim.mem->print_memory(filename);
        }else if(comm == "mem"){
            int index;
            cin >> hex >> index;
            cout << sim.mem->read_without_cache(index) << endl;
        }else if(cin.eof() || comm == "exit"){
            if(cin.eof())cout << "exit" << endl;
            exit(0);
        }else if(comm == "pc"){
            cout << "PC: " << sim.pc << endl;
        }else if(comm == "clk"){
            cout << "Clock: " << sim.clk << endl;
        }else if(comm == "help"){
            cout << "List of commands:" << endl;
            cout << "help            : Show this help again" << endl;
            cout << "break [pc]      : Set breakpoint at [pc]" << endl;
            cout << "clkbr [clock cycle] : Set breakpoint at [clock cycle]" << endl;
            cout << "delete [pc]     : Delete breakpoint at [pc]" << endl;
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
            cerr << "invalid command:" << comm << endl;
            return;
        }
    } 
    
}

int main(int argc, char* argv[]){
    if(argc < 2){
        cout << "Usage: simulator [binary file] [memory data output file (option)]" << endl;
        exit(0);
    }

    fstream input;
    input.open(string(argv[1]), ios::in | ios::binary);
    int filesize;
    get_filesize(input, filesize);

    unsigned int instr;
    bool run = false;

    cout << "☆彡OreOre-V Simulator☆彡" << endl << "Type \"help\" to show available commands." << endl;

    while(sim.pc < filesize){
        #ifdef DEBUG
        cout << "PC:" << sim.pc << endl << "Instruction:";
        sim.print_register();
        #endif

        if(run == false){
            CLI(run);
        }else if(break_pc[sim.pc]){
            cout << "Stopped at PC " << sim.pc << endl;
            CLI(run);
        }else if(break_clk[sim.clk]){
            cout << "Stopped at clock " << sim.clk << endl;
            CLI(run);
        }

        input.seekg((sim.pc / 4) * sizeof(unsigned int));
        input.read((char *) &instr, sizeof(unsigned int));
        sim.simulate(instr);
        sim.clk++;
        
        #ifdef DEBUG
        cout << endl;
        #endif
    }

    string memfilename = (argc < 4) ? "memResult.txt" : string(argv[4]);
    
    cout << "Result Summary" << endl << "Register:" << endl;
    sim.print_register();
    cout << "Writing memory results into " << memfilename << "..." << endl;
    sim.mem->print_memory(memfilename);
    sim.mem->print_cache_summary();
}