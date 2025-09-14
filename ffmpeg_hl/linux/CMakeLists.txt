# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

# Project-level configuration.
set(PROJECT_NAME "ffmpeg_hl")
project(${PROJECT_NAME} LANGUAGES CXX)

# 指定 FFmpeg 安装目录，并将目录赋值给 FFMPEG_DEV_ROOT 变量，方便后续指令引用
set(FFMPEG_DEV_ROOT "/home/moli/.vmr/versions/ffmpeg_versions/ffmpeg")

# This value is used when generating builds using this plugin, so it must
# not be changed.
set(PLUGIN_NAME "ffmpeg_hl_plugin")

# Any new source files that you add to the plugin should be added here.
list(APPEND PLUGIN_SOURCES
  "ffmpeg_hl_plugin.cc"
  "ffmpeg/ffmpeg_merge.cpp"
  "ffmpeg/ffmpeg_merge.h"
)

# Define the plugin library target. Its name must not be changed (see comment
# on PLUGIN_NAME above).
add_library(${PLUGIN_NAME} SHARED
  ${PLUGIN_SOURCES}
)

# Apply a standard set of build settings that are configured in the
# application-level CMakeLists.txt. This can be removed for plugins that want
# full control over build settings.
apply_standard_settings(${PLUGIN_NAME})

# Symbols are hidden by default to reduce the chance of accidental conflicts
# between plugins. This should not be removed; any symbols that should be
# exported should be explicitly exported with the FLUTTER_PLUGIN_EXPORT macro.
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

# Source include directories and library dependencies. Add any plugin-specific
# dependencies here.

# 指定 FFmpeg 头文件目录
include_directories(${FFMPEG_DEV_ROOT}/include)

target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")

# 指定链接器查找库文件  FFmpeg
link_directories(${FFMPEG_DEV_ROOT}/lib)

target_link_libraries(${PLUGIN_NAME} PRIVATE
        flutter
)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GTK)

# 真正的 so 文件
set(FFMPEG_REAL_LIBS
        ${FFMPEG_DEV_ROOT}/lib/libavformat.so.58.45.100
        ${FFMPEG_DEV_ROOT}/lib/libavcodec.so.58.91.100
        ${FFMPEG_DEV_ROOT}/lib/libavutil.so.56.51.100
        ${FFMPEG_DEV_ROOT}/lib/libswresample.so.3.7.100
        ${FFMPEG_DEV_ROOT}/lib/libx264.so.161
        ${FFMPEG_DEV_ROOT}/lib/libopenh264.so.2.1.1
        ${FFMPEG_DEV_ROOT}/lib/libbz2.so.1.0.8
)

# 对应的符号链接（运行时 loader 要找的名字）
set(FFMPEG_SYMLINKS
        ${FFMPEG_DEV_ROOT}/lib/libavformat.so.58
        ${FFMPEG_DEV_ROOT}/lib/libavcodec.so.58
        ${FFMPEG_DEV_ROOT}/lib/libavutil.so.56
        ${FFMPEG_DEV_ROOT}/lib/libswresample.so.3
        ${FFMPEG_DEV_ROOT}/lib/libx264.so.161
        ${FFMPEG_DEV_ROOT}/lib/libopenh264.so.6
        ${FFMPEG_DEV_ROOT}/lib/libbz2.so.1.0
)

# 链接 FFmpeg 3 个核心库
target_link_libraries(${PLUGIN_NAME} PRIVATE
        ${FFMPEG_REAL_LIBS}
)
# 运行时自动去 bundle/lib 找库
set_target_properties(${PLUGIN_NAME} PROPERTIES
        BUILD_WITH_INSTALL_RPATH TRUE
        INSTALL_RPATH "\$ORIGIN"
        INSTALL_RPATH_USE_LINK_PATH TRUE
)


# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(ffmpeg_hl_bundled_libraries
  ${FFMPEG_REAL_LIBS}
  ${FFMPEG_SYMLINKS}
  PARENT_SCOPE
)

# === Tests ===
# These unit tests can be run from a terminal after building the example.

# Only enable test builds when building the example (which sets this variable)
# so that plugin clients aren't building the tests.
if (${include_${PROJECT_NAME}_tests})
if(${CMAKE_VERSION} VERSION_LESS "3.11.0")
message("Unit tests require CMake 3.11.0 or later")
else()
set(TEST_RUNNER "${PROJECT_NAME}_test")
enable_testing()

# Add the Google Test dependency.
include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/release-1.11.0.zip
)
# Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
# Disable install commands for gtest so it doesn't end up in the bundle.
set(INSTALL_GTEST OFF CACHE BOOL "Disable installation of googletest" FORCE)

FetchContent_MakeAvailable(googletest)

# The plugin's exported API is not very useful for unit testing, so build the
# sources directly into the test binary rather than using the shared library.
add_executable(${TEST_RUNNER}
  test/ffmpeg_hl_plugin_test.cc
  ${PLUGIN_SOURCES}
)
apply_standard_settings(${TEST_RUNNER})
target_include_directories(${TEST_RUNNER} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(${TEST_RUNNER} PRIVATE flutter)
target_link_libraries(${TEST_RUNNER} PRIVATE PkgConfig::GTK)
target_link_libraries(${TEST_RUNNER} PRIVATE gtest_main gmock)

# Enable automatic test discovery.
include(GoogleTest)
gtest_discover_tests(${TEST_RUNNER})

endif()  # CMake version check
endif()  # include_${PROJECT_NAME}_tests