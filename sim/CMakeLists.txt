cmake_minimum_required(VERSION 3.5)
project(Simulator CXX)

include_directories(${CMAKE_CURRENT_LIST_DIR}/../include/asmjit/src)
include(${CMAKE_CURRENT_LIST_DIR}/../asm/CMakeLists.txt)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "-O3 -Wall")

add_library(simlib ${CMAKE_CURRENT_LIST_DIR}/CPU.cpp ${CMAKE_CURRENT_LIST_DIR}/Compiler.cpp 
    ${CMAKE_CURRENT_LIST_DIR}/Memory.cpp ${CMAKE_CURRENT_LIST_DIR}/Simulator.cpp 
    ${CMAKE_CURRENT_LIST_DIR}/fpu.cpp ${CMAKE_CURRENT_LIST_DIR}/util.cpp)

target_link_libraries(simlib asmlib)