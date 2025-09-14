import 'dart:ffi';

import 'package:ffmpeg_hl/beans/Pair.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ffmpeg_hl_method_channel.dart';

abstract class FfmpegHlPlatform extends PlatformInterface {
  /// Constructs a FfmpegHlPlatform.
  FfmpegHlPlatform() : super(token: _token);

  static final Object _token = Object();

  static FfmpegHlPlatform _instance = MethodChannelFfmpegHl();

  /// The default instance of [FfmpegHlPlatform] to use.
  ///
  /// Defaults to [MethodChannelFfmpegHl].
  static FfmpegHlPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FfmpegHlPlatform] when
  /// they register themselves.
  static set instance(FfmpegHlPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  //获取avcodec配置信息
  Future<String?> getAvcodecCfg() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Pair<bool, String>> mergeAudioVideo(String audioPath, String videoPath, String outputPath) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<Pair<bool, String>> mergeVideos(List<String> videoPaths, String outputPath) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
