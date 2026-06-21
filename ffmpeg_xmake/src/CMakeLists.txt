cmake_minimum_required(VERSION 3.10)

project(ffmpeg_hl VERSION 0.0.1)

#定义名称
set(FFMPEG_CORE_LIB_NAME "ffmpeg_core")

# 打印信息
message(WARNING "=== Device Info ===")
message(WARNING "CMAKE_HOST_SYSTEM_NAME: ${CMAKE_HOST_SYSTEM_NAME}")
message(WARNING "CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")
message(WARNING "ANDROID : ${ANDROID}")
message(WARNING "CMAKE_ANDROID_NDK : ${CMAKE_ANDROID_NDK}")
message(WARNING "OHOS_SDK_NATIVE : ${OHOS_SDK_NATIVE}")
message(WARNING "ANDROID_NDK : ${ANDROID_NDK}")
message(WARNING "OHOS : ${OHOS}")
message(WARNING "WIN32 : ${WIN32}")
message(WARNING "APPLE : ${APPLE}")
message(WARNING "CMAKE_SOURCE_DIR :${CMAKE_SOURCE_DIR}")
message(WARNING "CMAKE_CURRENT_SOURCE_DIR :${CMAKE_CURRENT_SOURCE_DIR}")
message(WARNING "CMAKE_CURRENT_LIST_DIR :${CMAKE_CURRENT_LIST_DIR}")
message(WARNING "CMAKE_BINARY_DIR :${CMAKE_BINARY_DIR}")
message(WARNING "CMAKE_CURRENT_BINARY_DIR :${CMAKE_CURRENT_BINARY_DIR}")
message(WARNING "PROJECT_BINARY_DIR :${PROJECT_BINARY_DIR}")
message(WARNING "PROJECT_BINARY_DIR :${PROJECT_BINARY_DIR}")
message(WARNING "====================")

set(XMAKE_BUILD_OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/xmake/build)

include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/xmake/include
)
# 添加xmake编译的core
#add_library(${FFMPEG_CORE_LIB_NAME} SHARED IMPORTED)

add_library(${PROJECT_NAME} SHARED
        "ffmpeg_hl.c"
)

if (CMAKE_SYSTEM_NAME MATCHES "OHOS" OR OHOS)
  message(WARNING "Compiling: OHOS")
  # 定义xmake鸿蒙编译的so输出路径
#  set(XMAKE_OH_BUILD_OUTPUT_SO ${XMAKE_BUILD_OUTPUT}/harmony/${OHOS_ARCH}/lib${FFMPEG_CORE_LIB_NAME}.so)
  # 定义鸿蒙标准的 so 存放路径,这个路径下的so才会被打包进app
  set(OHOS_DEFAULT_LIBS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../ohos/libs/${OHOS_ARCH})

  # 设置xmake编译的danmakufactory_core的导入规则
#  set_target_properties(${FFMPEG_CORE_LIB_NAME} PROPERTIES
#          IMPORTED_NO_SONAME TRUE
#          IMPORTED_LOCATION ${XMAKE_OH_BUILD_OUTPUT_SO}
#  )
  # 拷贝core
#  add_custom_command(
#          TARGET ${PROJECT_NAME}
#          POST_BUILD
#          COMMAND ${CMAKE_COMMAND} -E make_directory "${OHOS_DEFAULT_LIBS_DIR}"
#          COMMAND ${CMAKE_COMMAND} -E copy_if_different "${XMAKE_OH_BUILD_OUTPUT_SO}" "${OHOS_DEFAULT_LIBS_DIR}"
#          COMMENT "ffmpeg_core 已自动复制到输出目录"
#  )
  # 根据架构选择不同的cmake
  add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/xmake/build/harmony/${OHOS_ARCH})
  # 将 core 库输出位置指定为构建目录
  set_target_properties(${FFMPEG_CORE_LIB_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${OHOS_DEFAULT_LIBS_DIR})


elseif (ANDROID)
  message(WARNING "Compiling: Android")
  # 定义xmake Android编译的so输出路径
#  set(XMAKE_ANDROID_BUILD_OUTPUT_SO ${XMAKE_BUILD_OUTPUT}/android/${ANDROID_ABI}/lib${FFMPEG_CORE_LIB_NAME}.so)
  # 定义Android标准的 so 存放路径,这个路径下的so才会被打包进app
  set(ANDROID_DEFAULT_LIBS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../android/src/main/jniLibs/${ANDROID_ABI})

  # 设置xmake编译的core的导入规则
#  set_target_properties(${FFMPEG_CORE_LIB_NAME} PROPERTIES
#          IMPORTED_NO_SONAME TRUE
#          IMPORTED_LOCATION ${XMAKE_ANDROID_BUILD_OUTPUT_SO}
#  )
  # 拷贝core
#  add_custom_command(
#          TARGET ${PROJECT_NAME}
#          POST_BUILD
#          COMMAND ${CMAKE_COMMAND} -E make_directory "${ANDROID_DEFAULT_LIBS_DIR}"
#          COMMAND ${CMAKE_COMMAND} -E copy_if_different "${XMAKE_ANDROID_BUILD_OUTPUT_SO}" "${ANDROID_DEFAULT_LIBS_DIR}"
#          COMMENT "ffmpeg_core 已自动复制到输出目录"
#  )

  # 根据架构选择不同的cmake
  add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/xmake/build/android/${ANDROID_ABI})
  # 将 core 库输出位置指定为构建目录
  set_target_properties(${FFMPEG_CORE_LIB_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${ANDROID_DEFAULT_LIBS_DIR})
  # 添加16kb
  target_link_options(${FFMPEG_CORE_LIB_NAME} PRIVATE "-Wl,-z,max-page-size=16384")



elseif (WIN32)
  message(WARNING "Compiling: Windows")
  # 判断架构
  if (CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(WIN_ABI_NAME x64)
  else ()
    set(WIN_ABI_NAME x86)
  endif ()
  message(WARNING "Compiling: WIN_ABI_NAME:${WIN_ABI_NAME}")

  # 定义xmake Win编译输出路径
  set(XMAKE_WIN_BUILD_OUTPUT ${XMAKE_BUILD_OUTPUT}/windows/${WIN_ABI_NAME})
  # 定义xmake Win编译的dll输出路径
  set(XMAKE_WIN_BUILD_OUTPUT_DLL ${XMAKE_WIN_BUILD_OUTPUT}/${FFMPEG_CORE_LIB_NAME}.dll)
  # 设置xmake编译的danmakufactory_core的导入规则,包括lib
#  set_target_properties(${FFMPEG_CORE_LIB_NAME} PROPERTIES
#          IMPORTED_NO_SONAME TRUE
#          IMPORTED_LOCATION ${XMAKE_WIN_BUILD_OUTPUT_DLL}
#          IMPORTED_IMPLIB ${XMAKE_WIN_BUILD_OUTPUT}/${FFMPEG_CORE_LIB_NAME}.lib
#  )

  # 拷贝core
#  add_custom_command(
#          TARGET ${PROJECT_NAME}
#          POST_BUILD
#          COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_BINARY_DIR}/runner/Debug"
#          COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_BINARY_DIR}/runner/Release"
#          COMMAND ${CMAKE_COMMAND} -E copy_if_different "${XMAKE_WIN_BUILD_OUTPUT_DLL}" "${CMAKE_BINARY_DIR}/runner/Debug"
#          COMMAND ${CMAKE_COMMAND} -E copy_if_different "${XMAKE_WIN_BUILD_OUTPUT_DLL}" "${CMAKE_BINARY_DIR}/runner/Release"
#          COMMENT "ffmpeg_core 已自动复制到输出目录"
#  )

  # 根据架构选择不同的cmake
  add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/xmake/build/windows/${WIN_ABI_NAME})
  # 将 core 库输出位置指定为构建目录
  set_target_properties(${FFMPEG_CORE_LIB_NAME} PROPERTIES
          RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/runner
          # lib不需要,所以随便指定即可
          ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
  )

elseif (CMAKE_SYSTEM_NAME MATCHES "Linux")
  message(WARNING "Compiling: Linux")

elseif (APPLE)
  if (CMAKE_SYSTEM_NAME MATCHES "iOS")
    message(WARNING "Compiling: iOS")
  else ()
    message(WARNING "Compiling: macOS")
  endif ()
else ()
  message(WARNING "Compiling err: ${CMAKE_SYSTEM_NAME}")
endif ()


set_target_properties(${PROJECT_NAME} PROPERTIES
  PUBLIC_HEADER ffmpeg_hl.h
  OUTPUT_NAME "ffmpeg_hl"
)

target_compile_definitions(${PROJECT_NAME} PUBLIC DART_SHARED_LIB)

#链接core
target_link_libraries(${PROJECT_NAME} ${FFMPEG_CORE_LIB_NAME})

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(${PROJECT_NAME} PRIVATE "-Wl,-z,max-page-size=16384")
endif()
