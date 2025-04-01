cmake_minimum_required(VERSION 3.10)
project(natural/caustics)

set(EXEC caustics)

# EXECUTABLE
file(GLOB_RECURSE SOURCES *.cpp *.c ${CMAKE_HOME_DIRECTORY}/include/*.cpp ${CMAKE_HOME_DIRECTORY}/include/*.c)
add_executable(${EXEC} ${SOURCES})
target_include_directories(${EXEC} PRIVATE ${CMAKE_HOME_DIRECTORY}/include)

# LIBRARIES
target_link_libraries(${EXEC} glfw)
target_link_libraries(${EXEC} OpenGL::GL ${OPEN_GL_LIBRARIES})
target_link_libraries(${EXEC} glm::glm)

target_link_libraries(${EXEC} imgui)
target_include_directories(${EXEC} PRIVATE ${IMGUI_SOURCE_DIR} ${IMGUI_SOURCE_DIR}/backends)

# COPYING SHADERS
add_custom_command(
         TARGET ${EXEC}
         POST_BUILD
         COMMAND ${CMAKE_COMMAND} -E copy_directory              
             ${CMAKE_CURRENT_SOURCE_DIR}/shaders 
             ${CMAKE_CURRENT_BINARY_DIR}/shaders
         COMMENT "Copying shaders" VERBATIM
)