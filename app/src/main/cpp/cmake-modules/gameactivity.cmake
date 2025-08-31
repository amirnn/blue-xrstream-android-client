# gameactivity

# ----------------------
# Download and unpack GameActivity AAR
# ----------------------
set(GAME_ACTIVITY_VERSION "4.0.0")
set(GAME_ACTIVITY_FILENAME "games-activity-${GAME_ACTIVITY_VERSION}.aar")
set(GAME_ACTIVITY_URL "https://dl.google.com/dl/android/maven2/androidx/games/games-activity/${GAME_ACTIVITY_VERSION}/${GAME_ACTIVITY_FILENAME}")
set(GAME_ACTIVITY_DOWNLOAD_DIR "${CMAKE_BINARY_DIR}/downloads")
set(GAME_ACTIVITY_AAR_PATH "${GAME_ACTIVITY_DOWNLOAD_DIR}/${GAME_ACTIVITY_FILENAME}")
file(MAKE_DIRECTORY "${GAME_ACTIVITY_DOWNLOAD_DIR}")
if (NOT EXISTS "${GAME_ACTIVITY_AAR_PATH}")
    message(STATUS "Downloading GameActivity AAR...")
    file(DOWNLOAD "${GAME_ACTIVITY_URL}" "${GAME_ACTIVITY_AAR_PATH}" SHOW_PROGRESS)
endif ()
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
