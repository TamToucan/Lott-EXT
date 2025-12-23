cmake_minimum_required(VERSION 3.20)
project(Lott-LIBS)

# --- 1. Global Options & Flags ---
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# This flag tells submodules (Maze, Cave, etc.) to SKIP their own dependency fetching
# because Lott-Libs is handling it globally.
set(ALL_SUBS_BUILD_ON ON)

option(BUILD_GODOT "Build with Godot support" ON)
option(BUILD_CUTE "Build with Cute Framework support" ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
endif()

include(FetchContent)

# --- 2. Dependencies: Godot (FetchContent) ---
if(BUILD_GODOT)
    FetchContent_Declare(
            GDExtension
            GIT_REPOSITORY https://github.com/godotengine/godot-cpp.git
            GIT_TAG godot-4.3-stable
    )
endif()

# --- 3. Dependencies: Common Libs (FetchContent) ---
FetchContent_Declare(
    Libs
    GIT_REPOSITORY https://github.com/TamToucan/Libs.git
    GIT_TAG main
)

# Make dependencies available globally
if(BUILD_GODOT)
    FetchContent_MakeAvailable(GDExtension Libs)
else()
    FetchContent_MakeAvailable(Libs)
endif()

# --- 4. Dependencies: Cute Framework (Local / Manual) ---
if(BUILD_CUTE)
    set(CUTE_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/deps/cute")
    if(EXISTS "${CUTE_ROOT}/lib/libcute.a")
        message(STATUS "[Lott-Libs] Manual Cute Framework detection: FOUND at ${CUTE_ROOT}")
        # Define as 'cute_lib' to avoid conflict with the aggregation target 'cute'
        add_library(cute_lib STATIC IMPORTED GLOBAL)
        set_target_properties(cute_lib PROPERTIES
            IMPORTED_LOCATION "${CUTE_ROOT}/lib/libcute.a"
            INTERFACE_INCLUDE_DIRECTORIES "${CUTE_ROOT}/include;${CUTE_ROOT}"
        )

        # Handle static dependencies
        file(GLOB CUTE_DEPENDENCIES "${CUTE_ROOT}/lib/*.a")
        list(REMOVE_ITEM CUTE_DEPENDENCIES "${CUTE_ROOT}/lib/libcute.a")
        set_target_properties(cute_lib PROPERTIES INTERFACE_LINK_LIBRARIES "${CUTE_DEPENDENCIES}")
        set(CUTE_FOUND ON)
    else()
        message(WARNING "[Lott-Libs] Cute Framework NOT FOUND in deps/cute. Disabling BUILD_CUTE.")
        set(BUILD_CUTE OFF)
    endif()
endif()

# --- 5. Add Submodules ---
# These directories must contain their own CMakeLists.txt (see Maze-LIB below)
add_subdirectory(Tracker-LIB)
add_subdirectory(Maze-LIB)
add_subdirectory(Cave-LIB)
add_subdirectory(DistanceMap-LIB)

# Test suite (if you have a top-level test folder)
add_subdirectory(test)

# --- 6. Custom Aggregation Targets ---
# These targets group the submodule targets for easy building

# A. CORE (Pure C++)
add_custom_target(core)
# Depends on the specific library targets defined in submodules
add_dependencies(core TrackerLib::Tracker Maze Cave DistanceMap)

# B. GODOT (Extension)
if(BUILD_GODOT)
    add_custom_target(godot)
    add_dependencies(godot GDDistanceMap GDTracker GDMaze GDCave core)
endif()

# C. CUTE (New Framework)
if(BUILD_CUTE)
    add_custom_target(cute)
    add_dependencies(cute CuteDistanceMap CuteTracker CuteMaze CuteCave core)
endif()
