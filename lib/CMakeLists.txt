cmake_minimum_required(VERSION 3.5)
project(OreOre-V-Utillib CXX)

set(CMAKE_CXX_STANDARD_REQUIRED 17)
set(CMAKE_CXX_FLAGS "-std=c++17 -O3 -Wall")

add_library(utillib ${CMAKE_CURRENT_LIST_DIR}/DisReader.cpp
${CMAKE_CURRENT_LIST_DIR}/util.cpp)

add_executable(disassembler ${CMAKE_CURRENT_LIST_DIR}/main.cpp)
target_link_libraries(disassembler utillib)