#ifndef FFMPEG_MERGE_H
#define FFMPEG_MERGE_H

extern "C" {
#include <libavformat/avformat.h>
#include <libavutil/timestamp.h>
#include <libavutil/opt.h>
#include <libavcodec/avcodec.h>
}

#include <iostream>
#include <string>
#include <vector>

bool merge_audio_video(const std::string& video_path,
                       const std::string& audio_path,
                       const std::string& output_path);

// 使用 FFmpeg API 拼接多段视频
bool merge_videos(const std::vector<std::string>& video_paths,
                      const std::string& output_path);

#endif // FFMPEG_MERGE_H