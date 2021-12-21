cmake_minimum_required(VERSION 2.8)
project(testAsmjit CXX)
include_directories(${CMAKE_SOURCE_DIR}/../include/asmjit/src)

set(CMAKE_CXX_FLAGS "-std=c++17 -g -Wall")

Set(ASMJIT_EMBED TRUE)
Add_Definitions(-DASMJIT_STATIC)

Set(ASMJIT_DIR "${CMAKE_SOURCE_DIR}/../include/asmjit")
Include("${ASMJIT_DIR}/CMakeLists.txt")

# If you add a library / executable, include asmjit sources.
Add_Executable(simulator main.cpp CPU.cpp Compiler.cpp Memory.cpp Simulator.cpp fpu.cpp util.cpp ../asm/Instructions.cpp ../asm/Parse.cpp ${ASMJIT_SRC})

# You still have to include asmjit dependencies.
Target_Link_Libraries(simulator ${ASMJIT_DEPS})