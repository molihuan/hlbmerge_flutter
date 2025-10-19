import 'dart:io';

import 'package:get/get.dart';
import 'package:hlbmerge/channel/main/main_channel.dart';
import 'package:hlbmerge/dao/sp_data_manager.dart';
import 'package:hlbmerge/ui/uitools/DialogTool.dart';
import 'package:hlbmerge/utils/FileUtils.dart';
import 'package:url_launcher/url_launcher.dart';

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
      return FileUtils.isDir(it.path) || it.path.endsWith(".mp4")|| it.path.endsWith(".mp3");
    }).toList();
    //通知系统文件导出完成
    MainChannel.notifySystemFileExportComplete();
  }

  //打开文件或文件夹
  Future<void> openFile(String path) async {
    var isFile = FileUtils.isFile(path);
    Uri uri;
    if (isFile) {
      uri = Uri.file(path);
    } else {
      uri = Uri.directory(path);
    }
    DialogTool.showLoading(message: "正在打开...");

    try{
      if (await launchUrl(uri)) {
        Get.snackbar("提示", "已打开,可能有延迟,请稍后");
      }else{
        Get.snackbar("提示", "无法打开,请在路径中手动打开");
      }
    }catch(e){
      print(e);
      Get.snackbar("提示", "无法打开,请在路径中手动打开");
    }

    DialogTool.hideLoading();
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
