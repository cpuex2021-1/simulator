#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <string>
#include <sstream>
#include <stdlib.h>
#include <QFileDialog>
#include <QMessageBox>
#include <QImage>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
    , mem_addr(0)
    , inst_line(0)
    , uart_in_line(0)
    , isReghex(false)
    , running(false)
{
    ui->setupUi(this);
    ui->RegTable->verticalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    ui->MemTable->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    ui->Instructions->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    ui->RegTable->setEditTriggers(QAbstractItemView::DoubleClicked);
    ui->MemTable->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->Instructions->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->Instructions->setSelectionMode(QAbstractItemView::NoSelection);
    ui->Instructions->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    ui->MemTable->horizontalHeader()->setVisible(true);
    ui->MemTable->verticalHeader()->setVisible(true);

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
    while(MemT->rowCount()*MemT->rowHeight(0) < MemT->height()){
        MemT->setRowCount(MemT->rowCount() + 1);
    }
    while(MemT->rowCount()*MemT->rowHeight(0) > MemT->height()){
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

void MainWindow::refreshRegView(){
    auto& regt = ui->RegTable;
    for(int i=0; i<regt->rowCount(); i++){
        for(int j=0; j<regt->columnCount();j++){
            if(j % 2 == 0){
                if((i * regt->columnCount() + j) / 2 < 32){
                    if(regt->item(i,j) == NULL){
                        regt->setItem(i, j, new QTableWidgetItem(xregName[(i * regt->columnCount() + j) / 2].data()));
                    }else{
                        regt->item(i, j)->setText(xregName[(i * regt->columnCount() + j) / 2].data());
                    }

                }else{
                    if(regt->item(i,j) == NULL){
                        regt->setItem(i, j, new QTableWidgetItem(fregName[(i * regt->columnCount() + j) / 2 - 32].data()));
                    }else{
                        regt->item(i, j)->setText(fregName[(i * regt->columnCount() + j) / 2 - 32].data());
                    }
                }
                regt->item(i,j)->setTextAlignment(Qt::AlignCenter);
                regt->item(i,j)->setBackground(QBrush(Qt::gray));
            }else{
                if((i * regt->columnCount() + j) / 2 < 32){
                    stringstream ss;
                    if(isReghex){
                        ss.fill('0');
                        ss << hex << "0x" << setw(8) << sobj.sim.reg[(i * regt->columnCount() + j) / 2] << dec;
                        ss.fill(' ');
                    }else{
                        ss << dec << sobj.sim.reg[(i * regt->columnCount() + j) / 2];
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
                        ss << hex << "0x" << setw(8) << sobj.sim.freg[(i * regt->columnCount() + j) / 2 - 32] << dec;
                        ss.fill(' ');
                    }else{
                        float* f = (float*)&(sobj.sim.freg[(i * regt->columnCount() + j) / 2 - 32]);
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
        ss << "0x" << hex << (mem_addr + (i * memt->columnCount()));
        if(memt->verticalHeaderItem(i) == NULL){
            memt->setVerticalHeaderItem(i, new QTableWidgetItem(ss.str().data()));
        }else{
            memt->verticalHeaderItem(i)->setText(ss.str().data());
        }
    }
    for(int i=0; i<memt->rowCount(); i++){
        for(int j=0; j<memt->columnCount(); j++){
            stringstream ss;
            int index = i * memt->columnCount() + j + mem_addr;
            if (index < MEMSIZE){
                if(isReghex){
                    ss.fill('0');
                    ss << "0x" << hex << sobj.sim.mem.read_without_cache(index) << dec;
                    ss.fill(' ');
                }else{
                    ss << sobj.sim.mem.read_without_cache(index);
                }
            }
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
    if(!sobj.sim.ready) return;
    auto& instt = ui->Instructions;
    for(int i=0; i<instt->rowCount(); i++){
        if(instt->verticalHeaderItem(i) == NULL){
            instt->setVerticalHeaderItem(i, new QTableWidgetItem(to_string(inst_line + i).data()));
        }else{
            instt->verticalHeaderItem(i)->setText(to_string(inst_line + i).data());
        }

        instt->verticalHeader()->setVisible(true);
        if(sobj.sim.ready){
            string in = (i + inst_line < (int)sobj.sim.str_instr.size()) ? sobj.sim.str_instr[i + inst_line] : "";
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
        for(int i=0; i<instt->rowCount(); i++){
            if(sobj.sim.isbrk(sobj.sim.line_to_pc(i + inst_line)) && sobj.sim.pc_to_line(sobj.sim.line_to_pc(i + inst_line)) == i + inst_line){
                ui->Instructions->item(i, 0)->setForeground(QBrush(Qt::red));
            }else{
                ui->Instructions->item(i, 0)->setForeground(QBrush(Qt::black));
            }
        }
    }
    
}

void MainWindow::refreshUartView(){
    auto& uart = sobj.sim.mem.uart;

    uart_in_line = max(uart.getInbufIdx() - 5, 0);

    auto& uartt = ui->uartInputTextBrowser;
    stringstream ss;
    for(uint32_t i=0; i<uart.getInbufSize(); i++){
        if(i == (uint32_t)uart.getInbufIdx()) ss << "----\n";
        ss << uart.getInbuf(i) << "\n";
        if(i == (uint32_t)uart.getInbufIdx()) ss << "----\n";
    }

    uartt->setText(ss.str().data());

    stringstream uout;

    for(int i=0; i<uart.getOutbufIdx(); i++){
        char so = '\0';
        try{
            so = ((char)uart.getOutbuf(i));
        }catch(exception &e){}
        uout << so;
    }

    uout << flush;

    ui->uartOutputTextBrowser->setText(uout.str().data());
}

void MainWindow::on_pushButton_7_released()
{
    isReghex = false;
    refreshAll();
}


void MainWindow::on_pushButton_8_released()
{
    isReghex = true;
    refreshAll();
}




void MainWindow::on_pushButton_9_released()
{
    sobj.sim.isasm=true;
    auto filename = QFileDialog::getOpenFileName(this, tr("Open Assembly"), "", tr("Assembly Files (*.s)"));
    sobj.filename = filename.toStdString();
    if(sobj.filename != string("")){
        sobj.sim.full_reset();
    }
    Q_EMIT tellSimRead();
}


void MainWindow::on_address_valueChanged(int value)
{
    mem_addr = value;
    if(mem_addr < 0 || mem_addr > MEMSIZE) mem_addr = 0;
    mem_addr -= min(mem_addr, 16);
    mem_addr -= mem_addr % 8;
    refreshMemView();
}


void MainWindow::on_Instructions_cellClicked(int row, int column)
{
    if(column != 0) return;
    if(sobj.sim.str_instr.size() <= 0) return;
    sobj.sim.brk_unified(sobj.sim.line_to_pc(inst_line + row));
    refreshAll();
}

void MainWindow::refreshAll(){
    string pc_text = string("PC: ") + to_string(sobj.sim.get_pc());
    string clk_text = string("CLOCK: ") + to_string(sobj.sim.get_clock());
    ui->InstLinespinBox->setValue(inst_line);
    ui->pc->setText(pc_text.data());
    ui->clk->setText(clk_text.data());

    //show statistics
    stringstream ssstats;
    ssstats << "Number of Instructions:\n" << sobj.sim.numInstruction << "\n\n" \
            << "Number of 1 cycle stalls (non-memory-access):\n" << sobj.sim.num2stall << "\n\n" \
            << "Number of 2 cycle stalls (non-memory-access):\n" << sobj.sim.num3stall << "\n\n" \
            << "Number of 3 cycle stalls (non-memory-access):\n" << sobj.sim.num4stall << "\n\n" \
            << "Number of data hazards:\n" << sobj.sim.numDataHazard << "\n\n" \
            << "Number of branch prediction miss:\n" << sobj.sim.numFlush << "\n\n" \
            << "Number of cache miss:\n" << sobj.sim.mem.totalstall() << "\n" << endl;
    auto& memtmp = sobj.sim.mem;
    ssstats << "Cache valid rate:\n" << memtmp.getValidRate() \
            << "\n\nCache hit rate:\n" << memtmp.getHitRate() \
            << "\n\nCache replace rate:\n" << memtmp.getReplaceRate() << endl;
    ui->statsTextBrowser->setText(ssstats.str().data());

    if(sobj.sim.ready && (running)){
        if(sobj.sim.pc_to_line(sobj.sim.get_pc()) >= ui->Instructions->rowCount() + inst_line) inst_line = sobj.sim.pc_to_line(sobj.sim.get_pc());
        else if(sobj.sim.pc_to_line(sobj.sim.get_pc()) < inst_line) inst_line = sobj.sim.pc_to_line(sobj.sim.get_pc());
        running = false;
    }

    if(!sobj.sim.ready){
        ui->pushButton->setDisabled(true);
        ui->pushButton_2->setDisabled(true);
        ui->pushButton_3->setDisabled(true);
        ui->revertButton->setDisabled(true);
    }else{
        if(sobj.needReset){
            ui->pushButton->setDisabled(true);
            ui->pushButton_2->setDisabled(true);
            ui->pushButton_3->setDisabled(false);
            ui->revertButton->setDisabled(false);
        }else{
            ui->pushButton->setDisabled(false);
            ui->pushButton_2->setDisabled(false);
            ui->pushButton_3->setDisabled(false);
            ui->revertButton->setDisabled(false);
        }
    }
    refreshInstView();
    refreshMemView();
    refreshRegView();
    refreshUartView();
}

void MainWindow::on_pushButton_released()
{
    if(sobj.sim.str_instr.size() <= 0) return;
    running = true;
    Q_EMIT tellSimRun();
}


void MainWindow::on_pushButton_2_released()
{
    if(sobj.sim.str_instr.size() <= 0) return;
    if(sobj.needReset) sobj.sim.reset();

    int ret = 0;

    try {
        ret = sobj.sim.step();
    }  catch (exception &e) {
        stringstream err;
        err << "Error Occured!" << endl << "Error: " << e.what() << endl << "Aborting" << endl;
        QMessageBox errBox;
        errBox.setText(err.str().data());
        errBox.exec();
    }

    sobj.needReset = (ret == 0) ? true : false;
    running = true;
    refreshAll();
}


void MainWindow::on_pushButton_3_clicked()
{
    sobj.sim.reset();
    running = false;
    sobj.needReset = false;
    inst_line = 0;
    refreshAll();
}


void MainWindow::on_InstLinespinBox_valueChanged(int arg1)
{
    if(arg1 >= (int)sobj.sim.str_instr.size()){
        inst_line = std::max(0, (int)sobj.sim.str_instr.size()-1);
        ui->InstLinespinBox->setValue(inst_line);
    }
    else inst_line = arg1;
    if(inst_line != (int)sobj.sim.str_instr.size() * ui->verticalScrollBar->value() / 99){
        ui->verticalScrollBar->setValue(inst_line * 99 / sobj.sim.str_instr.size());
    }
    refreshAll();
}


void MainWindow::on_verticalScrollBar_valueChanged(int value)
{
    if(sobj.sim.ready){
        inst_line = sobj.sim.str_instr.size() * value / 99;
        if(inst_line >= (int)sobj.sim.str_instr.size()){
            inst_line = std::max(0, (int)sobj.sim.str_instr.size()-1);
        }
    }
    refreshAll();
}


void MainWindow::on_MemScrollBar_valueChanged(int value)
{
    if(sobj.sim.ready){
        mem_addr = (int)(((long long) MEMSIZE * (long long)value) / 99);
        if(mem_addr >= MEMSIZE){
            mem_addr = std::max(0, MEMSIZE-1);
        }
        mem_addr -= mem_addr % 8;
        ui->address->setValue(mem_addr);
    }
    refreshAll();
}

void MainWindow::on_memUpButton_released()
{
    ui->address->setValue(ui->address->value() - (ui->MemTable->columnCount() * ui->MemTable->rowCount() / 3));
}


void MainWindow::on_memDownButton_released()
{
    ui->address->setValue(max(ui->address->value() + (ui->MemTable->columnCount() * ui->MemTable->rowCount() / 3), 0));
}


void MainWindow::on_SimulatorModeButton_released()
{
    if(ui->SimulatorModeButton->text().toStdString() == string("Accurate Mode")){
        ui->SimulatorModeButton->setText("Fast Mode (JIT)");
        sobj.sim.setMode(Simulator::fast);
    }else{
        ui->SimulatorModeButton->setText("Accurate Mode");
        sobj.sim.setMode(Simulator::accurate);
    }
}


void MainWindow::on_revertButton_released()
{
    sobj.sim.revert();
    if(sobj.needReset) sobj.needReset = false;
    running = true;
    refreshAll();
}

void MainWindow::on_uartInputButton_released()
{
    auto filename = QFileDialog::getOpenFileName(this, tr("Open Binary"), "", tr("Binary Files (*)"));
    sobj.uartinfilename = filename.toStdString();
    sobj.sim.mem.setup_uart(sobj.uartinfilename);
    sobj.sim.uart_ready = true;
    refreshAll();
}

void MainWindow::on_RegTable_itemChanged(QTableWidgetItem *item)
{
    if(isReghex) return;
    if(item->column() % 2 == 1){
        if(item->row() < 8){
            sobj.sim.reg[item->column() / 2 + item->row() * 4] = item->data(QMetaType::Int).toInt();
        }else{
            float f;
            f = item->text().toFloat();
            int* i;
            i = (int*)&f;
            sobj.sim.freg[item->column() / 2 + (item->row() - 8) * 4] = (*i);
        }
    }
}


void MainWindow::on_uartInputTable_itemChanged(QTableWidgetItem *item)
{
    if(isReghex) return;
    try{
        sobj.sim.mem.uart.setInbuf(uart_in_line + item->row(), item->data(QMetaType::Int).toInt());
    }catch(exception &e){
    }
}


void MainWindow::on_BinaryButton_released()
{
    sobj.sim.isasm=false;
    auto filename = QFileDialog::getOpenFileName(this, tr("Open Binary"), "", tr("Binary Files (*)"));
    sobj.filename = filename.toStdString();
    if(sobj.filename != string("")){
        sobj.sim.full_reset();
    }
    sobj.sim.eat_bin(sobj.filename);
    refreshAll();
}


void MainWindow::on_jumpToPCButton_released()
{
    if(sobj.sim.ready){
        inst_line = max(sobj.sim.pc_to_line(sobj.sim.get_pc()) - 2, 0);
        ui->InstLinespinBox->setValue(inst_line);
    }
}


void MainWindow::on_instUpButton_released()
{
    if(sobj.sim.ready){
        inst_line -= ui->Instructions->rowCount() / 3;
        if(inst_line < 0) inst_line = 0;
        ui->InstLinespinBox->setValue(inst_line);
    }
}




void MainWindow::on_instDownButton_released()
{
    if(sobj.sim.ready){
        inst_line += ui->Instructions->rowCount() / 3;
        if(inst_line < 0) inst_line = 0;
        ui->InstLinespinBox->setValue(inst_line);
    }

}


void MainWindow::on_latestWriteButton_released()
{
    if(sobj.sim.ready){
        mem_addr = sobj.sim.mem.getLatestWriteIndex();
        ui->address->setValue(mem_addr);
    }
}


void MainWindow::on_latestReadButton_released()
{
    if(sobj.sim.ready){
        mem_addr = sobj.sim.mem.getLatestReadIndex();
        ui->address->setValue(mem_addr);
    }
}


void MainWindow::on_exportCSVButton_released()
{
    if(sobj.sim.ready){
        sobj.sim.exportToCsv();
    }
}

