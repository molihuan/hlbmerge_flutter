import 'dart:io';

import 'package:get/get.dart';
import 'package:hlbmerge/dao/sp_data_manager.dart';

import 'state.dart';

class ProgressLogic extends GetxController {
  final ProgressState state = ProgressState();

  //加载输出目录中的文件夹
  void loadOutputChildDirList() {
    var outputDirPath = SpDataManager.getOutputDirPath();
    state.outputChildDirList = Directory(outputDirPath).listSync().whereType<Directory>().toList();
  }

  //归档
  void archive() {
    loadOutputChildDirList();
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
