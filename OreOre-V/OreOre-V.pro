QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    ../asm/Instructions.cpp \
    ../asm/Parse.cpp \
    ../sim/CPU.cpp \
    ../sim/Memory.cpp \
    ../sim/Simulator.cpp \
    ../sim/fpu.cpp \
    ../sim/util.cpp \
    main.cpp \
    mainwindow.cpp

HEADERS += \
    ../asm/Instructions.hpp \
    ../asm/Parse.hpp \
    ../sim/CPU.hpp \
    ../sim/Memory.hpp \
    ../sim/Simulator.hpp \
    ../sim/fpu.hpp \
    ../sim/util.hpp \
    mainwindow.h

FORMS += \
    mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    ../asm/.gitignore \
    ../asm/README.md
