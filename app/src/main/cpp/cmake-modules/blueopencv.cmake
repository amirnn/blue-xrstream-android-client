# blueopencv

# "sdk/native/jni/OpenCVConfig.cmake"

set(DEPENDENCIES_DIR "${CMAKE_SOURCE_DIR}/../../../../deps")
set(BLUEOPENCV_SRC_DIR "${DEPENDENCIES_DIR}/blueopencv")
set(BLUEOPENCV_BUILD_DIR "${CMAKE_BINARY_DIR}/deps/opencv/build")
set(BLUEOPENCV_INSTALL_DIR "${CMAKE_BINARY_DIR}/deps/opencv/install")

ExternalProject_Add(blueopencv
        SOURCE_DIR        "${BLUEOPENCV_SRC_DIR}"
        BINARY_DIR        "${BLUEOPENCV_BUILD_DIR}"
        INSTALL_DIR       "${BLUEOPENCV_INSTALL_DIR}"
        CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=$<IF:$<CONFIG:>,$<CONFIG>,${CMAKE_BUILD_TYPE}>
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        # pass only the options you want — nothing leaks back
        # -DFOO_BUILD_TESTS:BOOL=OFF
        # -DFOO_BUILD_EXAMPLES:BOOL=OFF
        -DBUILD_TESTS=OFF
        -DBUILD_PERF_TESTS=OFF
        -DBUILD_EXAMPLES=OFF
        -DOPENCV_TEST_DNN_TFLITE=OFF
        -DBUILD_ANDROID_EXAMPLES=OFF
        -DBUILD_ANDROID_PROJECTS=OFF
        BUILD_BYPRODUCTS  "<INSTALL_DIR>/sdk/native/jni/OpenCVConfig.cmake"
        INSTALL_COMMAND   "${CMAKE_COMMAND}" --build <BINARY_DIR> --target install
)
unset(BLUEOPENCV_INSTALL_DIR)
unset(BLUEOPENCV_BUILD_DIR)
unset(BLUEOPENCV_SRC_DIR)
unset(DEPENDENCIES_DIR)
