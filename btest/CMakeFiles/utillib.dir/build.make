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
include CMakeFiles/utillib.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/utillib.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/utillib.dir/flags.make

CMakeFiles/utillib.dir/utillib_autogen/mocs_compilation.cpp.o: CMakeFiles/utillib.dir/flags.make
CMakeFiles/utillib.dir/utillib_autogen/mocs_compilation.cpp.o: utillib_autogen/mocs_compilation.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/naga/git/simulator/btest/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/utillib.dir/utillib_autogen/mocs_compilation.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/utillib.dir/utillib_autogen/mocs_compilation.cpp.o -c /home/naga/git/simulator/btest/utillib_autogen/mocs_compilation.cpp

CMakeFiles/utillib.dir/utillib_autogen/mocs_compilation.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/utillib.dir/utillib_autogen/mocs_compilation.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/naga/git/simulator/btest/utillib_autogen/mocs_compilation.cpp > CMakeFiles/utillib.dir/utillib_autogen/mocs_compilation.cpp.i

CMakeFiles/utillib.dir/utillib_autogen/mocs_compilation.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/utillib.dir/utillib_autogen/mocs_compilation.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/naga/git/simulator/btest/utillib_autogen/mocs_compilation.cpp -o CMakeFiles/utillib.dir/utillib_autogen/mocs_compilation.cpp.s

CMakeFiles/utillib.dir/lib/DisAssembler.cpp.o: CMakeFiles/utillib.dir/flags.make
CMakeFiles/utillib.dir/lib/DisAssembler.cpp.o: ../lib/DisAssembler.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/naga/git/simulator/btest/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/utillib.dir/lib/DisAssembler.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/utillib.dir/lib/DisAssembler.cpp.o -c /home/naga/git/simulator/lib/DisAssembler.cpp

CMakeFiles/utillib.dir/lib/DisAssembler.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/utillib.dir/lib/DisAssembler.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/naga/git/simulator/lib/DisAssembler.cpp > CMakeFiles/utillib.dir/lib/DisAssembler.cpp.i

CMakeFiles/utillib.dir/lib/DisAssembler.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/utillib.dir/lib/DisAssembler.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/naga/git/simulator/lib/DisAssembler.cpp -o CMakeFiles/utillib.dir/lib/DisAssembler.cpp.s

CMakeFiles/utillib.dir/lib/util.cpp.o: CMakeFiles/utillib.dir/flags.make
CMakeFiles/utillib.dir/lib/util.cpp.o: ../lib/util.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/naga/git/simulator/btest/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/utillib.dir/lib/util.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/utillib.dir/lib/util.cpp.o -c /home/naga/git/simulator/lib/util.cpp

CMakeFiles/utillib.dir/lib/util.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/utillib.dir/lib/util.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/naga/git/simulator/lib/util.cpp > CMakeFiles/utillib.dir/lib/util.cpp.i

CMakeFiles/utillib.dir/lib/util.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/utillib.dir/lib/util.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/naga/git/simulator/lib/util.cpp -o CMakeFiles/utillib.dir/lib/util.cpp.s

# Object files for target utillib
utillib_OBJECTS = \
"CMakeFiles/utillib.dir/utillib_autogen/mocs_compilation.cpp.o" \
"CMakeFiles/utillib.dir/lib/DisAssembler.cpp.o" \
"CMakeFiles/utillib.dir/lib/util.cpp.o"

# External object files for target utillib
utillib_EXTERNAL_OBJECTS =

libutillib.a: CMakeFiles/utillib.dir/utillib_autogen/mocs_compilation.cpp.o
libutillib.a: CMakeFiles/utillib.dir/lib/DisAssembler.cpp.o
libutillib.a: CMakeFiles/utillib.dir/lib/util.cpp.o
libutillib.a: CMakeFiles/utillib.dir/build.make
libutillib.a: CMakeFiles/utillib.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/naga/git/simulator/btest/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking CXX static library libutillib.a"
	$(CMAKE_COMMAND) -P CMakeFiles/utillib.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/utillib.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/utillib.dir/build: libutillib.a

.PHONY : CMakeFiles/utillib.dir/build

CMakeFiles/utillib.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/utillib.dir/cmake_clean.cmake
.PHONY : CMakeFiles/utillib.dir/clean

CMakeFiles/utillib.dir/depend:
	cd /home/naga/git/simulator/btest && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/naga/git/simulator /home/naga/git/simulator /home/naga/git/simulator/btest /home/naga/git/simulator/btest /home/naga/git/simulator/btest/CMakeFiles/utillib.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/utillib.dir/depend

