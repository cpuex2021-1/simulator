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
    ../sim/Compiler.cpp \
    ../sim/Memory.cpp \
    ../sim/Profiler.cpp \
    ../sim/Simulator.cpp \
    ../sim/fpu.cpp \
    ../sim/fputest.cpp \
    ../sim/main.cpp \
    ../sim/proftest.cpp \
    ../sim/util.cpp \
    main.cpp \
    mainwindow.cpp \
    simobj.cpp

HEADERS += \
    ../asm/Instructions.hpp \
    ../asm/Parse.hpp \
    ../sim/CPU.hpp \
    ../sim/Compiler.hpp \
    ../sim/Memory.hpp \
    ../sim/Profiler.hpp \
    ../sim/Simulator.hpp \
    ../sim/fpu.hpp \
    ../sim/util.hpp \
    mainwindow.h \
    simobj.h

FORMS += \
    mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    ../asm/.gitignore \
    ../asm/README.md \
    ../sim/Makefile \
    ../sim/fverify \
    ../sim/gmon.out \
    ../sim/input.s \
    ../sim/memResult.txt \
    ../sim/proftest \
    ../sim/simulator

RESOURCES += \
    resources.qrc

unix|win32: LIBS += -L$$PWD/../include/asmjit/ -lasmjit

INCLUDEPATH += $$PWD/../include/asmjit
DEPENDPATH += $$PWD/../include/asmjit

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../include/asmjit/release/ -lasmjit
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../include/asmjit/debug/ -lasmjit
else:unix: LIBS += -L$$PWD/../include/asmjit/ -lasmjit

INCLUDEPATH += $$PWD/../include/asmjit/src
DEPENDPATH += $$PWD/../include/asmjit/src
