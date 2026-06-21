#pragma once

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#elif __EMSCRIPTEN__
#include <emscripten.h>
#define EXPORT EMSCRIPTEN_KEEPALIVE
#else
#define EXPORT
#endif


#ifdef __cplusplus
extern "C" {
#endif


EXPORT char* merge_audio_video(const char *video_path,
                              const char *audio_path,
                              const char *output_path);


EXPORT char* merge_videos(const char **video_paths,
                         int path_count,
                         const char *output_path);


EXPORT char *ffmpeg_version();



#ifdef __cplusplus
}
#endif
