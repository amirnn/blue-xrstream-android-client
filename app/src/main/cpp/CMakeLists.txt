# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

cmake_minimum_required(VERSION 4.1.0)

project(
        "bluexrstream"
        LANGUAGES CXX
        VERSION 1.0.0)


include(ExternalProject)

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules/blueopencv.cmake")
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules/bluedatachannel.cmake")
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules/bluexr.cmake")

if(${GRADLE_BUILD})
        set(GAME_ACTIVITY_LIB_STRING game-activity::game-activity)
        # Searches for a package provided by the game activity dependency
        find_package(game-activity REQUIRED CONFIG)
else()
        set(GAME_ACTIVITY_LIB_STRING "game_activity_static")
        # Gradle will download the gameactivity itself as a preset, in independent builds from android studio I perform
        # this task myself
        include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/gameactivity.cmake")
endif()

# Creates your game shared library. The name must be the same as the one used
# for loading in your Kotlin/Java or AndroidManifest.txt files.
add_library(bluexrstream SHARED)
target_include_directories(bluexrstream PRIVATE "include")
target_sources(
        bluexrstream PRIVATE src/main.cpp src/AndroidOut.cpp src/Renderer.cpp
        src/Shader.cpp src/TextureAsset.cpp src/Utility.cpp)



# -u SYMBOL (or --undefined=SYMBOL): This linker option tells the linker to
# treat the specified SYMBOL as if it were undefined. This is often used to
# force the linker to include a specific object file or library that defines
# this symbol, even if the linker doesn't initially see any direct references to
# it from the code being linked. In essence, this line of CMake code is telling
# the linker:"When you are linking the shared library, make sure to include the
# native code that defines the JNI function
# Java_com_google_androidgamesdk_GameActivity_initializeNativeCode. Even if you
# don't see any other part of the native code directly calling this function,
# treat it as essential and link it in."Why is this done?This is a common
# practice when using GameActivity from the Android Game Development Kit (AGDK).
# GameActivity is a Jetpack library that helps simplify the integration of C/C++
# game engines with Android.The initializeNativeCode JNI function is often
# implemented in your native C/C++ code and is called by the GameActivity Java
# class early in its lifecycle (typically from its onCreate or a similar
# lifecycle method) to set up the native side of your game. By explicitly telling
# the linker to include this symbol, you ensure that the necessary native
# initialization code is present in the final shared library and can be
# correctly called by the Java side of GameActivity when your app starts.
# Without this, the linker might optimize away the initializeNativeCode function
# if it doesn't see direct calls to it within the native code itself, leading to
# runtime errors when GameActivity tries to call it.
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -u \
    Java_com_google_androidgamesdk_GameActivity_initializeNativeCode")

# Configure libraries CMake uses to link your target library.
target_link_libraries(
        bluexrstream
        # The game activity
        ${GAME_ACTIVITY_STRING}
        # EGL and other dependent libraries required for drawing and interacting with
        # Android system
        EGL
        GLESv3
        jnigraphics
        android
        log
        #
        # openxr_loader
        # ${OpenCV_LIBS}
        # datachannel
)
