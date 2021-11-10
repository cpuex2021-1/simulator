#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "../sim/Simulator.hpp"

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

    void on_address_textChanged(const QString &arg1);

    void on_Instructions_cellClicked(int row, int column);

    void on_pushButton_released();

    void on_pushButton_2_released();

    void on_pushButton_3_clicked();

private:
    Ui::MainWindow *ui;
    void SetTableWidth();
    void resizeEvent(QResizeEvent* event);
    void SetUpSim();
    void refreshRegView();
    void refreshMemView();
    void refreshInstView();
    void refreshAll();
    Simulator sim;
    int mem_adder;
    int inst_line;
    bool isReghex;
};
#endif // MAINWINDOW_H
