cmake_minimum_required(VERSION 3.5)

project(OreOre-V LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check http://doc.qt.io/qt-5/deployment-android.html for more information.
# They need to be set before the find_package(Qt5 ...) call.

#if(ANDROID)
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
#    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#    endif()
#endif()

set(CMAKE_CXX_FLAGS "-O3 -Wall")

add_definitions(-DQT_NO_KEYWORDS)

find_package(Qt5 COMPONENTS Widgets REQUIRED)

include_directories(${CMAKE_CURRENT_LIST_DIR}/../include/asmjit/src)

include(${CMAKE_CURRENT_LIST_DIR}/../include/asmjit/CMakeLists.txt)
include(${CMAKE_CURRENT_LIST_DIR}/../sim/CMakeLists.txt)

if(ANDROID)
  add_library(gui-simulator SHARED
  ${CMAKE_CURRENT_LIST_DIR}/main.cpp
  ${CMAKE_CURRENT_LIST_DIR}/simobj.cpp
  ${CMAKE_CURRENT_LIST_DIR}/simobj.h
  ${CMAKE_CURRENT_LIST_DIR}/mainwindow.cpp
  ${CMAKE_CURRENT_LIST_DIR}/mainwindow.h
  ${CMAKE_CURRENT_LIST_DIR}/mainwindow.ui
  )
else()
  add_executable(gui-simulator
  ${CMAKE_CURRENT_LIST_DIR}/main.cpp
  ${CMAKE_CURRENT_LIST_DIR}/simobj.cpp
  ${CMAKE_CURRENT_LIST_DIR}/simobj.h
  ${CMAKE_CURRENT_LIST_DIR}/mainwindow.cpp
  ${CMAKE_CURRENT_LIST_DIR}/mainwindow.h
  ${CMAKE_CURRENT_LIST_DIR}/mainwindow.ui
  )
endif()

add_executable(assembler ${CMAKE_CURRENT_LIST_DIR}/../asm/main.cpp)

target_link_libraries(assembler asmlib)

add_executable(simulator ${CMAKE_CURRENT_LIST_DIR}/../sim/main.cpp)

target_link_libraries(simulator simlib asmjit ${ASMJIT_DEPS})

target_link_libraries(gui-simulator PRIVATE Qt5::Widgets simlib asmjit ${ASMJIT_DEPS})

