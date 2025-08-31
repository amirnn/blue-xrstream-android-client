# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

cmake_minimum_required(VERSION 4.1.0)

project(
        "bluexrstream"
        LANGUAGES CXX
        VERSION 1.0.0)

set(CMAKE_OBJECT_PATH_MAX 1000)

include(ExternalProject)

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules/blueopencv.cmake")
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules/bluedatachannel.cmake")
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules/bluexr.cmake")
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules/app.cmake")
