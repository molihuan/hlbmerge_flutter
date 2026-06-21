#pragma once

#include <stdbool.h>

#include <stdlib.h>

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#elif __EMSCRIPTEN__
#include <emscripten.h>
#define FFI_PLUGIN_EXPORT EMSCRIPTEN_KEEPALIVE
#else
#define FFI_PLUGIN_EXPORT
#endif


FFI_PLUGIN_EXPORT int sum(int a, int b);

FFI_PLUGIN_EXPORT int sum_long_running(int a, int b);

FFI_PLUGIN_EXPORT char* get_ffmpeg_version();

FFI_PLUGIN_EXPORT char* run_merge_audio_video(const char* video_path,
                                             const char* audio_path,
                                             const char* output_path);

FFI_PLUGIN_EXPORT char* run_merge_videos(const char **video_paths,
                                     int path_count,
                                     const char *output_path);

FFI_PLUGIN_EXPORT void free_string(char* ptr);