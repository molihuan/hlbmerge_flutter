import 'dart:io';

import 'package:get/get.dart';
import 'package:hlbmerge/dao/sp_data_manager.dart';
import 'package:hlbmerge/utils/FileUtil.dart';

class SettingsState {
  SettingsState() {
    ///Initialize variables
    var outPath = SpDataManager.getOutputDirPath() ?? _getDefaultOutputDirPath();
    outputDirPath = outPath;
  }

  //获取默认的输出路径
  String _getDefaultOutputDirPath() {
    var currExeDir = FileUtil.getCurrExeDir();
    var outputDir = Directory('${currExeDir.path}/outputDir');

    // 如果目录不存在则创建
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }
    //持久化
    SpDataManager.setOutputDirPath(outputDir.path);

    return outputDir.path;
  }


  //输出路径
  final _outputDirPath = ''.obs;

  set outputDirPath(value) => _outputDirPath.value = value;

  get outputDirPath => _outputDirPath.value;
}
