# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

cmake_minimum_required(VERSION 4.1.0)

project(
        "bluexrstream"
        LANGUAGES CXX
        VERSION 1.0.0)

set(DEPENDENCIES_DIR "../../../../deps")

# BlueXR
add_subdirectory(
        ${DEPENDENCIES_DIR}/bluexr
        ${CMAKE_BINARY_DIR}/deps/bluexr-build # where to build
)

# BlueDataChannel
set(OPENSSL_CRYPTO_LIBRARY "${ANDROID_OPENSSL_ROOT}/${ANDROID_ABI}/libcrypto.a")
set(OPENSSL_SSL_LIBRARY    "${ANDROID_OPENSSL_ROOT}/${ANDROID_ABI}/libssl.a")
add_subdirectory(
        ${DEPENDENCIES_DIR}/bluedatachannel
        ${CMAKE_BINARY_DIR}/deps/bluedatachannel-build # where to build
)

# BlueOpenCV
add_subdirectory(
        ${DEPENDENCIES_DIR}/blueopencv
        ${CMAKE_BINARY_DIR}/deps/blueopencv-build # where to build
)

if(${GRADLE_BUILD_INITITIATED})
        set(GAME_ACTIVITY_STRING game-activity::game-activity)
        # Searches for a package provided by the game activity dependency
        find_package(game-activity REQUIRED CONFIG)
else()
        # ----------------------
        # Download and unpack GameActivity AAR
        # ----------------------
        set(GAME_ACTIVITY_VERSION "4.0.0")
        set(GAME_ACTIVITY_FILENAME "games-activity-${GAME_ACTIVITY_VERSION}.aar")
        set(GAME_ACTIVITY_URL "https://dl.google.com/dl/android/maven2/androidx/games/games-activity/${GAME_ACTIVITY_VERSION}/${GAME_ACTIVITY_FILENAME}")
        set(GAME_ACTIVITY_DOWNLOAD_DIR "${CMAKE_BINARY_DIR}/downloads")
        set(GAME_ACTIVITY_AAR_PATH "${GAME_ACTIVITY_DOWNLOAD_DIR}/${GAME_ACTIVITY_FILENAME}")
        file(MAKE_DIRECTORY "${GAME_ACTIVITY_DOWNLOAD_DIR}")
        if(NOT EXISTS "${GAME_ACTIVITY_AAR_PATH}")
                message(STATUS "Downloading GameActivity AAR...")
                file(DOWNLOAD "${GAME_ACTIVITY_URL}" "${GAME_ACTIVITY_AAR_PATH}" SHOW_PROGRESS)
        endif()
        set(GAME_ACTIVITY_UNPACK_DIR "${CMAKE_BINARY_DIR}/game-activity")
        file(MAKE_DIRECTORY "${GAME_ACTIVITY_UNPACK_DIR}")
        file(ARCHIVE_EXTRACT INPUT "${GAME_ACTIVITY_AAR_PATH}" DESTINATION "${GAME_ACTIVITY_UNPACK_DIR}")

        # ----------------------
        # Import GameActivity native library
        # ----------------------
        message(STATUS "Unpack dir is: ${GAME_ACTIVITY_UNPACK_DIR}")
        add_library(game_activity_static STATIC IMPORTED GLOBAL)
        set_target_properties(game_activity_static PROPERTIES
                #/prefab/modules/game-activity/libs/android.arm64-v8a/libgame-activity.a
                IMPORTED_LOCATION "${GAME_ACTIVITY_UNPACK_DIR}/prefab/modules/game-activity_static/libs/android.${ANDROID_ABI}/libgame-activity_static.a"
                INTERFACE_INCLUDE_DIRECTORIES "${GAME_ACTIVITY_UNPACK_DIR}/prefab/modules/game-activity_static/include"
        )
        set(GAME_ACTIVITY_STRING game_activity_static)
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
        openxr_loader
        ${OpenCV_LIBS}
        datachannel
)
