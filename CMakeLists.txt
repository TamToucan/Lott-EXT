cmake_minimum_required(VERSION 3.20)
project(Lott-EXT)
set(ALL_SUBS_BUILD_ON ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

include(FetchContent)

# Fetch godot-cpp bindings
FetchContent_Declare(
        GDExtension
        GIT_REPOSITORY https://github.com/godotengine/godot-cpp.git
        GIT_TAG godot-4.3-stable
)

# Fetch and add Libs FIRST
FetchContent_Declare(
    Libs
    GIT_REPOSITORY https://github.com/TamToucan/Libs.git
    GIT_TAG main
)

FetchContent_MakeAvailable(GDExtension Libs)

# Then add submodules — they will NOT fetch Libs due to ALL_SUBS_BUILD_ON
add_subdirectory(GDTracker-EXT)
add_subdirectory(GDMaze-EXT)
add_subdirectory(GDCave-EXT)
add_subdirectory(GDDistanceMap-EXT)


