#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <string>
#include <stdlib.h>
#include <QFileDialog>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
    , mem_addr(0)
    , inst_line(0)
    , isReghex(false)
{
    ui->setupUi(this);
    ui->RegTable->verticalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    ui->MemTable->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    ui->Instructions->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    ui->RegTable->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->MemTable->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->Instructions->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->Instructions->setSelectionMode(QAbstractItemView::NoSelection);

    simObj* simt = new simObj;
    simt->moveToThread(&simThread);
    connect(&sobj, &simObj::finished, this, &MainWindow::refreshAll);
    connect(this, &MainWindow::tellSimRead, &sobj, &simObj::read);
    connect(this, &MainWindow::tellSimRun, &sobj, &simObj::run);
    simThread.start();
}

MainWindow::~MainWindow()
{
    delete ui;
    simThread.quit();
    simThread.wait();
}

void MainWindow::SetTableWidth(){
    auto& RegT = ui->RegTable;
    auto& MemT = ui->MemTable;
    auto& InstT = ui->Instructions;
    for(int i=0; i<RegT->columnCount(); i++){
        if(i % 2 == 0){
            RegT->setColumnWidth(i, (RegT->width() / RegT->columnCount()) * 0.5);
        }
        else{
            RegT->setColumnWidth(i, (RegT->width() / RegT->columnCount()) * 1.5);
        }
    }
    while(MemT->rowCount()*MemT->rowHeight(0) < MemT->height() * 2){
        MemT->setRowCount(MemT->rowCount() + 1);
    }
    while(MemT->rowCount()*MemT->rowHeight(0) > MemT->height() * 2){
        MemT->setRowCount(MemT->rowCount() - 1);
    }
    while(InstT->rowCount()*InstT->rowHeight(0) < InstT->height()){
        InstT->setRowCount(InstT->rowCount() + 1);
    }
    while(InstT->rowCount()*InstT->rowHeight(0) > InstT->height()){
        InstT->setRowCount(InstT->rowCount() - 1);
    }
}

void MainWindow::resizeEvent(QResizeEvent *event){
    QMainWindow::resizeEvent(event);
    SetTableWidth();
    refreshRegView();
    refreshMemView();
    refreshRegView();
}

map<int, string> xregs = {
    {0, "zero"},
    {1, "ra"},
    {2, "sp"},
    {3, "gp"},
    {4, "tp"},
    {5, "t0"},
    {6, "t1"},
    {7, "t2"},
    {8, "s0/fp"},
    {9, "s1"},
    {10, "a0"},
    {11, "a1"},
    {12, "a2"},
    {13, "a3"},
    {14, "a4"},
    {15, "a5"},
    {16, "a6"},
    {17, "a7"},
    {18, "s2"},
    {19, "s3"},
    {20, "s4"},
    {21, "s5"},
    {22, "s6"},
    {23, "s7"},
    {24, "s8"},
    {25, "s9"},
    {26, "s10"},
    {27, "s11"},
    {28, "t3"},
    {29, "t4"},
    {30, "t5"},
    {31, "t6"}
};

map<int, string> fregs = {
    {0, "ft0"},
    {1, "ft1"},
    {2, "ft2"},
    {3, "ft3"},
    {4, "ft4"},
    {5, "ft5"},
    {6, "ft6"},
    {7, "ft7"},
    {8, "fs0"},
    {9, "fs1"},
    {10, "fa0"},
    {11, "fa1"},
    {12, "fa2"},
    {13, "fa3"},
    {14, "fa4"},
    {15, "fa5"},
    {16, "fa6"},
    {17, "fa7"},
    {18, "fs2"},
    {19, "fs3"},
    {20, "fs4"},
    {21, "fs5"},
    {22, "fs6"},
    {23, "fs7"},
    {24, "fs8"},
    {25, "fs9"},
    {26, "fs10"},
    {27, "fs11"},
    {28, "ft8"},
    {29, "ft9"},
    {30, "ft10"},
    {31, "ft11"}
};

void MainWindow::refreshRegView(){
    auto& regt = ui->RegTable;
    for(int i=0; i<regt->rowCount(); i++){
        for(int j=0; j<regt->columnCount();j++){
            if(j % 2 == 0){
                if((i * regt->columnCount() + j) / 2 < 32){
                    if(regt->item(i,j) == NULL){
                        regt->setItem(i, j, new QTableWidgetItem(xregs[(i * regt->columnCount() + j) / 2].data()));
                    }else{
                        regt->item(i, j)->setText(xregs[(i * regt->columnCount() + j) / 2].data());
                    }

                }else{
                    if(regt->item(i,j) == NULL){
                        regt->setItem(i, j, new QTableWidgetItem(fregs[(i * regt->columnCount() + j) / 2 - 32].data()));
                    }else{
                        regt->item(i, j)->setText(fregs[(i * regt->columnCount() + j) / 2 - 32].data());
                    }
                }
                regt->item(i,j)->setTextAlignment(Qt::AlignCenter);
                regt->item(i,j)->setBackground(QBrush(Qt::gray));
            }else{
                if((i * regt->columnCount() + j) / 2 < 32){
                    stringstream ss;
                    if(isReghex){
                        ss.fill('0');
                        ss << hex << "0x" << setw(8) << sobj.sim.cpu->reg[(i * regt->columnCount() + j) / 2] << dec;
                        ss.fill(' ');
                    }else{
                        ss << dec << sobj.sim.cpu->reg[(i * regt->columnCount() + j) / 2];
                    }
                    if(regt->item(i,j) == NULL){
                        regt->setItem(i, j, new QTableWidgetItem(ss.str().data()));
                    }else{
                        regt->item(i, j)->setText(ss.str().data());
                    }
                }else{
                    stringstream ss;
                    if(isReghex){
                        ss.fill('0');
                        ss << hex << "0x" << setw(8) << sobj.sim.cpu->freg[(i * regt->columnCount() + j) / 2 - 32] << dec;
                        ss.fill(' ');
                    }else{
                        float* f = (float*)&(sobj.sim.cpu->freg[(i * regt->columnCount() + j) / 2 - 32]);
                        ss << (*f);
                    }
                    if(regt->item(i,j) == NULL){
                        regt->setItem(i, j, new QTableWidgetItem(ss.str().data()));
                    }else{
                        regt->item(i, j)->setText(ss.str().data());
                    }
                }
                regt->item(i,j)->setTextAlignment(Qt::AlignRight);
            }
        }
    }
}

void MainWindow::refreshMemView(){
    auto& memt = ui->MemTable;
    for(int i=0; i<memt->rowCount(); i++){
        stringstream ss;
        ss << "0x" << hex << (mem_addr + (i * 8));
        if(memt->verticalHeaderItem(i) == NULL){
            memt->setVerticalHeaderItem(i, new QTableWidgetItem(ss.str().data()));
        }else{
            memt->verticalHeaderItem(i)->setText(ss.str().data());
        }
    }
    for(int i=0; i<memt->rowCount(); i++){
        for(int j=0; j<memt->columnCount(); j++){
            stringstream ss;
            ss.fill('0');
            int index = i * memt->columnCount() + j + mem_addr;
            if (index < sobj.sim.cpu->mem->size) ss << "0x" << hex << sobj.sim.cpu->mem->read_without_cache(index) << dec;
            ss.fill(' ');
            if(memt->item(i, j) == NULL){
                memt->setItem(i, j, new QTableWidgetItem(ss.str().data()));
            }else{
                memt->item(i, j)->setText(ss.str().data());
            }
            memt->item(i,j)->setTextAlignment(Qt::AlignRight);
            if(index == (int)strtol(ui->address->text().toStdString().data(), NULL, 16)){
                memt->item(i,j)->setBackground(QBrush(Qt::green));
            }else{
                memt->item(i,j)->setBackground(QBrush(Qt::white));
            }
        }
    }
}

void MainWindow::refreshInstView(){
    auto& instt = ui->Instructions;
    for(int i=0; i<instt->rowCount(); i++){
        if(instt->verticalHeaderItem(i) == NULL){
            instt->setVerticalHeaderItem(i, new QTableWidgetItem(to_string(inst_line + i).data()));
        }else{
            instt->verticalHeaderItem(i)->setText(to_string(inst_line + i).data());
        }
        if(sobj.sim.ready){
            string in = (i < (int)sobj.sim.str_instr.size()) ? sobj.sim.str_instr[i + inst_line] : "";
            if(instt->item(i,0) == NULL){
                instt->setItem(i, 0, new QTableWidgetItem(in.data()));
            }else{
                instt->item(i, 0)->setText(in.data());
                instt->item(i, 0)->setBackground(QBrush(Qt::white));
            }
        }
    }
    if(sobj.sim.ready){
        int highlight_line = sobj.sim.pc_to_line(sobj.sim.get_pc()) - inst_line;
        if(highlight_line >= 0 && highlight_line < instt->rowCount()) instt->item(highlight_line,0)->setBackground(QBrush(Qt::yellow));
    }
}

void MainWindow::on_pushButton_7_released()
{
    isReghex = false;
    refreshRegView();
}


void MainWindow::on_pushButton_8_released()
{
    isReghex = true;
    refreshRegView();
}




void MainWindow::on_pushButton_9_released()
{
    sobj.sim.isasm=true;
    auto filename = QFileDialog::getOpenFileName(this, tr("Open Assembly"), "", tr("Assembly Files (*.s)"));
    sobj.filename = filename.toStdString();
    emit tellSimRead();
}


void MainWindow::on_address_textChanged(const QString &arg1)
{
    mem_addr = (int)strtol(arg1.toStdString().data(), NULL, 16);
    if(mem_addr < 0 || mem_addr > sobj.sim.cpu->mem->size) mem_addr = 0;
    mem_addr -= min(mem_addr, 16);
    mem_addr -= mem_addr % 8;
    refreshMemView();
}


void MainWindow::on_Instructions_cellClicked(int row, int column)
{
    if(sobj.sim.str_instr.size() <= 0) return;
    int ret = sobj.sim.brk_unified(sobj.sim.line_to_pc(row));

    if(ret){
        ui->Instructions->item(sobj.sim.pc_to_line(sobj.sim.line_to_pc(row)), column)->setForeground(QBrush(Qt::red));
    }else{
        ui->Instructions->item(sobj.sim.pc_to_line(sobj.sim.line_to_pc(row)), column)->setForeground(QBrush(Qt::black));
    }
    refreshInstView();
}

void MainWindow::refreshAll(){
    string pc_text = string("PC: ") + to_string(sobj.sim.get_pc());
    string clk_txt = string("CLOCK: ") + to_string(sobj.sim.get_clock());
    ui->pc->setText(pc_text.data());
    ui->clk->setText(clk_txt.data());
    if(sobj.sim.pc_to_line(sobj.sim.get_pc()) >= ui->Instructions->rowCount()) inst_line = sobj.sim.pc_to_line(sobj.sim.get_pc());
    refreshInstView();
    refreshMemView();
    refreshRegView();
}

void MainWindow::on_pushButton_released()
{
    if(sobj.sim.str_instr.size() <= 0) return;
    emit tellSimRun();
}


void MainWindow::on_pushButton_2_released()
{
    if(sobj.sim.str_instr.size() <= 0) return;
    if(sobj.needReset) sobj.sim.reset();
    int ret = sobj.sim.step();
    sobj.needReset = (ret == 0) ? true : false;
    refreshAll();
}


void MainWindow::on_pushButton_3_clicked()
{
    sobj.sim.reset();
    refreshAll();
}

