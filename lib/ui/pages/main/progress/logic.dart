import 'dart:io';

import 'package:get/get.dart';
import 'package:hlbmerge/channel/main/main_channel.dart';
import 'package:hlbmerge/dao/sp_data_manager.dart';
import 'package:hlbmerge/utils/FileUtils.dart';

import '../../../../service/ffmpeg/ffmpeg_task.dart';
import 'state.dart';

class ProgressLogic extends GetxController {
  final ProgressState state = ProgressState();

  late final FFmpegTaskController taskController = Get.find();

  //加载输出目录中的文件夹
  void loadOutputChildDirList() {
    taskController.clearTasks();
    var outputDirPath = SpDataManager.getOutputDirPath();
    if (outputDirPath == null) {
      return;
    }
    var targetDir = Directory(outputDirPath);
    if (!targetDir.existsSync()) {
      return;
    }

    var fileList = targetDir.listSync();
    //过滤出文件夹和后缀为.mp4的文件
    state.outputChildFileList = fileList.where((it) {
      return FileUtils.isDir(it.path) || it.path.endsWith(".mp4");
    }).toList();
    //通知系统文件导出完成
    MainChannel.notifySystemFileExportComplete();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    loadOutputChildDirList();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
