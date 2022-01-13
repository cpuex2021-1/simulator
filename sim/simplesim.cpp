#include <string>
#include <vector>
#include <algorithm>
#include "Compiler.hpp"

string usage = "Usage:\n\t-a [Assembly file name] : Execute an assembly file \
                      \n\t-b [Binary file name]   : Execute a binary file \
                      \n\t-f                      : Enable JIT Compilation \
                      \n\t-u [Input file name]    : Select UART input file \
                      \n\t-d                      : Show Result in detail";

Compiler sim;

using namespace std;

string getOption(vector<string>& args, const string option){
    auto itr = find(args.begin(), args.end(), option);
    auto end = args.end();
    if (itr != end && ++itr != end){
        return *itr;
    }
    return "";
}

bool optionExists(vector<string>& args, const string option){
    auto itr = find(args.begin(), args.end(), option);
    return itr != args.end();
}

int main(int argc, char* argv[]){

    vector<string> options;

    for(int i=0; i<argc; i++){
        options.push_back(string(argv[i]));
    }

    if(optionExists(options, "--help")){
        cout << usage << endl;
        exit(0);
    }

    if(optionExists(options, "-f")){
        sim.setMode(Simulator::fast);
    }

    if(optionExists(options, "-a")){
        sim.read_asm(getOption(options, "-a"));
    }else if(optionExists(options, "-b")){
        sim.eat_bin(getOption(options, "-b"));
    }else{
        cout << usage << endl;
        exit(0);
    }

    if(optionExists(options, "-u")){
        sim.mem->setup_uart(getOption(options, "-u"));
    }

    try{
        sim.run();
    }catch(exception &e){
        cout << "Error occured at" << endl;
        sim.show_pc();
        sim.show_line();
        sim.show_instruction();
        sim.show_result();
        cerr << "Error: " << e.what() << endl;
        cerr << "Aborting" << endl;
        exit(0);
    }
    
    if(optionExists(options, "-d")){
        sim.show_result();
    }
    sim.show_uart_output();
}