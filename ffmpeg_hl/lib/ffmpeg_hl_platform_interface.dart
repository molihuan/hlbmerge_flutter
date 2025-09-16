import 'dart:ffi';
import 'dart:io';

import 'package:ffmpeg_hl/beans/Pair.dart';
import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ffmpeg_hl_common.dart';
import 'ffmpeg_hl_method_channel.dart';

abstract class FfmpegHlPlatform extends PlatformInterface {
  /// Constructs a FfmpegHlPlatform.
  FfmpegHlPlatform() : super(token: _token);

  static final Object _token = Object();

  static FfmpegHlPlatform? _instance;

  //判断并获取实现
  static init() {
    if (Platform.isWindows || Platform.isLinux) {
      _instance = MethodChannelFfmpegHl();
    } else if(kIsWeb) {
      // _instance = FfmpegHlWeb();
    }else{
      _instance = FfmpegHlCommon();
    }
  }

  /// The default instance of [FfmpegHlPlatform] to use.
  ///
  /// Defaults to [MethodChannelFfmpegHl].
  static FfmpegHlPlatform get instance => _instance!;

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
