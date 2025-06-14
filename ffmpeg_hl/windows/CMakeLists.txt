# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "ffmpeg_hl")

# 禁用 MSVC 编译器中的 4244 和 4819 警告
if(MSVC)
    add_compile_options(/wd4244 /wd4819)
endif()
# 指定 FFmpeg 安装目录，并将目录赋值给 FFMPEG_DEV_ROOT 变量，方便后续指令引用
set(FFMPEG_DEV_ROOT "C:/Users/moli/.vmr/versions/ffmpeg_versions/ffmpeg/Library")

project(${PROJECT_NAME} LANGUAGES CXX)

# Explicitly opt in to modern CMake behaviors to avoid warnings with recent
# versions of CMake.
cmake_policy(VERSION 3.14...3.25)

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "ffmpeg_hl_plugin")

# Any new source files that you add to the plugin should be added here.
list(APPEND PLUGIN_SOURCES
  "ffmpeg_hl_plugin.cpp"
  "ffmpeg_hl_plugin.h"
  "ffmpeg/ffmpeg_merge.cpp"
  "ffmpeg/ffmpeg_merge.h"
)

# Define the plugin library target. Its name must not be changed (see comment
# on PLUGIN_NAME above).
add_library(${PLUGIN_NAME} SHARED
  "include/ffmpeg_hl/ffmpeg_hl_plugin_c_api.h"
  "ffmpeg_hl_plugin_c_api.cpp"
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
# 指定需要连接到程序中的库列表
link_libraries(
        ${FFMPEG_DEV_ROOT}/lib/avcodec.lib
        ${FFMPEG_DEV_ROOT}/lib/avformat.lib
        ${FFMPEG_DEV_ROOT}/lib/avutil.lib
        ${FFMPEG_DEV_ROOT}/lib/swscale.lib
)

target_link_libraries(${PLUGIN_NAME} PRIVATE
        flutter
        flutter_wrapper_plugin
        ${FFMPEG_DEV_ROOT}/lib/avcodec.lib
        ${FFMPEG_DEV_ROOT}/lib/avformat.lib
        ${FFMPEG_DEV_ROOT}/lib/avutil.lib
        ${FFMPEG_DEV_ROOT}/lib/swscale.lib
)

# 指定存放程序生成的静态库的目录
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
# 指定存放程序生成的动态库的目录
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
# 指定存放可执行软件的目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
# 复制动态库 dll 文件
file(COPY
        ${FFMPEG_DEV_ROOT}/bin/avcodec-58.dll
        ${FFMPEG_DEV_ROOT}/bin/avformat-58.dll
        ${FFMPEG_DEV_ROOT}/bin/avutil-56.dll
        ${FFMPEG_DEV_ROOT}/bin/swscale-5.dll
        DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(ffmpeg_hl_bundled_libraries
        ${FFMPEG_DEV_ROOT}/bin/avcodec-58.dll
        ${FFMPEG_DEV_ROOT}/bin/avformat-58.dll
        ${FFMPEG_DEV_ROOT}/bin/avutil-56.dll
        ${FFMPEG_DEV_ROOT}/bin/swscale-5.dll
  PARENT_SCOPE
)

# === Tests ===
# These unit tests can be run from a terminal after building the example, or
# from Visual Studio after opening the generated solution file.

# Only enable test builds when building the example (which sets this variable)
# so that plugin clients aren't building the tests.
if (${include_${PROJECT_NAME}_tests})
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

# The plugin's C API is not very useful for unit testing, so build the sources
# directly into the test binary rather than using the DLL.
add_executable(${TEST_RUNNER}
  test/ffmpeg_hl_plugin_test.cpp
  ${PLUGIN_SOURCES}
)
apply_standard_settings(${TEST_RUNNER})
target_include_directories(${TEST_RUNNER} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(${TEST_RUNNER} PRIVATE flutter_wrapper_plugin)
target_link_libraries(${TEST_RUNNER} PRIVATE gtest_main gmock)
# flutter_wrapper_plugin has link dependencies on the Flutter DLL.
add_custom_command(TARGET ${TEST_RUNNER} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
  "${FLUTTER_LIBRARY}" $<TARGET_FILE_DIR:${TEST_RUNNER}>
)

# Enable automatic test discovery.
include(GoogleTest)
gtest_discover_tests(${TEST_RUNNER})
endif()
