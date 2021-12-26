cmake_minimum_required(VERSION 3.5)
project(OreOre-V-Asmlib CXX)

include_directories(${CMAKE_CURRENT_LIST_DIR}/../include/asmjit/src)

set(CMAKE_CXX_FLAGS "-std=c++17 -O3 -Wall")

add_library(asmlib ${CMAKE_CURRENT_LIST_DIR}/Instructions.cpp ${CMAKE_CURRENT_LIST_DIR}/Parse.cpp)
