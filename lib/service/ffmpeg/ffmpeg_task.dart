import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:ffmpeg_hl/beans/Pair.dart';
import 'package:ffmpeg_hl/ffmpeg_hl.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path/path.dart' as path;

import '../../dao/sp_data_manager.dart';
import '../../models/cache_item.dart';
import '../../pages/main/home/logic.dart';
import '../../utils/PlatformUtils.dart';

enum FFmpegTaskStatus { pending, running, completed, failed }

class FFmpegTaskBean {
  final CacheItem cacheItem;
  final String? groupTitle;
  final Rx<FFmpegTaskStatus> status;

  FFmpegTaskBean({
    required this.cacheItem,
    this.groupTitle,
    FFmpegTaskStatus status = FFmpegTaskStatus.pending,
  }) : status = status.obs;
}

class FFmpegTaskController extends GetxController {
  late final ffmpegPlugin = FfmpegHl();

  // 任务列表
  var tasks = <FFmpegTaskBean>[].obs;

  // 当前并发数
  final int _maxConcurrency = 2;
  int _runningCount = 0;

  // 添加任务
  void addTask(FFmpegTaskBean task) {
    tasks.add(task);
    _schedule();
  }

  // 调度任务
  void _schedule() {
    if (_runningCount >= _maxConcurrency) return;

    // 找一个等待中的任务
    final task = tasks.firstWhereOrNull(
          (t) => t.status.value == FFmpegTaskStatus.pending,
    );
    if (task == null) return;

    // 标记为运行中
    task.status.value = FFmpegTaskStatus.running;
    _runningCount++;

    // 执行
    _runFFmpegTask(task).then((_) {
      task.status.value = FFmpegTaskStatus.completed;
    }).catchError((_) {
      task.status.value = FFmpegTaskStatus.failed;
    }).whenComplete(() {
      _runningCount--;
      _schedule(); // 执行下一个任务
    });
  }

  // 运行单个任务
  Future<void> _runFFmpegTask(FFmpegTaskBean task) async {
    await mergeAudioVideo(task.cacheItem, groupTitle: task.groupTitle);
  }

  // 合并音视频
  Future<void> mergeAudioVideo(CacheItem item, {String? groupTitle}) async {
    var audioPath = item.audioPath;
    var videoPath = item.videoPath;
    var title = item.title;

    if (audioPath == null || videoPath == null) return;

    var result = await runPlatformFuncFuture<Pair<bool, String>?>(
      onDefault: () async {
        var tempAudioPath = "${audioPath}.hlb_temp.mp3";
        var tempVideoPath = "${videoPath}.hlb_temp.mp4";

        // 解密
        await HomeLogic.decryptPcM4sAfter202403(audioPath, tempAudioPath);
        await HomeLogic.decryptPcM4sAfter202403(videoPath, tempVideoPath);

        // 文件名
        var outputFileName = title == null
            ? "${DateTime.now().millisecondsSinceEpoch}.mp4"
            : "$title.mp4";

        // 输出目录
        var outputDirPath = HomeLogic.getOutputDirPath(groupTitle: groupTitle);
        var outputPath = path.join(outputDirPath, outputFileName);

        // 合并
        var resultPair = await ffmpegPlugin.mergeAudioVideo(
          tempAudioPath,
          tempVideoPath,
          outputPath,
        );

        // 异步删除临时文件
        Future.delayed(const Duration(seconds: 2), () async {
          try {
            await File(tempAudioPath).delete();
            await File(tempVideoPath).delete();
          } catch (_) {}
        });

        return resultPair;
      }
    );

    if (result == null) {
      print("$title 合并未知错误");
      return;
    }

    if (result.first) {
      print("$title 合并完成");
    } else {
      print("$title 合并错误 ${result.second}");
    }
  }
}
