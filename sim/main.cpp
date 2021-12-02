#include <iostream>
#include <fstream>
#include <iomanip>
#include <map>
#include <vector>
#include "Simulator.hpp"
#include "util.hpp"

using std::cout;
using std::endl;

Simulator sim;

bool joke;
bool isasm;

//double start_time, end_time;

void CLI(bool joke){
    if(joke) cout << "\\(^o^)/ ";
    cout << "☆彡OreOre-V Simulator☆彡";
    if(joke) cout << " \\(^o^)/";
    cout << endl << "Type \"help\" to show available commands." << endl;
    bool read_or_eat = true;
    cli_loop:
    while (1)
    {
        cout << ((read_or_eat) ? "(read [assembly] / eat [binary]) " : ((joke)?joking_face():"(sim) "));
        string comm;
        cin >> comm;
        if(comm == "read" && read_or_eat){
            string filename;
            cin >> filename;
            sim.isasm = true;
            int ret = sim.read_asm(filename);
            if(ret < 0) continue;
            else read_or_eat = false;
        }else if(comm == "eat" && read_or_eat){            
            string filename;
            cin >> filename;
            sim.isasm = false;
            int ret = sim.eat_bin(filename);
            if(ret < 0) continue;
            else read_or_eat = false;
        }else if((!read_or_eat) && (comm == "break" || comm == "b")){
            string new_br;
            cin >> new_br;
            int ret = sim.set_brk(new_br);
            if(ret < 0) continue;
            cout << "set breakpoint at " << new_br << "(PC: " << ret << ")" << endl;
        }else if((!read_or_eat) && (comm == "delete" || comm == "d")){
            string new_br;
            cin >> new_br;
            int ret = sim.del_brk(new_br);
            if(ret < 0) continue;
            cout << "deleted breakpoint at " << new_br << "(PC: " << ret << ")" << endl;
        }else if((!read_or_eat) && (comm == "clkbr" || comm == "cb")){
            int new_br;
            cin >> dec >> new_br;
            sim.clk_set_brk(new_br);
            cout << "set breakpoint at " << new_br << endl;
        }else if((!read_or_eat) && (comm == "clkdel" || comm == "cd")){
            int new_br;
            cin >> dec >> new_br;
            sim.clk_del_brk(new_br);
            cout << "deleted breakpoint at " << new_br << endl;
        }else if((!read_or_eat) && (comm == "continue" || comm == "c")){
            cout << "continuing" << endl;
            int ret;
            try
            {
                ret = sim.cont();
            }
            catch(const std::exception& e)
            {
                std::cerr << e.what() << '\n';
                continue;
            }            
            if(ret == 1){
                cout << "Stopped at PC: " << sim.get_pc() << endl;
            }else if(ret == 2){
                cout << "Stopped at Clock: " << sim.get_clock() << endl;
            }else if(ret == 0){
                sim.show_result();
                exit(0);
            }else{
                cout << "Some error occured in the simulator" << endl;
            }
            //start_time = elapsed();
            return;
        }else if((!read_or_eat) && (comm == "run")){
            int ret = -1;
            if(sim.get_pc()) {
                while(1){
                    cout << "Simulation is running." << endl << "Do you really want to restart it from the beginning? (y or n) ";
                    string opt;
                    cin >> opt;
                    if(opt == "y"){
                        cout << "restarting" << endl;try
                        {
                            ret = sim.rerun();
                        }
                        catch(const std::exception& e)
                        {
                            std::cerr << e.what() << '\n';
                            goto cli_loop;
                        }                
                        break;
                    }else if(opt == "n"){
                        break;
                    }
                }
                if(ret < 0) continue;
            }else{
                cout << "running" << endl;
                try
                {
                    ret = sim.run();
                }
                catch(const std::exception& e)
                {
                    std::cerr << e.what() << '\n';
                    continue;
                }                
            }
            if(ret == 1){
                cout << "Stopped at PC: " << sim.get_pc() << endl;
            }else if(ret == 2){
                cout << "Stopped at Clock: " << sim.get_clock() << endl;
            }else if(ret == 0){
                sim.show_result();
                exit(0);
            }else{
                cout << "Some error occured in the simulator" << endl;
            }
        }else if((!read_or_eat) && (comm == "next" || comm == "n")){
            if(sim.step() == 0){
                sim.show_result();
                break;
            }
        }else if((!read_or_eat) && (comm == "reg" || comm == "r")){
            sim.show_reg();
        }else if((!read_or_eat) && comm == "dump"){
            string filename;
            cin >> filename;
            cout << "Writing memory state into " << filename << "..." << endl;
            sim.dump(filename);
        }else if((!read_or_eat) && comm == "mem"){
            int index;
            cin >> hex >> index;
            sim.show_mem(index);
        }else if(cin.eof() || comm == "exit"){
            if(cin.eof())cout << "exit" << endl;
            exit(0);
        }else if((!read_or_eat) && (comm == "pc" || comm == "p")){
            sim.show_pc();
        }else if((!read_or_eat) && (comm == "clk" || comm == "cl")){
            sim.show_clock();
        }else if((!read_or_eat) && (comm == "instr" || comm == "i")){
            sim.show_instruction();
        }else if(comm == "help"){
            cout << "List of commands:" << endl;            
            cout << "help            : Show this help again" << endl;
            if(read_or_eat){
                cout << "read [filename] : read an assembly file" << endl;
                cout << "eat [filename]  : eat a binary file" << endl;
                continue;
            }
            cout << "break [pc/label] (b)      : Set breakpoint at [pc/label]" << endl;
            cout << "clkbr [clock cycle] (cb)  : Set breakpoint at [clock cycle]" << endl;
            cout << "delete [pc/label] (d)     : Delete breakpoint at [pc/label]" << endl;
            cout << "clkdel [clock cycle] (cd) : Delete breakpoint at [clock cycle]" << endl;
            cout << "run             : Run the program from beginning" << endl;
            cout << "continue (c)    : Continue the program" << endl;
            cout << "next (n)        : Execute only one instruction" << endl;
            cout << "reg (r)         : Show registers" << endl;
            cout << "mem [memory index (hexadecimal)]: Show the content of the memory at [memory index]" << endl;
            cout << "dump [filename] : Save memory data to [filename]" << endl;
            cout << "pc (p)          : Show PC" << endl;
            cout << "instr (i)       : Show instruction" << endl;
            cout << "clk (cl)        : Show Clock" << endl;
            cout << "exit            : Quit the program" << endl;  
        }else if(comm == ""){
            continue;
        }
        else{
            if(read_or_eat){
                cout << "You must make ☆彡OreOre-V CPU☆彡 \"read\" assembly or \"eat\" binary!" << endl;
                continue;
            }
            cerr << "Invalid command:" << comm << endl;
            continue;
        }
    } 
    
}

int main(int argc, char* argv[]){
    if(argc > 1){
        if(string(argv[1]) == "-j" || string(argv[1]) == "--joke"){
            joke = true;
        }
    }

    CLI(joke);
}