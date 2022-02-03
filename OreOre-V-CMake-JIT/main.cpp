#include "mainwindow.h"

#include <QApplication>
#include <QIcon>
#include <vector>
#include <algorithm>


string usage = "Usage:\n\t-a [Assembly file name] : Execute an assembly file \
                      \n\t-b [Binary file name]   : Execute a binary file \
                      \n\t-u [Input file name]    : Select UART input file";

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

int main(int argc, char *argv[])
{

    QApplication a(argc, argv);
    MainWindow w;
    if(argc > 1){
        vector<string> options;
        for(int i=0; i<argc; i++){
            options.push_back(string(argv[i]));
        }

        if(optionExists(options, "--help")){
            cout << usage << endl;
            exit(0);
        }

        if(optionExists(options, "-a")){
            w.sobj.sim.read_asm(getOption(options, "-a"));
        }else if(optionExists(options, "-b")){
            w.sobj.sim.eat_bin(getOption(options, "-b"));
        }else{
            cout << usage << endl;
            exit(0);
        }

        if(optionExists(options, "-u")){
            w.sobj.sim.mem.setup_uart(getOption(options, "-u"));
        }

    }
    w.show();
    w.setWindowState(Qt::WindowMaximized);
    w.setWindowIcon(QIcon(":/etc/OreOre-V.png"));
    return a.exec();

}
