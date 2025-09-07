import 'package:ffmpeg_hl/beans/Pair.dart';
import 'package:ffmpeg_hl/utils/StrUtil.dart';

import 'ffmpeg_hl_platform_interface.dart';

class FfmpegHl {
  Future<String?> getPlatformVersion() {
    return FfmpegHlPlatform.instance.getPlatformVersion();
  }

  //  获取avcodec配置信息
  Future<String?> getAvcodecCfg() {
    return FfmpegHlPlatform.instance.getAvcodecCfg();
  }

  // 合并音频和视频
  Future<Pair<bool, String>> mergeAudioVideo(
      String audioPath, String videoPath, String outputPath) {
    //判断路径中是否有空格
    // if (StrUtil.containsAnySpace(audioPath)) {
    //   return Future.value(Pair(false, "音频路径中不能包含空格"));
    // }
    // if (StrUtil.containsAnySpace(videoPath)) {
    //   return Future.value(Pair(false, "视频路径中不能包含空格"));
    // }
    // if (StrUtil.containsAnySpace(outputPath)) {
    //   return Future.value(Pair(false, "输出路径中不能包含空格"));
    // }

    return FfmpegHlPlatform.instance
        .mergeAudioVideo(audioPath, videoPath, outputPath);
  }
}
