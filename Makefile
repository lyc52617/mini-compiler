# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.23

# Default target executed when no arguments are given to make.
default_target: all
.PHONY : default_target

# Allow only one "make -f Makefile2" at a time, but pass parallelism.
.NOTPARALLEL:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /opt/cmake-3.23.0/bin/cmake

# The command to remove a file.
RM = /opt/cmake-3.23.0/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/liu/compiler

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/liu/compiler

#=============================================================================
# Targets provided globally by CMake.

# Special rule for the target edit_cache
edit_cache:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Running CMake cache editor..."
	/opt/cmake-3.23.0/bin/ccmake -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR)
.PHONY : edit_cache

# Special rule for the target edit_cache
edit_cache/fast: edit_cache
.PHONY : edit_cache/fast

# Special rule for the target rebuild_cache
rebuild_cache:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Running CMake to regenerate build system..."
	/opt/cmake-3.23.0/bin/cmake --regenerate-during-build -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR)
.PHONY : rebuild_cache

# Special rule for the target rebuild_cache
rebuild_cache/fast: rebuild_cache
.PHONY : rebuild_cache/fast

# The main all target
all: cmake_check_build_system
	$(CMAKE_COMMAND) -E cmake_progress_start /home/liu/compiler/CMakeFiles /home/liu/compiler//CMakeFiles/progress.marks
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 all
	$(CMAKE_COMMAND) -E cmake_progress_start /home/liu/compiler/CMakeFiles 0
.PHONY : all

# The main clean target
clean:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 clean
.PHONY : clean

# The main clean target
clean/fast: clean
.PHONY : clean/fast

# Prepare targets for installation.
preinstall: all
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 preinstall
.PHONY : preinstall

# Prepare targets for installation.
preinstall/fast:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 preinstall
.PHONY : preinstall/fast

# clear depends
depend:
	$(CMAKE_COMMAND) -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR) --check-build-system CMakeFiles/Makefile.cmake 1
.PHONY : depend

#=============================================================================
# Target rules for targets named intrinsics_gen

# Build rule for target.
intrinsics_gen: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 intrinsics_gen
.PHONY : intrinsics_gen

# fast build rule for target.
intrinsics_gen/fast:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/intrinsics_gen.dir/build.make CMakeFiles/intrinsics_gen.dir/build
.PHONY : intrinsics_gen/fast

#=============================================================================
# Target rules for targets named omp_gen

# Build rule for target.
omp_gen: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 omp_gen
.PHONY : omp_gen

# fast build rule for target.
omp_gen/fast:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/omp_gen.dir/build.make CMakeFiles/omp_gen.dir/build
.PHONY : omp_gen/fast

#=============================================================================
# Target rules for targets named acc_gen

# Build rule for target.
acc_gen: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 acc_gen
.PHONY : acc_gen

# fast build rule for target.
acc_gen/fast:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/acc_gen.dir/build.make CMakeFiles/acc_gen.dir/build
.PHONY : acc_gen/fast

#=============================================================================
# Target rules for targets named compiler

# Build rule for target.
compiler: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 compiler
.PHONY : compiler

# fast build rule for target.
compiler/fast:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/compiler.dir/build.make CMakeFiles/compiler.dir/build
.PHONY : compiler/fast

codeGen.o: codeGen.cpp.o
.PHONY : codeGen.o

# target to build an object file
codeGen.cpp.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/compiler.dir/build.make CMakeFiles/compiler.dir/codeGen.cpp.o
.PHONY : codeGen.cpp.o

codeGen.i: codeGen.cpp.i
.PHONY : codeGen.i

# target to preprocess a source file
codeGen.cpp.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/compiler.dir/build.make CMakeFiles/compiler.dir/codeGen.cpp.i
.PHONY : codeGen.cpp.i

codeGen.s: codeGen.cpp.s
.PHONY : codeGen.s

# target to generate assembly for a file
codeGen.cpp.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/compiler.dir/build.make CMakeFiles/compiler.dir/codeGen.cpp.s
.PHONY : codeGen.cpp.s

main.o: main.cpp.o
.PHONY : main.o

# target to build an object file
main.cpp.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/compiler.dir/build.make CMakeFiles/compiler.dir/main.cpp.o
.PHONY : main.cpp.o

main.i: main.cpp.i
.PHONY : main.i

# target to preprocess a source file
main.cpp.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/compiler.dir/build.make CMakeFiles/compiler.dir/main.cpp.i
.PHONY : main.cpp.i

main.s: main.cpp.s
.PHONY : main.s

# target to generate assembly for a file
main.cpp.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/compiler.dir/build.make CMakeFiles/compiler.dir/main.cpp.s
.PHONY : main.cpp.s

parser.o: parser.cpp.o
.PHONY : parser.o

# target to build an object file
parser.cpp.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/compiler.dir/build.make CMakeFiles/compiler.dir/parser.cpp.o
.PHONY : parser.cpp.o

parser.i: parser.cpp.i
.PHONY : parser.i

# target to preprocess a source file
parser.cpp.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/compiler.dir/build.make CMakeFiles/compiler.dir/parser.cpp.i
.PHONY : parser.cpp.i

parser.s: parser.cpp.s
.PHONY : parser.s

# target to generate assembly for a file
parser.cpp.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/compiler.dir/build.make CMakeFiles/compiler.dir/parser.cpp.s
.PHONY : parser.cpp.s

token.o: token.cpp.o
.PHONY : token.o

# target to build an object file
token.cpp.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/compiler.dir/build.make CMakeFiles/compiler.dir/token.cpp.o
.PHONY : token.cpp.o

token.i: token.cpp.i
.PHONY : token.i

# target to preprocess a source file
token.cpp.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/compiler.dir/build.make CMakeFiles/compiler.dir/token.cpp.i
.PHONY : token.cpp.i

token.s: token.cpp.s
.PHONY : token.s

# target to generate assembly for a file
token.cpp.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/compiler.dir/build.make CMakeFiles/compiler.dir/token.cpp.s
.PHONY : token.cpp.s

# Help Target
help:
	@echo "The following are some of the valid targets for this Makefile:"
	@echo "... all (the default if no target is provided)"
	@echo "... clean"
	@echo "... depend"
	@echo "... edit_cache"
	@echo "... rebuild_cache"
	@echo "... acc_gen"
	@echo "... intrinsics_gen"
	@echo "... omp_gen"
	@echo "... compiler"
	@echo "... codeGen.o"
	@echo "... codeGen.i"
	@echo "... codeGen.s"
	@echo "... main.o"
	@echo "... main.i"
	@echo "... main.s"
	@echo "... parser.o"
	@echo "... parser.i"
	@echo "... parser.s"
	@echo "... token.o"
	@echo "... token.i"
	@echo "... token.s"
.PHONY : help



#=============================================================================
# Special targets to cleanup operation of make.

# Special rule to run CMake to check the build system integrity.
# No rule that depends on this can have commands that come from listfiles
# because they might be regenerated.
cmake_check_build_system:
	$(CMAKE_COMMAND) -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR) --check-build-system CMakeFiles/Makefile.cmake 0
.PHONY : cmake_check_build_system
