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
  CacheItem cacheItem;
  FFmpegTaskStatus status;
  String? groupTitle;

  FFmpegTaskBean({
    required this.cacheItem,
    this.groupTitle,
    this.status = FFmpegTaskStatus.pending,
  });
}

class FFmpegTaskController extends GetxController {
  late final ffmpegPlugin = FfmpegHl();

  // 任务列表
  var tasks = <FFmpegTaskBean>[].obs;

  // 是否正在处理任务
  bool _isProcessing = false;

  // 添加任务
  void addTask(FFmpegTaskBean task) {
    tasks.add(task);
    _processQueue();
  }

  // 处理任务队列
  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    while (tasks.any((t) => t.status == FFmpegTaskStatus.pending)) {
      final task =
          tasks.firstWhere((t) => t.status == FFmpegTaskStatus.pending);
      task.status = FFmpegTaskStatus.running;
      tasks.refresh();

      try {
        await _runFFmpegTask(task);
        task.status = FFmpegTaskStatus.completed;
      } catch (_) {
        task.status = FFmpegTaskStatus.failed;
      }

      tasks.refresh();
    }

    _isProcessing = false;
  }

  // 运行任务
  Future<void> _runFFmpegTask(FFmpegTaskBean task) async {
    mergeAudioVideo(task.cacheItem, groupTitle: task.groupTitle);
  }

  //合并音视频
  mergeAudioVideo(CacheItem item, {String? groupTitle}) async {
    var audioPath = item.audioPath;
    var videoPath = item.videoPath;
    var title = item.title;

    if (audioPath == null || videoPath == null) {
      return;
    }

    var result = await runPlatformFuncFuture<Pair<bool, String>?>(
      onWindows: () async {
        var tempAudioPath = "${audioPath}.hlb_temp.mp3";
        var tempVideoPath = "${videoPath}.hlb_temp.mp4";
        //解密m4s
        await HomeLogic.decryptPcM4sAfter202403(audioPath, tempAudioPath);
        await HomeLogic.decryptPcM4sAfter202403(videoPath, tempVideoPath);
        //文件名
        var outputFileName = title == null
            ? "${DateTime.now().millisecondsSinceEpoch}.mp4"
            : "${title}.mp4";
        // 输出目录
        var outputDirPath = HomeLogic.getOutputDirPath(groupTitle: groupTitle);
        //完成文件路径
        var outputPath = path.join(outputDirPath, outputFileName);

        //合并
        var resultPair = await ffmpegPlugin.mergeAudioVideo(
            tempAudioPath, tempVideoPath, outputPath);

        //过2秒后删除文件
        Future.delayed(const Duration(seconds: 2), () async {
          try {
            await File(tempAudioPath).delete();
            await File(tempVideoPath).delete();
          } catch (e) {
            e.printError();
          }
        });

        return resultPair;
      },
      onDefault: () => null,
    );

    if (result == null) {
      print("${title}合并未知错误");
      return;
    }

    if (result.first) {
      print("${title}合并完成");
    } else {
      print("${title}合并错误${result.second}");
    }
  }
}
