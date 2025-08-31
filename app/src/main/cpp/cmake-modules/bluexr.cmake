# bluexr

# "lib/cmake/openxr/OpenXRConfig.cmake"

set(DEPENDENCIES_DIR "${CMAKE_SOURCE_DIR}/../../../../deps")
set(BLUEXR_SRC_DIR "${DEPENDENCIES_DIR}/bluexr")
set(BLUEXR_BUILD_DIR "${CMAKE_BINARY_DIR}/deps/openxr/build")
set(BLUEXR_INSTALL_DIR "${CMAKE_BINARY_DIR}/deps/openxr/install")

ExternalProject_Add(bluexr
        SOURCE_DIR        "${BLUEXR_SRC_DIR}"
        BINARY_DIR        "${BLUEXR_BUILD_DIR}"
        INSTALL_DIR       "${BLUEXR_INSTALL_DIR}"
        CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=$<IF:$<CONFIG:>,$<CONFIG>,${CMAKE_BUILD_TYPE}>
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        # pass only the options you want — nothing leaks back
        # -DFOO_BUILD_TESTS:BOOL=OFF
        # -DFOO_BUILD_EXAMPLES:BOOL=OFF
        BUILD_BYPRODUCTS  "<INSTALL_DIR>/lib/cmake/openxr/OpenXRConfig.cmake"
        INSTALL_COMMAND   "${CMAKE_COMMAND}" --build <BINARY_DIR> --target install
)

unset(BLUEXR_INSTALL_DIR)
unset(BLUEXR_BUILD_DIR)
unset(BLUEXR_SRC_DIR)
unset(DEPENDENCIES_DIR)