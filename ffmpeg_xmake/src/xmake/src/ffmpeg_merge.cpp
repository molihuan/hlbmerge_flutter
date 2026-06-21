extern "C" {
#include <libavformat/avformat.h>
#include <libavutil/timestamp.h>
#include <libavcodec/avcodec.h>
}

#include <string>
#include <vector>
#include <stdio.h>

#include "ffmpeg_merge.h"


#ifdef __cplusplus
extern "C" {
#endif


static char *alloc_error_msg(const char *msg) {
    char *result = static_cast<char *>(malloc(strlen(msg) + 1));
    strcpy(result, msg);
    return result;
}


static void cleanup_av(AVFormatContext **video_ctx, AVFormatContext **audio_ctx, AVFormatContext **out_ctx) {
    if (*video_ctx) {
        avformat_close_input(video_ctx);
        *video_ctx = nullptr;
    }
    if (*audio_ctx) {
        avformat_close_input(audio_ctx);
        *audio_ctx = nullptr;
    }
    if (*out_ctx) {
        if (!((*out_ctx)->oformat->flags & AVFMT_NOFILE)) {
            avio_closep(&(*out_ctx)->pb);
        }
        avformat_free_context(*out_ctx);
        *out_ctx = nullptr;
    }
}

static void cleanup_videos(std::vector<AVFormatContext *> &in_fmt_ctxs, AVFormatContext **out_fmt_ctx,
                           const AVOutputFormat *ofmt, int path_count) {
    for (int i = 0; i < path_count; ++i) {
        if (in_fmt_ctxs[i]) {
            avformat_close_input(&in_fmt_ctxs[i]);
            in_fmt_ctxs[i] = nullptr;
        }
    }
    if (*out_fmt_ctx) {
        if (ofmt && !(ofmt->flags & AVFMT_NOFILE)) {
            avio_closep(&(*out_fmt_ctx)->pb);
        }
        avformat_free_context(*out_fmt_ctx);
        *out_fmt_ctx = nullptr;
    }
}

char *merge_audio_video(const char *video_path,
                        const char *audio_path,
                        const char *output_path) {
    AVFormatContext *video_ctx = nullptr, *audio_ctx = nullptr, *out_ctx = nullptr;
    int ret;

    // Registration (not necessarily required for FFmpeg 4.x, but to be on the safe side)
    //av_register_all();

    // Open the video input file
    if ((ret = avformat_open_input(&video_ctx, video_path, nullptr, nullptr)) < 0) {
        long long sz = 0;
        FILE* f = fopen(video_path, "rb");
        if(f) { fseek(f, 0, SEEK_END); sz = ftell(f); fclose(f); }

        return alloc_error_msg(
                ("Open video failed: " + std::string(video_path) + ", size: " + std::to_string(sz) + " bytes").c_str()
                );
    }
    if ((ret = avformat_find_stream_info(video_ctx, nullptr)) < 0) {
        cleanup_av(&video_ctx, &audio_ctx, &out_ctx);
        return alloc_error_msg("Failed to retrieve video stream info");
    }

    // Open the audio input file
    if ((ret = avformat_open_input(&audio_ctx, audio_path, nullptr, nullptr)) < 0) {
        cleanup_av(&video_ctx, &audio_ctx, &out_ctx);
        return alloc_error_msg("Could not open audio file");
    }
    if ((ret = avformat_find_stream_info(audio_ctx, nullptr)) < 0) {
        cleanup_av(&video_ctx, &audio_ctx, &out_ctx);
        return alloc_error_msg("Failed to retrieve audio stream info");
    }

    // Create an output file context
    if ((ret = avformat_alloc_output_context2(&out_ctx, nullptr, nullptr, output_path)) < 0) {
        cleanup_av(&video_ctx, &audio_ctx, &out_ctx);
        return alloc_error_msg("Could not create output context");
    }

    // Add a video stream
    AVStream *out_video_stream = avformat_new_stream(out_ctx, nullptr);
    if (!out_video_stream) {
        cleanup_av(&video_ctx, &audio_ctx, &out_ctx);
        return alloc_error_msg("Failed allocating output video stream");
    }
    AVStream *in_video_stream = video_ctx->streams[0];
    ret = avcodec_parameters_copy(out_video_stream->codecpar, in_video_stream->codecpar);
    out_video_stream->codecpar->codec_tag = 0;

    // Add an audio stream
    AVStream *out_audio_stream = avformat_new_stream(out_ctx, nullptr);
    if (!out_audio_stream) {
        cleanup_av(&video_ctx, &audio_ctx, &out_ctx);
        return alloc_error_msg("Failed allocating output audio stream");
    }
    AVStream *in_audio_stream = audio_ctx->streams[0];
    ret = avcodec_parameters_copy(out_audio_stream->codecpar, in_audio_stream->codecpar);
    out_audio_stream->codecpar->codec_tag = 0;

    // Open the output file
    if (!(out_ctx->oformat->flags & AVFMT_NOFILE)) {
        if ((ret = avio_open(&out_ctx->pb, output_path, AVIO_FLAG_WRITE)) < 0) {
            cleanup_av(&video_ctx, &audio_ctx, &out_ctx);
            return alloc_error_msg("Could not open output file");
        }
    }

    // Write the output file header
    if ((ret = avformat_write_header(out_ctx, nullptr)) < 0) {
        cleanup_av(&video_ctx, &audio_ctx, &out_ctx);
        return alloc_error_msg("Error occurred when writing header to output file");
    }

    // Replication Package (Video Streaming)
    AVPacket pkt;
    while (av_read_frame(video_ctx, &pkt) >= 0) {
        pkt.stream_index = out_video_stream->index;
        pkt.pts = av_rescale_q_rnd(pkt.pts, in_video_stream->time_base, out_video_stream->time_base,
                                   (AVRounding) (AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX));
        pkt.dts = av_rescale_q_rnd(pkt.dts, in_video_stream->time_base, out_video_stream->time_base,
                                   (AVRounding) (AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX));

        pkt.duration = av_rescale_q(pkt.duration, in_video_stream->time_base, out_video_stream->time_base);
        pkt.pos = -1;

        ret = av_interleaved_write_frame(out_ctx, &pkt);
        av_packet_unref(&pkt);
        if (ret < 0) {
            cleanup_av(&video_ctx, &audio_ctx, &out_ctx);
            return alloc_error_msg("Error muxing video packet");
        }
    }

    // Replication Package (Audio Stream)
    while (av_read_frame(audio_ctx, &pkt) >= 0) {
        pkt.stream_index = out_audio_stream->index;
        pkt.pts = av_rescale_q_rnd(pkt.pts, in_audio_stream->time_base, out_audio_stream->time_base,
                                   (AVRounding) (AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX));
        pkt.dts = av_rescale_q_rnd(pkt.dts, in_audio_stream->time_base, out_audio_stream->time_base,
                                   (AVRounding) (AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX));

        pkt.duration = av_rescale_q(pkt.duration, in_audio_stream->time_base, out_audio_stream->time_base);
        pkt.pos = -1;

        ret = av_interleaved_write_frame(out_ctx, &pkt);
        av_packet_unref(&pkt);
        if (ret < 0) {
            cleanup_av(&video_ctx, &audio_ctx, &out_ctx);
            return alloc_error_msg("Error muxing audio packet");
        }
    }

    // Write the end of the file
    av_write_trailer(out_ctx);

    printf("Merge completed: %s\n", output_path);


    cleanup_av(&video_ctx, &audio_ctx, &out_ctx);
    return nullptr;
}

char *merge_videos(const char **video_paths, int path_count, const char *output_path) {
    if (video_paths == nullptr || path_count <= 0) {
        return alloc_error_msg("Invalid video paths or path count");
    }

    AVFormatContext *out_fmt_ctx = nullptr;
    int ret = avformat_alloc_output_context2(&out_fmt_ctx, nullptr, nullptr, output_path);
    if (ret < 0 || !out_fmt_ctx) {
        return alloc_error_msg("Failed to create output context");
    }

    const AVOutputFormat *ofmt = out_fmt_ctx->oformat;
    std::vector<AVFormatContext *> in_fmt_ctxs(path_count, nullptr);

    // open all inputs
    for (int i = 0; i < path_count; ++i) {
        ret = avformat_open_input(&in_fmt_ctxs[i], video_paths[i], nullptr, nullptr);
        if (ret < 0) {
            cleanup_videos(in_fmt_ctxs, &out_fmt_ctx, ofmt, path_count);
            std::string msg = "Failed to open input: " + std::string(video_paths[i]);
            return alloc_error_msg(msg.c_str());
        }
        ret = avformat_find_stream_info(in_fmt_ctxs[i], nullptr);
        if (ret < 0) {
            cleanup_videos(in_fmt_ctxs, &out_fmt_ctx, ofmt, path_count);
            std::string msg = "Failed to get stream info: " + std::string(video_paths[i]);
            return alloc_error_msg(msg.c_str());
        }
    }

    // create output streams
    for (unsigned int i = 0; i < in_fmt_ctxs[0]->nb_streams; ++i) {
        AVStream *in_stream = in_fmt_ctxs[0]->streams[i];
        AVStream *out_stream = avformat_new_stream(out_fmt_ctx, nullptr);
        if (!out_stream) {
            cleanup_videos(in_fmt_ctxs, &out_fmt_ctx, ofmt, path_count);
            return alloc_error_msg("Failed to allocate output stream");
        }
        ret = avcodec_parameters_copy(out_stream->codecpar, in_stream->codecpar);
        if (ret < 0) {
            cleanup_videos(in_fmt_ctxs, &out_fmt_ctx, ofmt, path_count);
            return alloc_error_msg("Failed to copy codec parameters");
        }
        out_stream->codecpar->codec_tag = 0;
    }

    if (!(ofmt->flags & AVFMT_NOFILE)) {
        ret = avio_open(&out_fmt_ctx->pb, output_path, AVIO_FLAG_WRITE);
        if (ret < 0) {
            cleanup_videos(in_fmt_ctxs, &out_fmt_ctx, ofmt, path_count);
            return alloc_error_msg("Failed to open output file");
        }
    }

    ret = avformat_write_header(out_fmt_ctx, nullptr);
    if (ret < 0) {
        cleanup_videos(in_fmt_ctxs, &out_fmt_ctx, ofmt, path_count);
        return alloc_error_msg("Error occurred when opening output file");
    }

    std::vector<int64_t> pts_offsets(out_fmt_ctx->nb_streams, 0);

    for (int idx = 0; idx < path_count; ++idx) {
        AVFormatContext *in_ctx = in_fmt_ctxs[idx];

        // Find video and audio stream indices in input
        int video_stream_idx = -1;
        int audio_stream_idx = -1;
        for (unsigned int i = 0; i < in_ctx->nb_streams; i++) {
            if (in_ctx->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO && video_stream_idx == -1) {
                video_stream_idx = i;
            } else if (in_ctx->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_AUDIO && audio_stream_idx == -1) {
                audio_stream_idx = i;
            }
        }

        AVPacket pkt;
        av_init_packet(&pkt);

        // Track max PTS per output stream for this input file
        std::vector<int64_t> max_pts_in_file(out_fmt_ctx->nb_streams, INT64_MIN);

        while (av_read_frame(in_ctx, &pkt) >= 0) {
            AVStream *in_stream = in_ctx->streams[pkt.stream_index];

            // Map input stream index to output stream index
            int out_stream_idx = -1;
            if (pkt.stream_index == video_stream_idx) {
                out_stream_idx = 0;
            } else if (pkt.stream_index == audio_stream_idx) {
                out_stream_idx = 1;
            } else {
                av_packet_unref(&pkt);
                continue;
            }

            if (out_stream_idx >= (int)out_fmt_ctx->nb_streams) {
                av_packet_unref(&pkt);
                continue;
            }

            AVStream *out_stream = out_fmt_ctx->streams[out_stream_idx];

            int64_t *pts_offset = &pts_offsets[out_stream_idx];

            // Rescale timestamps
            pkt.pts = av_rescale_q_rnd(pkt.pts, in_stream->time_base, out_stream->time_base,
                                       (AVRounding) (AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX));
            pkt.dts = av_rescale_q_rnd(pkt.dts, in_stream->time_base, out_stream->time_base,
                                       (AVRounding) (AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX));
            pkt.duration = av_rescale_q(pkt.duration, in_stream->time_base, out_stream->time_base);
            if (pkt.duration <= 0) pkt.duration = 1;
            pkt.pos = -1;

            // Apply offset
            pkt.pts += *pts_offset;
            pkt.dts += *pts_offset;

            // Track max PTS
            if (pkt.pts > max_pts_in_file[out_stream_idx]) {
                max_pts_in_file[out_stream_idx] = pkt.pts;
            }

            ret = av_interleaved_write_frame(out_fmt_ctx, &pkt);
            if (ret < 0) {
                av_packet_unref(&pkt);
                cleanup_videos(in_fmt_ctxs, &out_fmt_ctx, ofmt, path_count);
                std::string msg = "Error muxing packet";
                return alloc_error_msg(msg.c_str());
            }

            av_packet_unref(&pkt);
        }

        // Update offsets for next file: add duration of this file
        for (size_t i = 0; i < max_pts_in_file.size(); i++) {
            if (max_pts_in_file[i] != INT64_MIN) {
                pts_offsets[i] = max_pts_in_file[i] + 1;
            }
        }

        avformat_close_input(&in_ctx);
        in_fmt_ctxs[idx] = nullptr;
    }

    av_write_trailer(out_fmt_ctx);

    printf("Merge completed: %s\n", output_path);

    cleanup_videos(in_fmt_ctxs, &out_fmt_ctx, ofmt, path_count);
    return nullptr;
}

char *ffmpeg_version() {
    const char *version = av_version_info();
    // 复制字符串到堆内存,让调用者负责释放
    auto result = static_cast<char *>(malloc(strlen(version) + 1));
    strcpy(result, version);
    return result;
}


#ifdef __cplusplus
}
#endif
