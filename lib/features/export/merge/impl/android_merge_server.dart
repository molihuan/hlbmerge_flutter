
import 'dart:io';

import 'package:tuple/tuple.dart';


import '../../../../generate/pigeon/flutter_native_api.g.dart';
import '../../../../repository/settings_repository.dart';
import '../base_merge_server.dart';
import '../ffmpeg_server.dart';
import '../model/cache_item.dart';

class AndroidMergeServer extends BaseMergeServer {
  late final _copyTempDirPath = SettingsRepository.getInputCacheDirPath();
  late final _nativeApis = NativeApis();

  @override
  Future<Tuple2<bool, String?>> mergeBefore(CacheItem item) async {
    //如果不是安卓就直接返回成功
    if (!Platform.isAndroid) {
      return const Tuple2(true, null);
    }

    final sufPath = item.path?.replaceFirst(_copyTempDirPath, "");
    if (sufPath == null || sufPath.isEmpty) {
      return const Tuple2(false, "sufPath is empty");
    }
    //拷贝缓存数据
    final copyResult = await _nativeApis.copyCacheAudioVideoFile(sufPath);

    if (copyResult.data) {
      return const Tuple2(true, null);
    }
    return Tuple2(false, copyResult.msg);
  }

  @override
  Future<Tuple2<bool, String?>> finalMerge(
    CacheItem item,
    String outputPath,
  ) async {
    final audioPath = item.audioPath;
    final videoPath = item.videoPath;
    final blvList = item.blvPathList;

    final String? errMsg;

    if (audioPath != null && videoPath != null) {
      errMsg = await FFmpegServer.mergeAudioVideo(
        videoPath,
        audioPath,
        outputPath,
      );
    } else if (blvList != null && blvList.isNotEmpty) {
      //blv格式
      //排序
      final sortedBlvList = List<String>.from(blvList);
      sortedBlvList.sort((a, b) {
        final regex = RegExp(r'(\d+)\.blv$');
        final matchA = regex.firstMatch(a);
        final matchB = regex.firstMatch(b);
        if (matchA == null || matchB == null) return a.compareTo(b);
        final numA = int.parse(matchA.group(1)!);
        final numB = int.parse(matchB.group(1)!);
        return numA.compareTo(numB);
      });
      print("排序后的blvList:$sortedBlvList");

      errMsg = await FFmpegServer.mergeVideos(sortedBlvList, outputPath);
    } else {
      errMsg = "audioPath videoPath and blvList all is null";
    }


    if (errMsg != null) {
      return Tuple2(false, errMsg);
    }
    return const Tuple2(true, null);

  }

}
