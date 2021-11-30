#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QThread>
#include "../sim/Simulator.hpp"
#include "simobj.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_pushButton_7_released();

    void on_pushButton_8_released();

    void on_pushButton_9_released();

    void on_Instructions_cellClicked(int row, int column);

    void on_pushButton_released();

    void on_pushButton_2_released();

    void on_pushButton_3_clicked();

    void refreshAll();

    void on_InstLinespinBox_valueChanged(int arg1);

    void on_verticalScrollBar_valueChanged(int value);

    void on_MemScrollBar_valueChanged(int value);

    void on_address_valueChanged(int arg1);

    void on_ClockSpin_editingFinished();

    void on_pushButton_5_released();

    void on_memUpButton_released();

    void on_memDownButton_released();

    void on_SimulatorModeButton_released();

    void on_revertButton_released();

    void on_uartInputButton_released();

    void on_uartOutputButton_released();

    void on_uartSetupButton_released();

private:
    Ui::MainWindow *ui;
    QThread simThread;
    void SetTableWidth();
    void resizeEvent(QResizeEvent* event);
    void refreshRegView();
    void refreshMemView();
    void refreshInstView();
    int mem_addr;
    int inst_line;
    bool isReghex;
    bool running;
    simObj sobj;

signals:
    void tellSimRun();
    void tellSimRead();
};
#endif // MAINWINDOW_H
