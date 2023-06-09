# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.23

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

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

# Include any dependencies generated for this target.
include CMakeFiles/compiler.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/compiler.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/compiler.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/compiler.dir/flags.make

parser.cpp: parser.y
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/liu/compiler/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "[BISON][parser] Building parser with bison 3.0.4"
	/usr/bin/bison -d -o /home/liu/compiler/parser.cpp /home/liu/compiler/parser.y

parser.hpp: parser.cpp
	@$(CMAKE_COMMAND) -E touch_nocreate parser.hpp

token.cpp: token.l
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/liu/compiler/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "[FLEX][lexer] Building scanner with flex 2.6.4"
	/usr/bin/flex -o/home/liu/compiler/token.cpp /home/liu/compiler/token.l

CMakeFiles/compiler.dir/parser.cpp.o: CMakeFiles/compiler.dir/flags.make
CMakeFiles/compiler.dir/parser.cpp.o: parser.cpp
CMakeFiles/compiler.dir/parser.cpp.o: CMakeFiles/compiler.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/liu/compiler/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/compiler.dir/parser.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/compiler.dir/parser.cpp.o -MF CMakeFiles/compiler.dir/parser.cpp.o.d -o CMakeFiles/compiler.dir/parser.cpp.o -c /home/liu/compiler/parser.cpp

CMakeFiles/compiler.dir/parser.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/compiler.dir/parser.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/liu/compiler/parser.cpp > CMakeFiles/compiler.dir/parser.cpp.i

CMakeFiles/compiler.dir/parser.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/compiler.dir/parser.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/liu/compiler/parser.cpp -o CMakeFiles/compiler.dir/parser.cpp.s

CMakeFiles/compiler.dir/token.cpp.o: CMakeFiles/compiler.dir/flags.make
CMakeFiles/compiler.dir/token.cpp.o: token.cpp
CMakeFiles/compiler.dir/token.cpp.o: parser.hpp
CMakeFiles/compiler.dir/token.cpp.o: CMakeFiles/compiler.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/liu/compiler/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object CMakeFiles/compiler.dir/token.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/compiler.dir/token.cpp.o -MF CMakeFiles/compiler.dir/token.cpp.o.d -o CMakeFiles/compiler.dir/token.cpp.o -c /home/liu/compiler/token.cpp

CMakeFiles/compiler.dir/token.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/compiler.dir/token.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/liu/compiler/token.cpp > CMakeFiles/compiler.dir/token.cpp.i

CMakeFiles/compiler.dir/token.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/compiler.dir/token.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/liu/compiler/token.cpp -o CMakeFiles/compiler.dir/token.cpp.s

CMakeFiles/compiler.dir/codeGen.cpp.o: CMakeFiles/compiler.dir/flags.make
CMakeFiles/compiler.dir/codeGen.cpp.o: codeGen.cpp
CMakeFiles/compiler.dir/codeGen.cpp.o: CMakeFiles/compiler.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/liu/compiler/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object CMakeFiles/compiler.dir/codeGen.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/compiler.dir/codeGen.cpp.o -MF CMakeFiles/compiler.dir/codeGen.cpp.o.d -o CMakeFiles/compiler.dir/codeGen.cpp.o -c /home/liu/compiler/codeGen.cpp

CMakeFiles/compiler.dir/codeGen.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/compiler.dir/codeGen.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/liu/compiler/codeGen.cpp > CMakeFiles/compiler.dir/codeGen.cpp.i

CMakeFiles/compiler.dir/codeGen.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/compiler.dir/codeGen.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/liu/compiler/codeGen.cpp -o CMakeFiles/compiler.dir/codeGen.cpp.s

CMakeFiles/compiler.dir/main.cpp.o: CMakeFiles/compiler.dir/flags.make
CMakeFiles/compiler.dir/main.cpp.o: main.cpp
CMakeFiles/compiler.dir/main.cpp.o: CMakeFiles/compiler.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/liu/compiler/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object CMakeFiles/compiler.dir/main.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/compiler.dir/main.cpp.o -MF CMakeFiles/compiler.dir/main.cpp.o.d -o CMakeFiles/compiler.dir/main.cpp.o -c /home/liu/compiler/main.cpp

CMakeFiles/compiler.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/compiler.dir/main.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/liu/compiler/main.cpp > CMakeFiles/compiler.dir/main.cpp.i

CMakeFiles/compiler.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/compiler.dir/main.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/liu/compiler/main.cpp -o CMakeFiles/compiler.dir/main.cpp.s

# Object files for target compiler
compiler_OBJECTS = \
"CMakeFiles/compiler.dir/parser.cpp.o" \
"CMakeFiles/compiler.dir/token.cpp.o" \
"CMakeFiles/compiler.dir/codeGen.cpp.o" \
"CMakeFiles/compiler.dir/main.cpp.o"

# External object files for target compiler
compiler_EXTERNAL_OBJECTS =

compiler: CMakeFiles/compiler.dir/parser.cpp.o
compiler: CMakeFiles/compiler.dir/token.cpp.o
compiler: CMakeFiles/compiler.dir/codeGen.cpp.o
compiler: CMakeFiles/compiler.dir/main.cpp.o
compiler: CMakeFiles/compiler.dir/build.make
compiler: /usr/local/lib/libLLVMAnalysis.a
compiler: /usr/local/lib/libLLVMCore.a
compiler: /usr/local/lib/libLLVMExecutionEngine.a
compiler: /usr/local/lib/libLLVMInstCombine.a
compiler: /usr/local/lib/libLLVMObject.a
compiler: /usr/local/lib/libLLVMOrcJIT.a
compiler: /usr/local/lib/libLLVMRuntimeDyld.a
compiler: /usr/local/lib/libLLVMScalarOpts.a
compiler: /usr/local/lib/libLLVMSupport.a
compiler: /usr/local/lib/libLLVMIRReader.a
compiler: /usr/local/lib/libLLVMMCJIT.a
compiler: /usr/local/lib/libLLVMX86CodeGen.a
compiler: /usr/local/lib/libLLVMX86AsmParser.a
compiler: /usr/local/lib/libLLVMX86Desc.a
compiler: /usr/local/lib/libLLVMX86Disassembler.a
compiler: /usr/local/lib/libLLVMX86Info.a
compiler: /usr/local/lib/libLLVMPasses.a
compiler: /usr/local/lib/libLLVMCoroutines.a
compiler: /usr/local/lib/libLLVMHelloNew.a
compiler: /usr/local/lib/libLLVMipo.a
compiler: /usr/local/lib/libLLVMIRReader.a
compiler: /usr/local/lib/libLLVMAsmParser.a
compiler: /usr/local/lib/libLLVMFrontendOpenMP.a
compiler: /usr/local/lib/libLLVMLinker.a
compiler: /usr/local/lib/libLLVMObjCARCOpts.a
compiler: /usr/local/lib/libLLVMVectorize.a
compiler: /usr/local/lib/libLLVMInstrumentation.a
compiler: /usr/local/lib/libLLVMJITLink.a
compiler: /usr/local/lib/libLLVMOrcTargetProcess.a
compiler: /usr/local/lib/libLLVMOrcShared.a
compiler: /usr/local/lib/libLLVMExecutionEngine.a
compiler: /usr/local/lib/libLLVMRuntimeDyld.a
compiler: /usr/local/lib/libLLVMAsmPrinter.a
compiler: /usr/local/lib/libLLVMDebugInfoDWARF.a
compiler: /usr/local/lib/libLLVMGlobalISel.a
compiler: /usr/local/lib/libLLVMSelectionDAG.a
compiler: /usr/local/lib/libLLVMCodeGen.a
compiler: /usr/local/lib/libLLVMScalarOpts.a
compiler: /usr/local/lib/libLLVMInstCombine.a
compiler: /usr/local/lib/libLLVMAggressiveInstCombine.a
compiler: /usr/local/lib/libLLVMTarget.a
compiler: /usr/local/lib/libLLVMTransformUtils.a
compiler: /usr/local/lib/libLLVMBitWriter.a
compiler: /usr/local/lib/libLLVMAnalysis.a
compiler: /usr/local/lib/libLLVMProfileData.a
compiler: /usr/local/lib/libLLVMObject.a
compiler: /usr/local/lib/libLLVMBitReader.a
compiler: /usr/local/lib/libLLVMTextAPI.a
compiler: /usr/local/lib/libLLVMCFGuard.a
compiler: /usr/local/lib/libLLVMCore.a
compiler: /usr/local/lib/libLLVMRemarks.a
compiler: /usr/local/lib/libLLVMBitstreamReader.a
compiler: /usr/local/lib/libLLVMMCParser.a
compiler: /usr/local/lib/libLLVMMCDisassembler.a
compiler: /usr/local/lib/libLLVMMC.a
compiler: /usr/local/lib/libLLVMBinaryFormat.a
compiler: /usr/local/lib/libLLVMDebugInfoCodeView.a
compiler: /usr/local/lib/libLLVMDebugInfoMSF.a
compiler: /usr/local/lib/libLLVMSupport.a
compiler: /usr/local/lib/libLLVMDemangle.a
compiler: CMakeFiles/compiler.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/liu/compiler/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Linking CXX executable compiler"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/compiler.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/compiler.dir/build: compiler
.PHONY : CMakeFiles/compiler.dir/build

CMakeFiles/compiler.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/compiler.dir/cmake_clean.cmake
.PHONY : CMakeFiles/compiler.dir/clean

CMakeFiles/compiler.dir/depend: parser.cpp
CMakeFiles/compiler.dir/depend: parser.hpp
CMakeFiles/compiler.dir/depend: token.cpp
	cd /home/liu/compiler && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/liu/compiler /home/liu/compiler /home/liu/compiler /home/liu/compiler /home/liu/compiler/CMakeFiles/compiler.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/compiler.dir/depend

