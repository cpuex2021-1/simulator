cmake_minimum_required(VERSION 3.5)

include(${CMAKE_CURRENT_LIST_DIR}/../asm/CMakeLists.txt)
include(${CMAKE_CURRENT_LIST_DIR}/../include/asmjit/CMakeLists.txt)

project(OreOre-V-Simlib CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "-std=c++17 -O3 -Wall")

if(WIN32)
    add_definitions(-DWINDOWS)
endif(WIN32)

add_library(simlib ${CMAKE_CURRENT_LIST_DIR}/CPU.cpp ${CMAKE_CURRENT_LIST_DIR}/Compiler.cpp 
    ${CMAKE_CURRENT_LIST_DIR}/Memory.cpp ${CMAKE_CURRENT_LIST_DIR}/Simulator.cpp 
    ${CMAKE_CURRENT_LIST_DIR}/Profiler.cpp ${CMAKE_CURRENT_LIST_DIR}/fpu.cpp)

target_link_libraries(simlib asmlib asmjit utillib)

add_executable(cli-simulator ${CMAKE_CURRENT_LIST_DIR}/main.cpp)
target_link_libraries(cli-simulator simlib)

add_executable(simple-simulator ${CMAKE_CURRENT_LIST_DIR}/simplesim.cpp)
target_link_libraries(simple-simulator simlib)
