import 'dart:io';

import 'package:get/get.dart';
import 'package:hlbmerge/dao/sp_data_manager.dart';
import 'package:hlbmerge/utils/FileUtils.dart';

class SettingsState {
  SettingsState() {
    ///Initialize variables
    outputDirPath = SpDataManager.getOutputDirPath(futureCallback: (path) {
      outputDirPath = path;
    }) ?? "";
    singleOutputPathChecked = SpDataManager.getSingleOutputPathChecked();
  }

  //输出路径
  final _outputDirPath = ''.obs;
  set outputDirPath(value) => _outputDirPath.value = value;
  get outputDirPath => _outputDirPath.value;

  //是否单一输出目录
  final _singleOutputPathChecked = false.obs;
  set singleOutputPathChecked(value) => _singleOutputPathChecked.value = value;
  get singleOutputPathChecked => _singleOutputPathChecked.value;
}
