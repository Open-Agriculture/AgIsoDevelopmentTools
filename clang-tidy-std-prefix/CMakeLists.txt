cmake_minimum_required(VERSION 3.15)
project(clang_tidy_std_prefix LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

find_package(LLVM REQUIRED CONFIG)
find_package(Clang REQUIRED CONFIG)

include_directories(${LLVM_INCLUDE_DIRS} ${CLANG_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

add_library(clangTidyStdPrefixPlugin SHARED
  StdFixedIntPrefixCheck.cpp
  StdPrefixModule.cpp
)

target_link_libraries(clangTidyStdPrefixPlugin
  PRIVATE
    clangTidy
    clang-cpp
)

set_target_properties(clangTidyStdPrefixPlugin PROPERTIES
  OUTPUT_NAME "clangTidyStdPrefixPlugin"
)
