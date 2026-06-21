import 'package:hlbmerge/log/log.dart';
import 'package:tuple/tuple.dart';

import '../../../../utils/file_util.dart';
import '../base_merge_server.dart';
import '../ffmpeg_server.dart';
import '../model/cache_item.dart';

class WindowsMergeServer extends BaseMergeServer {
  late String _decryptAudioPath;
  late String _decryptVideoPath;

  @override
  Future<Tuple2<bool, String?>> mergeBefore(CacheItem item) async {
    final audioPath = item.audioPath;
    final videoPath = item.videoPath;
    if (audioPath == null || videoPath == null) {
      return const Tuple2(false, "audioPath videoPath is null");
    }
    String tempAudioPath = "${audioPath}.hlb_temp.mp3";
    String tempVideoPath = "${videoPath}.hlb_temp.mp4";

    try {
      // 解密
      bool decryptAudioResult = await FileUtil.decryptPcM4sAfter202403(
        audioPath,
        tempAudioPath,
      );
      if (!decryptAudioResult) {
        return Tuple2(false, "解密audio失败");
      }
      bool decryptVideoResult = await FileUtil.decryptPcM4sAfter202403(
        videoPath,
        tempVideoPath,
      );
      if (!decryptVideoResult) {
        return Tuple2(false, "解密video失败");
      }
      _decryptAudioPath = tempAudioPath;
      _decryptVideoPath = tempVideoPath;
      return Tuple2(true, null);
    } catch (e) {
      Log.e("解密失败", e);
      return Tuple2(false, "解密失败");
    }
  }

  @override
  Future<Tuple2<bool, String?>> finalMerge(
    CacheItem item,
    String outputPath,
  ) async {
    final audioPath = _decryptAudioPath;
    final videoPath = _decryptVideoPath;

    final String? errMsg;

    if (audioPath.isNotEmpty &&
        videoPath.isNotEmpty) {
      errMsg = await FFmpegServer.mergeAudioVideo(
        videoPath,
        audioPath,
        outputPath,
      );
    } else {
      errMsg = "audioPath videoPath and blvList all is null";
    }

    if (errMsg != null) {
      return Tuple2(false, errMsg);
    }
    return const Tuple2(true, null);
  }
}
