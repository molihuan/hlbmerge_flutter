import 'dart:io';

import 'package:get/get.dart';
import 'package:hlbmerge/dao/sp_data_manager.dart';
import 'package:hlbmerge/utils/FileUtils.dart';

class SettingsState {
  SettingsState() {
    ///Initialize variables
    outputDirPath = SpDataManager.getOutputDirPath(futureCallback: (path) {
          outputDirPath = path;
        }) ??
        "";
    singleOutputPathChecked = SpDataManager.getSingleOutputPathChecked();
    exportFileAddIndex = SpDataManager.getExportFileAddIndex();
    exportDanmakuFileChecked = SpDataManager.getExportDanmakuFileChecked();
  }

  //输出路径
  final _outputDirPath = ''.obs;

  set outputDirPath(value) => _outputDirPath.value = value;

  get outputDirPath => _outputDirPath.value;

  //是否单一输出目录
  final _singleOutputPathChecked = false.obs;

  set singleOutputPathChecked(value) => _singleOutputPathChecked.value = value;

  get singleOutputPathChecked => _singleOutputPathChecked.value;

  //导出时添加序号
  final _exportFileAddIndex = false.obs;
  set exportFileAddIndex(value) => _exportFileAddIndex.value = value;
  get exportFileAddIndex => _exportFileAddIndex.value;
  //导出时导出弹幕文件Checked
  final _exportDanmakuFileChecked = false.obs;
  set exportDanmakuFileChecked(value) =>
      _exportDanmakuFileChecked.value = value;
  get exportDanmakuFileChecked => _exportDanmakuFileChecked.value;
}
