#ifndef FFMPEG_MERGE_H
#define FFMPEG_MERGE_H

extern "C" {
#include <libavformat/avformat.h>
#include <libavutil/timestamp.h>
}

#include <iostream>
#include <string>

bool merge_audio_video(const std::string& video_path,
                       const std::string& audio_path,
                       const std::string& output_path);

#endif // FFMPEG_MERGE_H