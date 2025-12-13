cmake_minimum_required(VERSION 3.20)
project(Lott-LIBS)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(ALL_SUBS_BUILD_ON ON)

option(BUILD_GODOT "Build with Godot support" ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

include(FetchContent)


# Fetch godot-cpp bindings
if(BUILD_GODOT)
    FetchContent_Declare(
            GDExtension
            GIT_REPOSITORY https://github.com/godotengine/godot-cpp.git
            GIT_TAG godot-4.3-stable
    )
endif()

# Fetch and add Libs FIRST
FetchContent_Declare(
    Libs
    GIT_REPOSITORY https://github.com/TamToucan/Libs.git
    GIT_TAG main
)

if(BUILD_GODOT)
    FetchContent_MakeAvailable(GDExtension Libs)
else()
    FetchContent_MakeAvailable(Libs)
endif()

# Then add submodules — they will NOT fetch Libs due to ALL_SUBS_BUILD_ON
add_subdirectory(Tracker-LIB)
add_subdirectory(Maze-LIB)
add_subdirectory(Cave-LIB)
add_subdirectory(DistanceMap-LIB)

add_subdirectory(test)

# Custom targets
add_custom_target(core)
add_dependencies(core TrackerLib::Tracker maze cave distanceMap)

if(BUILD_GODOT)
    add_custom_target(godot)
    add_dependencies(godot GDDistanceMap TrackerLib::GDTracker GDMaze GDCave core)
endif()


