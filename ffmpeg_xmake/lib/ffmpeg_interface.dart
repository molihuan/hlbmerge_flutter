abstract class FfmpegInterface {
  Future<bool> init();

  String? ffmpegVersion();

  /// 成功返回null,失败返回错误信息
  /// 如果是web,videoPath需要是blob url地址,audioPath 也需要
  Future<String?> mergeAudioVideo(
    String videoPath,
    String audioPath,
    String outputPath,
  );

  /// 成功返回null,失败返回错误信息
  Future<String?> mergeVideos(List<String> videoPaths, String outputPath);
}


