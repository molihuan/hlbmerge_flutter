import 'package:ffmpeg_hl/beans/Pair.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ffmpeg_hl_platform_interface.dart';

/// An implementation of [FfmpegHlPlatform] that uses method channels.
class MethodChannelFfmpegHl extends FfmpegHlPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ffmpeg_hl');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getAvcodecCfg() async {
    final resultStr = await methodChannel.invokeMethod<String>('getAvcodecCfg');
    return resultStr;
  }

  @override
  Future<Pair<bool, String>> mergeAudioVideo(
      String audioPath, String videoPath, String outputPath) async {
    final result = await methodChannel.invokeMethod('mergeAudioVideo', {
      "audioPath": audioPath,
      "videoPath": videoPath,
      "outputPath": outputPath
    });

    debugPrint(result);

    if (result is! Map) {
      return Future.value(Pair(false, "未知错误"));
    }

    bool success = result['success'] as bool;
    String message = result['message'] as String;
    return Future.value(Pair(success, message));
  }
}
