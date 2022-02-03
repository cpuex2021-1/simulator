/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.12.8
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QScrollBar>
#include <QtWidgets/QSpacerItem>
#include <QtWidgets/QSpinBox>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QTableWidget>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralwidget;
    QVBoxLayout *verticalLayout_5;
    QHBoxLayout *horizontalLayout;
    QVBoxLayout *verticalLayout_2;
    QHBoxLayout *horizontalLayout_11;
    QLabel *label_3;
    QSpacerItem *horizontalSpacer_8;
    QHBoxLayout *horizontalLayout_5;
    QLabel *label_4;
    QPushButton *pushButton_9;
    QLabel *label_5;
    QSpinBox *InstLinespinBox;
    QSpacerItem *horizontalSpacer_7;
    QHBoxLayout *horizontalLayout_9;
    QLabel *pc;
    QLabel *clk;
    QSpinBox *ClockSpin;
    QPushButton *pushButton_5;
    QSpacerItem *horizontalSpacer_3;
    QHBoxLayout *horizontalLayout_7;
    QTableWidget *Instructions;
    QScrollBar *verticalScrollBar;
    QVBoxLayout *verticalLayout_4;
    QHBoxLayout *horizontalLayout_4;
    QLabel *label_7;
    QPushButton *SimulatorModeButton;
    QSpacerItem *horizontalSpacer_4;
    QPushButton *pushButton_7;
    QPushButton *pushButton_8;
    QLabel *label_2;
    QTableWidget *RegTable;
    QHBoxLayout *horizontalLayout_2;
    QLabel *label_6;
    QLabel *label;
    QSpinBox *address;
    QSpacerItem *horizontalSpacer_6;
    QPushButton *memUpButton;
    QPushButton *memDownButton;
    QHBoxLayout *horizontalLayout_12;
    QLabel *CacheSummary;
    QSpacerItem *horizontalSpacer;
    QHBoxLayout *horizontalLayout_8;
    QTableWidget *MemTable;
    QScrollBar *MemScrollBar;
    QVBoxLayout *verticalLayout;
    QLabel *uartInputLabel;
    QPushButton *uartInputButton;
    QTableWidget *uartInputTable;
    QVBoxLayout *verticalLayout_3;
    QLabel *uartOutputLabel;
    QTextBrowser *uartOutputTextBrowser;
    QHBoxLayout *horizontalLayout_6;
    QPushButton *pushButton_2;
    QPushButton *revertButton;
    QPushButton *pushButton;
    QPushButton *pushButton_3;
    QPushButton *pushButton_4;
    QStatusBar *statusbar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(1383, 600);
        QSizePolicy sizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(MainWindow->sizePolicy().hasHeightForWidth());
        MainWindow->setSizePolicy(sizePolicy);
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        verticalLayout_5 = new QVBoxLayout(centralwidget);
        verticalLayout_5->setObjectName(QString::fromUtf8("verticalLayout_5"));
        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        verticalLayout_2 = new QVBoxLayout();
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        horizontalLayout_11 = new QHBoxLayout();
        horizontalLayout_11->setObjectName(QString::fromUtf8("horizontalLayout_11"));
        label_3 = new QLabel(centralwidget);
        label_3->setObjectName(QString::fromUtf8("label_3"));
        label_3->setAlignment(Qt::AlignCenter);

        horizontalLayout_11->addWidget(label_3);

        horizontalSpacer_8 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_11->addItem(horizontalSpacer_8);


        verticalLayout_2->addLayout(horizontalLayout_11);

        horizontalLayout_5 = new QHBoxLayout();
        horizontalLayout_5->setObjectName(QString::fromUtf8("horizontalLayout_5"));
        label_4 = new QLabel(centralwidget);
        label_4->setObjectName(QString::fromUtf8("label_4"));

        horizontalLayout_5->addWidget(label_4);

        pushButton_9 = new QPushButton(centralwidget);
        pushButton_9->setObjectName(QString::fromUtf8("pushButton_9"));

        horizontalLayout_5->addWidget(pushButton_9);

        label_5 = new QLabel(centralwidget);
        label_5->setObjectName(QString::fromUtf8("label_5"));

        horizontalLayout_5->addWidget(label_5);

        InstLinespinBox = new QSpinBox(centralwidget);
        InstLinespinBox->setObjectName(QString::fromUtf8("InstLinespinBox"));
        InstLinespinBox->setMaximum(1000000000);

        horizontalLayout_5->addWidget(InstLinespinBox);

        horizontalSpacer_7 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_5->addItem(horizontalSpacer_7);


        verticalLayout_2->addLayout(horizontalLayout_5);

        horizontalLayout_9 = new QHBoxLayout();
        horizontalLayout_9->setObjectName(QString::fromUtf8("horizontalLayout_9"));
        pc = new QLabel(centralwidget);
        pc->setObjectName(QString::fromUtf8("pc"));

        horizontalLayout_9->addWidget(pc);

        clk = new QLabel(centralwidget);
        clk->setObjectName(QString::fromUtf8("clk"));

        horizontalLayout_9->addWidget(clk);

        ClockSpin = new QSpinBox(centralwidget);
        ClockSpin->setObjectName(QString::fromUtf8("ClockSpin"));
        ClockSpin->setMaximum(999999999);

        horizontalLayout_9->addWidget(ClockSpin);

        pushButton_5 = new QPushButton(centralwidget);
        pushButton_5->setObjectName(QString::fromUtf8("pushButton_5"));

        horizontalLayout_9->addWidget(pushButton_5);

        horizontalSpacer_3 = new QSpacerItem(13, 21, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_9->addItem(horizontalSpacer_3);


        verticalLayout_2->addLayout(horizontalLayout_9);

        horizontalLayout_7 = new QHBoxLayout();
        horizontalLayout_7->setObjectName(QString::fromUtf8("horizontalLayout_7"));
        Instructions = new QTableWidget(centralwidget);
        if (Instructions->columnCount() < 1)
            Instructions->setColumnCount(1);
        if (Instructions->rowCount() < 16)
            Instructions->setRowCount(16);
        Instructions->setObjectName(QString::fromUtf8("Instructions"));
        Instructions->setRowCount(16);
        Instructions->setColumnCount(1);
        Instructions->horizontalHeader()->setVisible(false);
        Instructions->horizontalHeader()->setCascadingSectionResizes(false);
        Instructions->horizontalHeader()->setMinimumSectionSize(0);
        Instructions->horizontalHeader()->setDefaultSectionSize(60);
        Instructions->horizontalHeader()->setHighlightSections(false);
        Instructions->verticalHeader()->setVisible(false);
        Instructions->verticalHeader()->setMinimumSectionSize(0);
        Instructions->verticalHeader()->setDefaultSectionSize(24);

        horizontalLayout_7->addWidget(Instructions);

        verticalScrollBar = new QScrollBar(centralwidget);
        verticalScrollBar->setObjectName(QString::fromUtf8("verticalScrollBar"));
        verticalScrollBar->setOrientation(Qt::Vertical);

        horizontalLayout_7->addWidget(verticalScrollBar);


        verticalLayout_2->addLayout(horizontalLayout_7);


        horizontalLayout->addLayout(verticalLayout_2);

        verticalLayout_4 = new QVBoxLayout();
        verticalLayout_4->setObjectName(QString::fromUtf8("verticalLayout_4"));
        horizontalLayout_4 = new QHBoxLayout();
        horizontalLayout_4->setObjectName(QString::fromUtf8("horizontalLayout_4"));
        label_7 = new QLabel(centralwidget);
        label_7->setObjectName(QString::fromUtf8("label_7"));

        horizontalLayout_4->addWidget(label_7);

        SimulatorModeButton = new QPushButton(centralwidget);
        SimulatorModeButton->setObjectName(QString::fromUtf8("SimulatorModeButton"));

        horizontalLayout_4->addWidget(SimulatorModeButton);

        horizontalSpacer_4 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_4->addItem(horizontalSpacer_4);

        pushButton_7 = new QPushButton(centralwidget);
        pushButton_7->setObjectName(QString::fromUtf8("pushButton_7"));

        horizontalLayout_4->addWidget(pushButton_7);

        pushButton_8 = new QPushButton(centralwidget);
        pushButton_8->setObjectName(QString::fromUtf8("pushButton_8"));

        horizontalLayout_4->addWidget(pushButton_8);


        verticalLayout_4->addLayout(horizontalLayout_4);

        label_2 = new QLabel(centralwidget);
        label_2->setObjectName(QString::fromUtf8("label_2"));

        verticalLayout_4->addWidget(label_2);

        RegTable = new QTableWidget(centralwidget);
        if (RegTable->columnCount() < 8)
            RegTable->setColumnCount(8);
        if (RegTable->rowCount() < 16)
            RegTable->setRowCount(16);
        RegTable->setObjectName(QString::fromUtf8("RegTable"));
        sizePolicy.setHeightForWidth(RegTable->sizePolicy().hasHeightForWidth());
        RegTable->setSizePolicy(sizePolicy);
        RegTable->setRowCount(16);
        RegTable->setColumnCount(8);
        RegTable->horizontalHeader()->setVisible(false);
        RegTable->horizontalHeader()->setMinimumSectionSize(0);
        RegTable->horizontalHeader()->setHighlightSections(false);
        RegTable->verticalHeader()->setVisible(false);
        RegTable->verticalHeader()->setMinimumSectionSize(0);
        RegTable->verticalHeader()->setHighlightSections(false);

        verticalLayout_4->addWidget(RegTable);

        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        label_6 = new QLabel(centralwidget);
        label_6->setObjectName(QString::fromUtf8("label_6"));

        horizontalLayout_2->addWidget(label_6);

        label = new QLabel(centralwidget);
        label->setObjectName(QString::fromUtf8("label"));

        horizontalLayout_2->addWidget(label);

        address = new QSpinBox(centralwidget);
        address->setObjectName(QString::fromUtf8("address"));
        address->setMaximum(1000000000);
        address->setDisplayIntegerBase(16);

        horizontalLayout_2->addWidget(address);

        horizontalSpacer_6 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_2->addItem(horizontalSpacer_6);

        memUpButton = new QPushButton(centralwidget);
        memUpButton->setObjectName(QString::fromUtf8("memUpButton"));

        horizontalLayout_2->addWidget(memUpButton);

        memDownButton = new QPushButton(centralwidget);
        memDownButton->setObjectName(QString::fromUtf8("memDownButton"));

        horizontalLayout_2->addWidget(memDownButton);


        verticalLayout_4->addLayout(horizontalLayout_2);

        horizontalLayout_12 = new QHBoxLayout();
        horizontalLayout_12->setObjectName(QString::fromUtf8("horizontalLayout_12"));
        CacheSummary = new QLabel(centralwidget);
        CacheSummary->setObjectName(QString::fromUtf8("CacheSummary"));

        horizontalLayout_12->addWidget(CacheSummary);

        horizontalSpacer = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_12->addItem(horizontalSpacer);


        verticalLayout_4->addLayout(horizontalLayout_12);

        horizontalLayout_8 = new QHBoxLayout();
        horizontalLayout_8->setObjectName(QString::fromUtf8("horizontalLayout_8"));
        MemTable = new QTableWidget(centralwidget);
        if (MemTable->columnCount() < 4)
            MemTable->setColumnCount(4);
        QTableWidgetItem *__qtablewidgetitem = new QTableWidgetItem();
        MemTable->setHorizontalHeaderItem(0, __qtablewidgetitem);
        QTableWidgetItem *__qtablewidgetitem1 = new QTableWidgetItem();
        MemTable->setHorizontalHeaderItem(1, __qtablewidgetitem1);
        QTableWidgetItem *__qtablewidgetitem2 = new QTableWidgetItem();
        MemTable->setHorizontalHeaderItem(2, __qtablewidgetitem2);
        QTableWidgetItem *__qtablewidgetitem3 = new QTableWidgetItem();
        MemTable->setHorizontalHeaderItem(3, __qtablewidgetitem3);
        if (MemTable->rowCount() < 11)
            MemTable->setRowCount(11);
        QTableWidgetItem *__qtablewidgetitem4 = new QTableWidgetItem();
        MemTable->setVerticalHeaderItem(0, __qtablewidgetitem4);
        QTableWidgetItem *__qtablewidgetitem5 = new QTableWidgetItem();
        MemTable->setVerticalHeaderItem(1, __qtablewidgetitem5);
        QTableWidgetItem *__qtablewidgetitem6 = new QTableWidgetItem();
        MemTable->setVerticalHeaderItem(2, __qtablewidgetitem6);
        QTableWidgetItem *__qtablewidgetitem7 = new QTableWidgetItem();
        MemTable->setVerticalHeaderItem(3, __qtablewidgetitem7);
        QTableWidgetItem *__qtablewidgetitem8 = new QTableWidgetItem();
        MemTable->setVerticalHeaderItem(4, __qtablewidgetitem8);
        QTableWidgetItem *__qtablewidgetitem9 = new QTableWidgetItem();
        MemTable->setVerticalHeaderItem(5, __qtablewidgetitem9);
        QTableWidgetItem *__qtablewidgetitem10 = new QTableWidgetItem();
        MemTable->setVerticalHeaderItem(6, __qtablewidgetitem10);
        MemTable->setObjectName(QString::fromUtf8("MemTable"));
        MemTable->setRowCount(11);
        MemTable->setColumnCount(4);
        MemTable->horizontalHeader()->setVisible(false);
        MemTable->horizontalHeader()->setCascadingSectionResizes(true);
        MemTable->horizontalHeader()->setMinimumSectionSize(0);
        MemTable->horizontalHeader()->setHighlightSections(true);
        MemTable->verticalHeader()->setVisible(false);
        MemTable->verticalHeader()->setCascadingSectionResizes(true);
        MemTable->verticalHeader()->setMinimumSectionSize(0);
        MemTable->verticalHeader()->setHighlightSections(true);

        horizontalLayout_8->addWidget(MemTable);

        MemScrollBar = new QScrollBar(centralwidget);
        MemScrollBar->setObjectName(QString::fromUtf8("MemScrollBar"));
        MemScrollBar->setPageStep(1);
        MemScrollBar->setOrientation(Qt::Vertical);

        horizontalLayout_8->addWidget(MemScrollBar);


        verticalLayout_4->addLayout(horizontalLayout_8);


        horizontalLayout->addLayout(verticalLayout_4);

        verticalLayout = new QVBoxLayout();
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        uartInputLabel = new QLabel(centralwidget);
        uartInputLabel->setObjectName(QString::fromUtf8("uartInputLabel"));

        verticalLayout->addWidget(uartInputLabel);

        uartInputButton = new QPushButton(centralwidget);
        uartInputButton->setObjectName(QString::fromUtf8("uartInputButton"));

        verticalLayout->addWidget(uartInputButton);

        uartInputTable = new QTableWidget(centralwidget);
        if (uartInputTable->columnCount() < 1)
            uartInputTable->setColumnCount(1);
        QTableWidgetItem *__qtablewidgetitem11 = new QTableWidgetItem();
        uartInputTable->setHorizontalHeaderItem(0, __qtablewidgetitem11);
        uartInputTable->setObjectName(QString::fromUtf8("uartInputTable"));
        uartInputTable->horizontalHeader()->setVisible(false);
        uartInputTable->horizontalHeader()->setMinimumSectionSize(0);
        uartInputTable->horizontalHeader()->setHighlightSections(false);
        uartInputTable->verticalHeader()->setVisible(false);
        uartInputTable->verticalHeader()->setMinimumSectionSize(0);
        uartInputTable->verticalHeader()->setHighlightSections(false);

        verticalLayout->addWidget(uartInputTable);


        horizontalLayout->addLayout(verticalLayout);

        verticalLayout_3 = new QVBoxLayout();
        verticalLayout_3->setObjectName(QString::fromUtf8("verticalLayout_3"));
        uartOutputLabel = new QLabel(centralwidget);
        uartOutputLabel->setObjectName(QString::fromUtf8("uartOutputLabel"));

        verticalLayout_3->addWidget(uartOutputLabel);

        uartOutputTextBrowser = new QTextBrowser(centralwidget);
        uartOutputTextBrowser->setObjectName(QString::fromUtf8("uartOutputTextBrowser"));

        verticalLayout_3->addWidget(uartOutputTextBrowser);


        horizontalLayout->addLayout(verticalLayout_3);

        horizontalLayout->setStretch(0, 4);
        horizontalLayout->setStretch(1, 4);
        horizontalLayout->setStretch(2, 1);
        horizontalLayout->setStretch(3, 1);

        verticalLayout_5->addLayout(horizontalLayout);

        horizontalLayout_6 = new QHBoxLayout();
        horizontalLayout_6->setObjectName(QString::fromUtf8("horizontalLayout_6"));
        pushButton_2 = new QPushButton(centralwidget);
        pushButton_2->setObjectName(QString::fromUtf8("pushButton_2"));

        horizontalLayout_6->addWidget(pushButton_2);

        revertButton = new QPushButton(centralwidget);
        revertButton->setObjectName(QString::fromUtf8("revertButton"));

        horizontalLayout_6->addWidget(revertButton);

        pushButton = new QPushButton(centralwidget);
        pushButton->setObjectName(QString::fromUtf8("pushButton"));

        horizontalLayout_6->addWidget(pushButton);

        pushButton_3 = new QPushButton(centralwidget);
        pushButton_3->setObjectName(QString::fromUtf8("pushButton_3"));

        horizontalLayout_6->addWidget(pushButton_3);


        verticalLayout_5->addLayout(horizontalLayout_6);

        pushButton_4 = new QPushButton(centralwidget);
        pushButton_4->setObjectName(QString::fromUtf8("pushButton_4"));

        verticalLayout_5->addWidget(pushButton_4);

        MainWindow->setCentralWidget(centralwidget);
        statusbar = new QStatusBar(MainWindow);
        statusbar->setObjectName(QString::fromUtf8("statusbar"));
        MainWindow->setStatusBar(statusbar);

        retranslateUi(MainWindow);
        QObject::connect(pushButton_4, SIGNAL(released()), MainWindow, SLOT(close()));

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "\342\230\206\345\275\241OreOre-V Simulator\342\230\206\345\275\241", nullptr));
        label_3->setText(QApplication::translate("MainWindow", "Instructions", nullptr));
        label_4->setText(QApplication::translate("MainWindow", "File:", nullptr));
        pushButton_9->setText(QApplication::translate("MainWindow", "Open", nullptr));
        label_5->setText(QApplication::translate("MainWindow", "Line:", nullptr));
        pc->setText(QApplication::translate("MainWindow", "PC: 0", nullptr));
        clk->setText(QApplication::translate("MainWindow", "CLOCK:", nullptr));
        pushButton_5->setText(QApplication::translate("MainWindow", "Run Until Clockcount", nullptr));
        label_7->setText(QString());
        SimulatorModeButton->setText(QApplication::translate("MainWindow", "Accurate Mode", nullptr));
        pushButton_7->setText(QApplication::translate("MainWindow", "123.456...", nullptr));
        pushButton_8->setText(QApplication::translate("MainWindow", "0xABC", nullptr));
        label_2->setText(QApplication::translate("MainWindow", "Registers", nullptr));
        label_6->setText(QApplication::translate("MainWindow", "Memory      ", nullptr));
        label->setText(QApplication::translate("MainWindow", "Address: 0x", nullptr));
        memUpButton->setText(QApplication::translate("MainWindow", "Up", nullptr));
        memDownButton->setText(QApplication::translate("MainWindow", "Down", nullptr));
        CacheSummary->setText(QApplication::translate("MainWindow", "Valid rate: Hit rate: Replace rate: ", nullptr));
        QTableWidgetItem *___qtablewidgetitem = MemTable->horizontalHeaderItem(0);
        ___qtablewidgetitem->setText(QApplication::translate("MainWindow", "+0", nullptr));
        QTableWidgetItem *___qtablewidgetitem1 = MemTable->horizontalHeaderItem(1);
        ___qtablewidgetitem1->setText(QApplication::translate("MainWindow", "+1", nullptr));
        QTableWidgetItem *___qtablewidgetitem2 = MemTable->horizontalHeaderItem(2);
        ___qtablewidgetitem2->setText(QApplication::translate("MainWindow", "+2", nullptr));
        QTableWidgetItem *___qtablewidgetitem3 = MemTable->horizontalHeaderItem(3);
        ___qtablewidgetitem3->setText(QApplication::translate("MainWindow", "+3", nullptr));
        QTableWidgetItem *___qtablewidgetitem4 = MemTable->verticalHeaderItem(0);
        ___qtablewidgetitem4->setText(QApplication::translate("MainWindow", "\346\226\260\343\201\227\343\201\204\350\241\214", nullptr));
        QTableWidgetItem *___qtablewidgetitem5 = MemTable->verticalHeaderItem(1);
        ___qtablewidgetitem5->setText(QApplication::translate("MainWindow", "\346\226\260\343\201\227\343\201\204\350\241\214", nullptr));
        QTableWidgetItem *___qtablewidgetitem6 = MemTable->verticalHeaderItem(2);
        ___qtablewidgetitem6->setText(QApplication::translate("MainWindow", "\346\226\260\343\201\227\343\201\204\350\241\214", nullptr));
        QTableWidgetItem *___qtablewidgetitem7 = MemTable->verticalHeaderItem(3);
        ___qtablewidgetitem7->setText(QApplication::translate("MainWindow", "\346\226\260\343\201\227\343\201\204\350\241\214", nullptr));
        QTableWidgetItem *___qtablewidgetitem8 = MemTable->verticalHeaderItem(4);
        ___qtablewidgetitem8->setText(QApplication::translate("MainWindow", "\346\226\260\343\201\227\343\201\204\350\241\214", nullptr));
        QTableWidgetItem *___qtablewidgetitem9 = MemTable->verticalHeaderItem(5);
        ___qtablewidgetitem9->setText(QApplication::translate("MainWindow", "\346\226\260\343\201\227\343\201\204\350\241\214", nullptr));
        QTableWidgetItem *___qtablewidgetitem10 = MemTable->verticalHeaderItem(6);
        ___qtablewidgetitem10->setText(QApplication::translate("MainWindow", "\346\226\260\343\201\227\343\201\204\350\241\214", nullptr));
        uartInputLabel->setText(QApplication::translate("MainWindow", "Uart Input", nullptr));
        uartInputButton->setText(QApplication::translate("MainWindow", "Open", nullptr));
        QTableWidgetItem *___qtablewidgetitem11 = uartInputTable->horizontalHeaderItem(0);
        ___qtablewidgetitem11->setText(QApplication::translate("MainWindow", "data", nullptr));
        uartOutputLabel->setText(QApplication::translate("MainWindow", "Uart Output", nullptr));
        pushButton_2->setText(QApplication::translate("MainWindow", "Step", nullptr));
        revertButton->setText(QApplication::translate("MainWindow", "Revert", nullptr));
        pushButton->setText(QApplication::translate("MainWindow", "Run", nullptr));
        pushButton_3->setText(QApplication::translate("MainWindow", "Reset", nullptr));
        pushButton_4->setText(QApplication::translate("MainWindow", "Quit", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
