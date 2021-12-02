#include "mainwindow.h"

#include <QApplication>
#include <QIcon>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    w.setWindowState(Qt::WindowMaximized);
    w.setWindowIcon(QIcon(":/etc/OreOre-V.png"));
    return a.exec();

}
