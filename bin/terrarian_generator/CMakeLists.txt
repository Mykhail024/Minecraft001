cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

set(PROJECT_NAME terrarian_generator CXX)

set(CMAKE_BUILD_TYPE "Release")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_COMPILER "clang++")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2")

project(${PROJECT_NAME})

add_subdirectory(godot-cpp)

add_library(${PROJECT_NAME} SHARED
    src/Chunk.cpp
    src/register_types.cpp
)

target_include_directories(${PROJECT_NAME} PUBLIC ./godot-cpp/gen/include)
target_include_directories(${PROJECT_NAME} PUBLIC ./godot-cpp/include)
target_include_directories(${PROJECT_NAME} PUBLIC ./godot-cpp/gdextension)
