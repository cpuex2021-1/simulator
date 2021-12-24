#ifndef SIMOBJ_H
#define SIMOBJ_H

#include "../sim/Simulator.hpp"
#include <QObject>

class simObj : public QObject
{
    Q_OBJECT
public:
    explicit simObj(QObject *parent = nullptr);
    Simulator sim;
    string filename;
    string uartinfilename;
    bool needReset;

public Q_SLOTS:
    void run();
    void read();
Q_SIGNALS:
    void finished();

private:
};

#endif // SIMOBJ_H
