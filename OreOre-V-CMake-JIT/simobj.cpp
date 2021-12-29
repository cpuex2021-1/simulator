#include "simobj.h"
#include <QApplication>
#include <QMessageBox>
#include <sstream>

simObj::simObj(QObject *parent) : QObject(parent)
{
    needReset = false;
}

void simObj::run(){
    QApplication::setOverrideCursor(Qt::WaitCursor);

    if(needReset) sim.reset();

    try{
        int ret = sim.run();
        needReset = (ret == 0) ? true : false;
        QApplication::setOverrideCursor(Qt::ArrowCursor);
    }catch(std::exception &e){
        QApplication::setOverrideCursor(Qt::ArrowCursor);
        stringstream err;
        err << "Error Occured!" << endl << "Error: " << e.what() << endl << "Aborting" << endl;
        QMessageBox errBox;
        errBox.setText(err.str().data());
        errBox.exec();
    }

    Q_EMIT finished();
}

void simObj::read(){
    QApplication::setOverrideCursor(Qt::WaitCursor);
    try{
        sim.read_asm(filename);
        QApplication::setOverrideCursor(Qt::ArrowCursor);
    }catch(std::exception &e){
        QApplication::setOverrideCursor(Qt::ArrowCursor);
        stringstream err;
        err << "Error Occured!" << endl << "Error: " << e.what() << endl << "Aborting" << endl;
        QMessageBox errBox;
        errBox.setText(err.str().data());
        errBox.exec();
    }
    Q_EMIT finished();
}

/*
void simObj::run(){
    if(needReset) sim.reset();
    sim.runFunc();
    needReset = true;
    Q_EMIT finished();
}

void simObj::read(){
    sim.read_asm(filename);
    sim.compileAll();
    Q_EMIT finished();
}*/