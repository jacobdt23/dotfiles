cmake_minimum_required(VERSION 3.16)
project(ControlCenterCpp)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Widgets Core Gui)

add_executable(control_center_cpp control_center.cpp)
target_link_libraries(control_center_cpp PRIVATE Qt6::Widgets Qt6::Core Qt6::Gui)

