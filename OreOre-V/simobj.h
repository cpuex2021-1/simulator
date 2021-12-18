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

public slots:
    void run();
    void read();
signals:
    void finished();

private:
};

#endif // SIMOBJ_H
