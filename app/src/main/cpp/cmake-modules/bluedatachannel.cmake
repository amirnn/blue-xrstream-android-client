# bluedatachannel

# "lib/cmake/LibDataChannel/LibDataChannelConfig.cmake"

set(DEPENDENCIES_DIR "${CMAKE_SOURCE_DIR}/../../../../deps")
set(BLUEDATACHANNEL_SRC_DIR "${DEPENDENCIES_DIR}/bluedatachannel")
set(BLUEDATACHANNEL_BUILD_DIR "${CMAKE_BINARY_DIR}/deps/bluedatachannel")
set(BLUEDATACHANNEL_INSTALL_DIR "${CMAKE_BINARY_DIR}/deps/bluedatachannel")

set(OPENSSL_CRYPTO_LIBRARY "${ANDROID_OPENSSL_ROOT}/${ANDROID_ABI}/libcrypto.a")
set(OPENSSL_SSL_LIBRARY "${ANDROID_OPENSSL_ROOT}/${ANDROID_ABI}/libssl.a")

ExternalProject_Add(bluedatachannel
        SOURCE_DIR        "${BLUEDATACHANNEL_SRC_DIR}"
        BINARY_DIR        "${BLUEDATACHANNEL_BUILD_DIR}"
        INSTALL_DIR       "${BLUEDATACHANNEL_INSTALL_DIR}"
        CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=$<IF:$<CONFIG:>,$<CONFIG>,${CMAKE_BUILD_TYPE}>
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        # pass only the options you want — nothing leaks back
        # -DFOO_BUILD_TESTS:BOOL=OFF
        # -DFOO_BUILD_EXAMPLES:BOOL=OFF
        -DOPENSSL_CRYPTO_LIBRARY=$ENV{ANDROID_SDK_PATH}/android_openssl/ssl_3/arm64-v8a/libcrypto.a
        -DOPENSSL_SSL_LIBRARY=$ENV{ANDROID_SDK_PATH}/android_openssl/ssl_3/arm64-v8a/libssl.a
        -DOPENSSL_INCLUDE_DIR=$ENV{ANDROID_SDK_PATH}/android_openssl/ssl_3/include
        BUILD_BYPRODUCTS  "<INSTALL_DIR>/lib/cmake/LibDataChannel/LibDataChannelConfig.cmake"
        INSTALL_COMMAND   "${CMAKE_COMMAND}" --build <BINARY_DIR> --target install
)
unset(BLUEDATACHANNEL_INSTALL_DIR)
unset(BLUEDATACHANNEL_BUILD_DIR)
unset(BLUEDATACHANNEL_SRC_DIR)
unset(DEPENDENCIES_DIR)