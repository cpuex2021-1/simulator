#ifndef SIMOBJ_H
#define SIMOBJ_H

#include "../sim/Compiler.hpp"
#include <QObject>

class simObj : public QObject
{
    Q_OBJECT
public:
    explicit simObj(QObject *parent = nullptr);
    Compiler sim;
    string filename;
    string uartinfilename;
    bool needReset;

public slots:
    void run();
    void read();
signals:
    void finished();

private:
};

#endif // SIMOBJ_H
