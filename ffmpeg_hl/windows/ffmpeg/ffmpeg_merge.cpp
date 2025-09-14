#include "ffmpeg_merge.h"

static void print_error(const std::string& msg, int err) {
    char buf[1024];
    av_strerror(err, buf, sizeof(buf));
    std::cerr << msg << ": " << buf << std::endl;
}

bool merge_audio_video(const std::string& video_path,
                       const std::string& audio_path,
                       const std::string& output_path) {
    AVFormatContext *video_ctx = nullptr, *audio_ctx = nullptr, *out_ctx = nullptr;
    int ret;

    // Registration (not necessarily required for FFmpeg 4.x, but to be on the safe side)
    //av_register_all();

    // Open the video input file
    if ((ret = avformat_open_input(&video_ctx, video_path.c_str(), nullptr, nullptr)) < 0) {
        std::cerr << "Could not open video file\n";
        return false;
    }
    if ((ret = avformat_find_stream_info(video_ctx, nullptr)) < 0) {
        std::cerr << "Failed to retrieve video stream info\n";
        return false;
    }

    // Open the audio input file
    if ((ret = avformat_open_input(&audio_ctx, audio_path.c_str(), nullptr, nullptr)) < 0) {
        std::cerr << "Could not open audio file\n";
        return false;
    }
    if ((ret = avformat_find_stream_info(audio_ctx, nullptr)) < 0) {
        std::cerr << "Failed to retrieve audio stream info\n";
        return false;
    }

    // Create an output file context
    if ((ret = avformat_alloc_output_context2(&out_ctx, nullptr, nullptr, output_path.c_str())) < 0) {
        std::cerr << "Could not create output context\n";
        return false;
    }

    // Add a video stream
    AVStream* out_video_stream = avformat_new_stream(out_ctx, nullptr);
    if (!out_video_stream) {
        std::cerr << "Failed allocating output video stream\n";
        return false;
    }
    AVStream* in_video_stream = video_ctx->streams[0];
    ret = avcodec_parameters_copy(out_video_stream->codecpar, in_video_stream->codecpar);
    out_video_stream->codecpar->codec_tag = 0;

    // Add an audio stream
    AVStream* out_audio_stream = avformat_new_stream(out_ctx, nullptr);
    if (!out_audio_stream) {
        std::cerr << "Failed allocating output audio stream\n";
        return false;
    }
    AVStream* in_audio_stream = audio_ctx->streams[0];
    ret = avcodec_parameters_copy(out_audio_stream->codecpar, in_audio_stream->codecpar);
    out_audio_stream->codecpar->codec_tag = 0;

    // Open the output file
    if (!(out_ctx->oformat->flags & AVFMT_NOFILE)) {
        if ((ret = avio_open(&out_ctx->pb, output_path.c_str(), AVIO_FLAG_WRITE)) < 0) {
            std::cerr << "Could not open output file\n";
            return false;
        }
    }

    // Write the output file header
    if ((ret = avformat_write_header(out_ctx, nullptr)) < 0) {
        std::cerr << "Error occurred when writing header to output file\n";
        return false;
    }

    // Replication Package (Video Streaming)
    AVPacket pkt;
    while (av_read_frame(video_ctx, &pkt) >= 0) {
        pkt.stream_index = out_video_stream->index;
        pkt.pts = av_rescale_q_rnd(pkt.pts, in_video_stream->time_base, out_video_stream->time_base, (AVRounding)(AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX));
        pkt.dts = av_rescale_q_rnd(pkt.dts, in_video_stream->time_base, out_video_stream->time_base, (AVRounding)(AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX));

        pkt.duration = av_rescale_q(pkt.duration, in_video_stream->time_base, out_video_stream->time_base);
        pkt.pos = -1;

        ret = av_interleaved_write_frame(out_ctx, &pkt);
        av_packet_unref(&pkt);
        if (ret < 0) {
            std::cerr << "Error muxing video packet\n";
            return false;
        }
    }

    // Replication Package (Audio Stream)
    while (av_read_frame(audio_ctx, &pkt) >= 0) {
        pkt.stream_index = out_audio_stream->index;
        pkt.pts = av_rescale_q_rnd(pkt.pts, in_audio_stream->time_base, out_audio_stream->time_base, (AVRounding)(AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX));
        pkt.dts = av_rescale_q_rnd(pkt.dts, in_audio_stream->time_base, out_audio_stream->time_base, (AVRounding)(AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX));

        pkt.duration = av_rescale_q(pkt.duration, in_audio_stream->time_base, out_audio_stream->time_base);
        pkt.pos = -1;

        ret = av_interleaved_write_frame(out_ctx, &pkt);
        av_packet_unref(&pkt);
        if (ret < 0) {
            std::cerr << "Error muxing audio packet\n";
            return false;
        }
    }

    // Write the end of the file
    av_write_trailer(out_ctx);

    // Close the release
    avformat_close_input(&video_ctx);
    avformat_close_input(&audio_ctx);
    if (!(out_ctx->oformat->flags & AVFMT_NOFILE)) {
        avio_closep(&out_ctx->pb);
    }
    avformat_free_context(out_ctx);

    std::cout << "Merge completed: " << output_path << std::endl;
    return true;
}

bool merge_videos(const std::vector<std::string>& video_paths, const std::string& output_path) {
    if (video_paths.empty()) return false;

    AVFormatContext* out_fmt_ctx = nullptr;
    int ret = avformat_alloc_output_context2(&out_fmt_ctx, nullptr, nullptr, output_path.c_str());
    if (ret < 0 || !out_fmt_ctx) {
        print_error("Failed to create output context", ret);
        return false;
    }

    AVOutputFormat* ofmt = out_fmt_ctx->oformat;
    std::vector<AVFormatContext*> in_fmt_ctxs(video_paths.size(), nullptr);

    // open all inputs
    for (size_t i = 0; i < video_paths.size(); ++i) {
        ret = avformat_open_input(&in_fmt_ctxs[i], video_paths[i].c_str(), nullptr, nullptr);
        if (ret < 0) { print_error("Failed to open input: " + video_paths[i], ret); return false; }
        ret = avformat_find_stream_info(in_fmt_ctxs[i], nullptr);
        if (ret < 0) { print_error("Failed to get stream info: " + video_paths[i], ret); return false; }
    }

    // create output streams
    for (unsigned int i = 0; i < in_fmt_ctxs[0]->nb_streams; ++i) {
        AVStream* in_stream = in_fmt_ctxs[0]->streams[i];
        AVStream* out_stream = avformat_new_stream(out_fmt_ctx, nullptr);
        if (!out_stream) { std::cerr << "Failed to allocate output stream\n"; return false; }
        ret = avcodec_parameters_copy(out_stream->codecpar, in_stream->codecpar);
        if (ret < 0) { print_error("Failed to copy codec parameters", ret); return false; }
        out_stream->codecpar->codec_tag = 0;
    }

    if (!(ofmt->flags & AVFMT_NOFILE)) {
        ret = avio_open(&out_fmt_ctx->pb, output_path.c_str(), AVIO_FLAG_WRITE);
        if (ret < 0) { print_error("Failed to open output file", ret); return false; }
    }

    ret = avformat_write_header(out_fmt_ctx, nullptr);
    if (ret < 0) { print_error("Error occurred when opening output file", ret); return false; }

    int64_t video_pts_offset = 0;
    int64_t audio_pts_offset = 0;

    for (size_t idx = 0; idx < in_fmt_ctxs.size(); ++idx) {
        AVFormatContext* in_ctx = in_fmt_ctxs[idx];
        AVPacket pkt;
        av_init_packet(&pkt);

        int64_t last_video_pts = 0;
        int64_t last_audio_pts = 0;

        while (av_read_frame(in_ctx, &pkt) >= 0) {
            AVStream* in_stream = in_ctx->streams[pkt.stream_index];
            AVStream* out_stream = out_fmt_ctx->streams[pkt.stream_index];

            int64_t* pts_offset = (pkt.stream_index == 0) ? &video_pts_offset : &audio_pts_offset;
            int64_t* last_pts = (pkt.stream_index == 0) ? &last_video_pts : &last_audio_pts;

            pkt.pts = av_rescale_q_rnd(pkt.pts, in_stream->time_base, out_stream->time_base,
                                       (AVRounding)(AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
            pkt.dts = av_rescale_q_rnd(pkt.dts, in_stream->time_base, out_stream->time_base,
                                       (AVRounding)(AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
            pkt.duration = av_rescale_q(pkt.duration, in_stream->time_base, out_stream->time_base);
            if (pkt.duration <= 0) pkt.duration = 1;
            pkt.pos = -1;

            pkt.pts += *pts_offset;
            pkt.dts += *pts_offset;

            *last_pts = pkt.pts;

            ret = av_interleaved_write_frame(out_fmt_ctx, &pkt);
            if (ret < 0) { print_error("Error muxing packet", ret); av_packet_unref(&pkt); return false; }

            av_packet_unref(&pkt);
        }

        // update offset for next file
        video_pts_offset = last_video_pts + 1;
        audio_pts_offset = last_audio_pts + 1;

        avformat_close_input(&in_ctx);
    }

    av_write_trailer(out_fmt_ctx);

    if (!(ofmt->flags & AVFMT_NOFILE)) {
        avio_closep(&out_fmt_ctx->pb);
    }

    avformat_free_context(out_fmt_ctx);
    return true;
}