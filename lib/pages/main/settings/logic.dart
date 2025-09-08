import 'dart:io';

import 'package:ffmpeg_hl/ffmpeg_hl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hlbmerge/dao/cache_data_manager.dart';
import 'package:hlbmerge/dao/sp_data_manager.dart';
import 'package:hlbmerge/utils/StrUtil.dart';
import 'package:hlbmerge/models/cache_group.dart';

import 'state.dart';

class SettingsLogic extends GetxController {
  final SettingsState state = SettingsState();

  late final ffmpegHlPlugin = FfmpegHl();

  Future<String?> getAvcodecCfg() async {
    var cfgStr = await ffmpegHlPlugin.getAvcodecCfg();
    return cfgStr;
  }

  mergeAudioVideo() async {
    // var result = await ffmpegHlPlugin.mergeAudioVideo("1", "2", "3");
    // if (result.first) {}

    //获取文件夹路径
    String? dirPath = await FilePicker.platform.getDirectoryPath();
    if(dirPath == null){
      return;
    }

    var manager = CacheDataManager();
    List<CacheGroup> cacheGroupList = manager.loadCacheData(dirPath);
    print(cacheGroupList);


  }

  //解析缓存数据
  parseCacheData() async {
    String dirPath = "C:/Users/moli/FlutterProject/hlbmerge_flutter/testRes/电脑缓存文件";

    var manager = CacheDataManager();
    List<CacheGroup>? cacheGroupList = manager.loadPcCacheData(dirPath);
    // print(cacheGroupList);
  }


  //选择输出路径
  selectOutputPath() async {
    String? dirPath = await FilePicker.platform.getDirectoryPath();

    if (dirPath == null) {
      Get.snackbar("提示", "您未选择路径");
      return;
    }

    print(dirPath);
    //判断路径中是否有空格
    if (StrUtil.containsAnySpace(dirPath)) {
      Get.snackbar("提示", "路径中不能包含空格,请重新选择");
      return;
    }
    state.outputDirPath = dirPath;
    //持久化
    SpDataManager.setOutputDirPath(dirPath);
    Get.snackbar("提示", "已选择输出路径:$dirPath");
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
