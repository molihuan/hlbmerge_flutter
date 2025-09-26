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
      List<String> videoPaths, String outputPath) async {

    final concatInput = videoPaths.join("|");

    final List<String> cmds = [
      '-i',
      '"concat:$concatInput"',
      '-c',
      'copy',
      outputPath // 无论路径是什么，都会被当作单一参数
    ];
    FFmpegSession session = await FFmpegKit.executeWithArguments(cmds);
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      return Future.value(Pair(true, "合并成功"));
    } else {
      return Future.value(Pair(false, "合并失败"));
    }
  }

  @override
  Future<Pair<bool, String>> mergeAudioVideo(
      String audioPath, String videoPath, String outputPath) async {
    final List<String> cmds = [
      '-i',
      audioPath, // 直接传递变量，不需要加引号
      '-i',
      videoPath, // 库会处理好路径中的空格
      '-c',
      'copy',
      outputPath // 无论路径是什么，都会被当作单一参数
    ];
    FFmpegSession session = await FFmpegKit.executeWithArguments(cmds);
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
