import 'dart:core';
import 'dart:io';
import 'package:ffmpeg_hl/beans/Pair.dart';
import 'package:ffmpeg_hl/ffmpeg_hl.dart';
import 'package:ffmpeg_hl/utils/FFmpegHlStrUtil.dart';
import 'package:get/get.dart';
import 'package:hlbmerge/utils/StrUtils.dart';
import 'package:path/path.dart' as path;

import '../../channel/main/main_channel.dart';
import '../../dao/cache_data_manager.dart';
import '../../dao/sp_data_manager.dart';
import '../../models/cache_item.dart';
import '../../ui/pages/main/home/logic.dart';
import '../../utils/FileUtils.dart';
import '../../utils/PlatformUtils.dart';

enum FFmpegTaskStatus {
  pending,
  running,
  completed,
  failed
}

class FFmpegTaskBean {
  final CacheItem cacheItem;
  final String? groupTitle;
  final Rx<FFmpegTaskStatus> status;
  final CachePlatform cachePlatform;
  //失败的原因
  final Rx<String?> errorMsg = (null as String?).obs;

  FFmpegTaskBean({
    required this.cacheItem,
    this.groupTitle,
    required this.cachePlatform,
    FFmpegTaskStatus status = FFmpegTaskStatus.pending,
  }) : status = status.obs;
}

class FFmpegTaskController extends GetxController {
  late final ffmpegPlugin = FfmpegHl();

  // 任务列表
  final _tasks = <FFmpegTaskBean>[].obs;

  //获取
  List<FFmpegTaskBean> get tasks => _tasks.toList();

  set tasks(List<FFmpegTaskBean> value) => _tasks.assignAll(value);

  //清空任务
  void clearTasks() {
    _tasks.clear();
  }

  // 当前并发数
  final int _maxConcurrency = 1;
  int _runningCount = 0;

  //是否导出弹幕文件
  bool _isExportDanmakuFile = false;

  // 添加任务
  void addTask(FFmpegTaskBean task) {
    _beforeAddTask(task);
    _tasks.add(task);
    _schedule();
  }

  //添加任务之前
  _beforeAddTask(FFmpegTaskBean task) async {
    //读取配置
    _isExportDanmakuFile = SpDataManager.getExportDanmakuFileChecked();
  }

  // 调度任务
  _schedule() async {
    if (_runningCount >= _maxConcurrency) return;

    // 找一个等待中的任务
    final task = _tasks.firstWhereOrNull(
      (t) => t.status.value == FFmpegTaskStatus.pending,
    );
    if (task == null) return;

    // 标记为运行中
    task.status.value = FFmpegTaskStatus.running;
    _runningCount++;

    var beforeResult = await _runFFmpegTaskBefore(task);
    if (!beforeResult) {
      task.status.value = FFmpegTaskStatus.failed;
      _runningCount--;
      _schedule();
      return;
    }
    // 执行
    _runFFmpegTask(task).then((_) {
      task.status.value = FFmpegTaskStatus.completed;
    }).catchError((e) {
      task.status.value = FFmpegTaskStatus.failed;
      task.errorMsg.value = e.toString();
    }).whenComplete(() {
      _runFFmpegTaskAfter(task);
      _runningCount--;
      _schedule(); // 执行下一个任务
    });
  }

  Future<void> _runFFmpegTaskAfter(FFmpegTaskBean task) async {
    await runPlatformFunc(
        onDefault: () {},
        onAndroid: () async {
          var currPath = task.cacheItem.path;
          if (currPath == null) {
            return;
          }
          var regex = r".*\.(m4s|blv)$";
          //将指定目录下所有m4s和blv文件(包括其子文件夹)设置为空文件
          //TODO 待完善
          //FileUtils.setEmptyFileByRegex(currPath, regex);
        });
  }

  Future<bool> _runFFmpegTaskBefore(FFmpegTaskBean task) async {
    return await runPlatformFunc(onDefault: () {
      return Future.value(true);
    }, onAndroid: () async {
      var copyTempDirPath = SpDataManager.getInputCacheDirPath() ?? "";
      var sufPath = task.cacheItem.path?.replaceFirst(copyTempDirPath, "");
      if (sufPath == null) {
        return Future.value(false);
      }
      //拷贝缓存数据
      var copyResult = await MainChannel.copyCacheAudioVideoFile(sufPath);
      if (copyResult.first == 0) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    });
  }

  // 运行单个任务
  Future<void> _runFFmpegTask(FFmpegTaskBean task) async {
    await mergeAudioVideo(task.cacheItem, task.cachePlatform,
        groupTitle: task.groupTitle);
  }

  //处理特殊字符
  static String? handleSpecialCharacters(String? str) {
    if (str == null) {
      return null;
    }
    var result = runPlatformFunc<String?>(onDefault: (){
      return StrUtils.sanitizeAndroidFileName(str);
    },onWindows: (){
      return StrUtils.sanitizeWindowsFileName(str);
    },onLinux: (){
      return StrUtils.sanitizeLinuxFileName(str);
    });
    return result;
  }

  // 合并音视频
  Future<void> mergeAudioVideo(CacheItem item, CachePlatform cachePlatform,
      {String? groupTitle}) async {
    var audioPath = item.audioPath;
    var videoPath = item.videoPath;
    // 处理特殊字符
    var title = handleSpecialCharacters(item.title);
    var blvList = item.blvPathList;
    // 处理特殊字符
    groupTitle = handleSpecialCharacters(groupTitle);

    var result =
        await runPlatformFuncFuture<Pair<bool, String>?>(onDefault: () async {
      // 输出文件名
      var outputFileName = title == null
          ? "${DateTime.now().millisecondsSinceEpoch}.mp4"
          : "$title.mp4";

      // 输出目录
      var outputDirPath = HomeLogic.getOutputDirPath(groupTitle: groupTitle);
      if (outputDirPath == null) {
        return Pair(false, "请先选择输出目录");
      }
      var outputPath = path.join(outputDirPath, outputFileName);

      //判断输出文件是否存在,如果存在则重命名
      outputPath = await FileUtils.getAvailableFilePath(outputPath);

      //结果pair
      var resultPair = Pair(false, "缺少输入源");

      //输入路径
      if (audioPath != null && videoPath != null) {
        switch (cachePlatform) {
          case CachePlatform.mac:
          case CachePlatform.win:
            String tempAudioPath = "${audioPath}.hlb_temp.mp3";
            String tempVideoPath = "${videoPath}.hlb_temp.mp4";
            // 解密
            await FileUtils.decryptPcM4sAfter202403(audioPath, tempAudioPath);
            await FileUtils.decryptPcM4sAfter202403(videoPath, tempVideoPath);
            // 合并
            resultPair = await ffmpegPlugin.mergeAudioVideo(
              tempAudioPath,
              tempVideoPath,
              outputPath,
            );

            // 异步删除临时文件
            Future.delayed(const Duration(seconds: 2), () async {
              try {
                await File(tempAudioPath).delete();
                await File(tempVideoPath).delete();
              } catch (e) {
                e.printError();
              }
            });

            break;

          case CachePlatform.android:
            // 合并
            resultPair = await ffmpegPlugin.mergeAudioVideo(
              audioPath,
              videoPath,
              outputPath,
            );
            break;
        }
      } else if (blvList != null && blvList.isNotEmpty) {
        //blv格式
        //排序
        blvList.sort((a, b) {
          final regex = RegExp(r'(\d+)\.blv$');
          final matchA = regex.firstMatch(a);
          final matchB = regex.firstMatch(b);
          if (matchA == null || matchB == null) return a.compareTo(b);
          final numA = int.parse(matchA.group(1)!);
          final numB = int.parse(matchB.group(1)!);
          return numA.compareTo(numB);
        });
        print("排序后的blvList:$blvList");
        // 合并
        resultPair = await ffmpegPlugin.mergeVideos(
          blvList,
          outputPath,
        );
      }

      if(resultPair.first){
        //导出弹幕文件
        if (_isExportDanmakuFile) {
          final srcPath = item.danmakuPath;
          final destPath = FileUtils.changeFileExtension(outputPath, "xml");;
          if (srcPath != null) {
            FileUtils.copyFile(srcPath, destPath);
          }
        }
      }

      return resultPair;
    });

    if (result == null) {
      print("$title 合并未知错误");
      throw Exception("合并未知错误");
      return;
    }

    if (result.first) {
      print("$title 合并完成");
    } else {
      print("合并错误:${result.second}");
      throw Exception("合并错误:${result.second}");
    }
  }
}
