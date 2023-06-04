cmake_minimum_required(VERSION 3.19.0)
project(compiler)

set (CMAKE_CXX_STANDARD 14)
set (CMAKE_CXX_FLAGS '-g')
set (CMAKE_BUILD_TYPE Debug)

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)
find_package(LLVM REQUIRED)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")


bison_target(parser "${CMAKE_CURRENT_SOURCE_DIR}/parser.y" "${CMAKE_CURRENT_SOURCE_DIR}/parser.cpp")
flex_target(lexer "${CMAKE_CURRENT_SOURCE_DIR}/token.l" "${CMAKE_CURRENT_SOURCE_DIR}/token.cpp")

ADD_FLEX_BISON_DEPENDENCY(lexer parser)

include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${PROJECT_SOURCE_DIR})

add_executable(compiler ${BISON_parser_OUTPUTS} ${FLEX_lexer_OUTPUTS} codeGen.cpp main.cpp )

llvm_map_components_to_libnames(llvm_libs analysis core executionengine instcombine object orcjit runtimedyld scalaropts support native irreader mcjit)

target_link_libraries(compiler ${llvm_libs})