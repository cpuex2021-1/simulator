#include <string>
#include <fstream>
#include <iostream>

using namespace std;

class SLD
{
private:
    fstream in;
    fstream out;

    int read_int(){
        int32_t n;
        in >> n;
        out.write(reinterpret_cast<char *>(&n), sizeof(n));
        return n;
    }
    float read_float(){
        float n;
        in >> n;
        out.write(reinterpret_cast<char *>(&n), sizeof(n));
        return n;
    }
    void read_vec3(){
        for(int i=0; i<3; i++){
            read_float();
        }
    }
    void read_sld_env(){
        //screen pos
        read_vec3();
        //screen rotation
        read_float();
        read_float();
        //n_lights : Actually, it should be an int value !
        read_float();
        //light rotation
        read_float();
        read_float();
        //beam
        read_float();
    }
    void read_objects(){
        while(read_int() != -1){
            //form
            read_int();
            //refltype
            read_int();
            //isrot_p
            int is_rot = read_int();
            //abc
            read_vec3();
            //xyz
            read_vec3();
            //is_invert
            read_float();
            //refl_param
            read_float();
            read_float();
            //color
            read_vec3();
            //rot
            if(is_rot != 0){
                read_vec3();
            }
        }
    }
    void read_and_network(){
        while(read_int() != -1){
            while(read_int() != -1);
        }
    }
    void read_or_network(){
        while(read_int() != -1){
            while(read_int() != -1);
        }
    }

    void existCheck(string filename){
        ifstream test(filename);
        if(!test){
            std::cout << "The file \"" << filename << "\" doesn't exist" << std::endl;
            exit(1);
        }
    }

public:
    SLD(string infile, string outfile)
    {
        existCheck(infile);
        in.open(infile, ios::in);
        out.open(outfile, ios::out | ios::binary);
    }

    void read(){
        read_sld_env();
        read_objects();
        read_and_network();
        read_or_network();
    }
};

int main(int argc, char* argv[]){

    if(argc != 3){
        cerr << "Usage: sld-converter [input file] [output file]" << endl;
        exit(0);
    }

    SLD sld(argv[1], argv[2]);
    sld.read();
    return 0;
}