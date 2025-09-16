import 'package:ffmpeg_kit_flutter_new_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_min/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_new_min/return_code.dart';

import 'beans/Pair.dart';
import 'ffmpeg_hl_method_channel.dart';
import 'ffmpeg_hl_platform_interface.dart';

class FfmpegHlCommon extends FfmpegHlPlatform {
  final _methodChannel = MethodChannelFfmpegHl();

  @override
  Future<String?> getAvcodecCfg() async {
    FFmpegSession session = await FFmpegKit.execute('-version');
    final output = await session.getOutput();
    return Future.value(output);
  }

  @override
  Future<Pair<bool, String>> mergeVideos(
      List<String> videoPaths, String outputPath) {
    return super.mergeVideos(videoPaths, outputPath);
  }

  @override
  Future<Pair<bool, String>> mergeAudioVideo(
      String audioPath, String videoPath, String outputPath) async {
    FFmpegSession session = await FFmpegKit.execute('-i $audioPath -i $videoPath -c copy $outputPath');
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      return Future.value(Pair(true, "合并成功"));
    } else {
      return Future.value(Pair(false, "合并失败"));
    }
  }

  @override
  Future<String?> getPlatformVersion() {
    return _methodChannel.getPlatformVersion();
  }
}
