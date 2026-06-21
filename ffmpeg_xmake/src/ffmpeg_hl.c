#include "ffmpeg_hl.h"
#include "ffmpeg_merge.h"


FFI_PLUGIN_EXPORT int sum(int a, int b) { return a + b; }

FFI_PLUGIN_EXPORT int sum_long_running(int a, int b) {
// #if _WIN32
//   Sleep(5000);
// #else
//   usleep(5000 * 1000);
// #endif
  return sum(a,b);
}

FFI_PLUGIN_EXPORT char* get_ffmpeg_version(){
  char* result = ffmpeg_version();
  return result;
}

FFI_PLUGIN_EXPORT char* run_merge_audio_video(const char* video_path,
                                             const char* audio_path,
                                             const char* output_path){
  return merge_audio_video(video_path, audio_path, output_path);
}

FFI_PLUGIN_EXPORT char* run_merge_videos(const char **video_paths,
                                         int path_count,
                                         const char *output_path){
  return merge_videos(video_paths, path_count, output_path);
}


FFI_PLUGIN_EXPORT void free_string(char* ptr) {
  if (ptr == NULL) {
    return;
  }
  free(ptr);
}
