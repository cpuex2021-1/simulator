#include <iostream>
#include <fstream>

using namespace std;

int main(int argc, char* argv[]){
    if(argc < 2){
        cout << "Usage: simulator [binary file]" << endl;
    }

    fstream input;
    input.open(string(argv[1]), ios::in | ios::binary);

    unsigned int instr;
    int pc;

    while(1){
        input.seekg(pc / 4 * sizeof(unsigned int));
        input.read((char *) &instr, sizeof(unsigned int));       

        
    }
    
}