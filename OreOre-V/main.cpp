#include "mainwindow.h"

#include <QApplication>
#include <QIcon>

int main(int argc, char *argv[])
{

    QApplication a(argc, argv);
    MainWindow w;
    if(argc > 1){
        w.sobj.filename = string(argv[1]);
        w.sobj.sim.isasm = true;
        emit w.tellSimRead();
    }
    w.show();
    w.setWindowState(Qt::WindowMaximized);
    w.setWindowIcon(QIcon(":/etc/OreOre-V.png"));
    return a.exec();

}
