project(LottLibsTest)

add_executable(LottLibsTest main.cpp)

# Link against the cave library
target_link_libraries(LottLibsTest PRIVATE Cave DistanceMap)

add_custom_command(TARGET LottLibsTest POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:Cave>
        $<TARGET_FILE_DIR:LottLibsTest>
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:DistanceMap>
        $<TARGET_FILE_DIR:LottLibsTest>
)
