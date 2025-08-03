cmake_minimum_required(VERSION 3.20)
project(Lott-EXT)

set(FETCHCONTENT_QUIET OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_VERBOSE_MAKEFILE ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(FETCHCONTENT_BASE_DIR ${CMAKE_BINARY_DIR}/_deps)

# Add GDTracker
add_subdirectory(GDCave-EXT)
add_subdirectory(GDMaze-EXT)
add_subdirectory(GDTracker-EXT)
add_subdirectory(GDDistanceMap-EXT)

