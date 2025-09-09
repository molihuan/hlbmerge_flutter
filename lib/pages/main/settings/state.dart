import 'dart:io';

import 'package:get/get.dart';
import 'package:hlbmerge/dao/sp_data_manager.dart';
import 'package:hlbmerge/utils/FileUtil.dart';

class SettingsState {
  SettingsState() {
    ///Initialize variables
    outputDirPath = SpDataManager.getOutputDirPath();
  }
  //输出路径
  final _outputDirPath = ''.obs;

  set outputDirPath(value) => _outputDirPath.value = value;

  get outputDirPath => _outputDirPath.value;
}
