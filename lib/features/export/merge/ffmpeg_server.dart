import 'package:ffmpeg_hl/ffmpeg_hl.dart';
import 'package:ffmpeg_hl/ffmpeg_interface.dart';
import 'package:hlbmerge/log/log.dart';

class FFmpegServer {
  FFmpegServer._();

  static final FfmpegInterface _interface = ffmpegInterface;

  static init() async {
    bool result = await _interface.init();
    if (result) {
      Log.d("ffmpeg init ok");
    } else {
      Log.d("ffmpeg init fail");
    }
  }

  static String? ffmpegVersion() {
    return _interface.ffmpegVersion();
  }

  static Future<String?> mergeAudioVideo(
    String videoPath,
    String audioPath,
    String outputPath,
  ) {
    return _interface.mergeAudioVideo(videoPath, audioPath, outputPath);
  }


  static Future<String?> mergeVideos(
    List<String> videoPaths,
    String outputPath,
  ) {
    return _interface.mergeVideos(videoPaths, outputPath);
  }
}
