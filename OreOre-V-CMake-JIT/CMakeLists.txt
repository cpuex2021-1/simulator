cmake_minimum_required(VERSION 3.5)

project(OreOre-V VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_definitions(-DQT_NO_KEYWORDS)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Widgets REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Widgets REQUIRED)

include("${CMAKE_CURRENT_LIST_DIR}/../sim/CMakeLists.txt")

set(PROJECT_SOURCES
${CMAKE_CURRENT_LIST_DIR}/main.cpp
${CMAKE_CURRENT_LIST_DIR}/mainwindow.cpp
${CMAKE_CURRENT_LIST_DIR}/mainwindow.h
${CMAKE_CURRENT_LIST_DIR}/mainwindow.ui
${CMAKE_CURRENT_LIST_DIR}/simobj.cpp
${CMAKE_CURRENT_LIST_DIR}/simobj.h
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(gui-simulator
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET gui-simulator APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
        add_library(gui-simulator SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(gui-simulator
            ${PROJECT_SOURCES}
        )
    endif()
endif()


target_link_libraries(gui-simulator PRIVATE Qt${QT_VERSION_MAJOR}::Widgets simlib)

#set_target_properties(gui-simulator PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
#    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
#    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
#)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(gui-simulator)
endif()
