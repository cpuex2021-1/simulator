# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/naga/git/simulator

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/naga/git/simulator/btest

# Include any dependencies generated for this target.
include CMakeFiles/disassembler.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/disassembler.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/disassembler.dir/flags.make

CMakeFiles/disassembler.dir/disassembler_autogen/mocs_compilation.cpp.o: CMakeFiles/disassembler.dir/flags.make
CMakeFiles/disassembler.dir/disassembler_autogen/mocs_compilation.cpp.o: disassembler_autogen/mocs_compilation.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/naga/git/simulator/btest/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/disassembler.dir/disassembler_autogen/mocs_compilation.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/disassembler.dir/disassembler_autogen/mocs_compilation.cpp.o -c /home/naga/git/simulator/btest/disassembler_autogen/mocs_compilation.cpp

CMakeFiles/disassembler.dir/disassembler_autogen/mocs_compilation.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/disassembler.dir/disassembler_autogen/mocs_compilation.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/naga/git/simulator/btest/disassembler_autogen/mocs_compilation.cpp > CMakeFiles/disassembler.dir/disassembler_autogen/mocs_compilation.cpp.i

CMakeFiles/disassembler.dir/disassembler_autogen/mocs_compilation.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/disassembler.dir/disassembler_autogen/mocs_compilation.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/naga/git/simulator/btest/disassembler_autogen/mocs_compilation.cpp -o CMakeFiles/disassembler.dir/disassembler_autogen/mocs_compilation.cpp.s

CMakeFiles/disassembler.dir/lib/main.cpp.o: CMakeFiles/disassembler.dir/flags.make
CMakeFiles/disassembler.dir/lib/main.cpp.o: ../lib/main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/naga/git/simulator/btest/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/disassembler.dir/lib/main.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/disassembler.dir/lib/main.cpp.o -c /home/naga/git/simulator/lib/main.cpp

CMakeFiles/disassembler.dir/lib/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/disassembler.dir/lib/main.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/naga/git/simulator/lib/main.cpp > CMakeFiles/disassembler.dir/lib/main.cpp.i

CMakeFiles/disassembler.dir/lib/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/disassembler.dir/lib/main.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/naga/git/simulator/lib/main.cpp -o CMakeFiles/disassembler.dir/lib/main.cpp.s

# Object files for target disassembler
disassembler_OBJECTS = \
"CMakeFiles/disassembler.dir/disassembler_autogen/mocs_compilation.cpp.o" \
"CMakeFiles/disassembler.dir/lib/main.cpp.o"

# External object files for target disassembler
disassembler_EXTERNAL_OBJECTS =

disassembler: CMakeFiles/disassembler.dir/disassembler_autogen/mocs_compilation.cpp.o
disassembler: CMakeFiles/disassembler.dir/lib/main.cpp.o
disassembler: CMakeFiles/disassembler.dir/build.make
disassembler: libutillib.a
disassembler: CMakeFiles/disassembler.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/naga/git/simulator/btest/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX executable disassembler"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/disassembler.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/disassembler.dir/build: disassembler

.PHONY : CMakeFiles/disassembler.dir/build

CMakeFiles/disassembler.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/disassembler.dir/cmake_clean.cmake
.PHONY : CMakeFiles/disassembler.dir/clean

CMakeFiles/disassembler.dir/depend:
	cd /home/naga/git/simulator/btest && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/naga/git/simulator /home/naga/git/simulator /home/naga/git/simulator/btest /home/naga/git/simulator/btest /home/naga/git/simulator/btest/CMakeFiles/disassembler.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/disassembler.dir/depend

