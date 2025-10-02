import 'dart:io';

import 'package:ffmpeg_hl/ffmpeg_hl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hlbmerge/dao/cache_data_manager.dart';
import 'package:hlbmerge/dao/sp_data_manager.dart';
import 'package:hlbmerge/pages/app_pages.dart';
import 'package:hlbmerge/utils/StrUtil.dart';
import 'package:hlbmerge/models/cache_group.dart';
import 'package:path_provider/path_provider.dart';

import '../../../channel/main/main_channel.dart';
import '../../../channel/main/main_channel_android.dart';
import 'state.dart';

class SettingsLogic extends GetxController {
  final SettingsState state = SettingsState();

  late final ffmpegHlPlugin = FfmpegHl();
  late final _cacheDataManager = CacheDataManager();


  //获取ffmpeg版本配置
  showAvcodecCfg() async {
    var cfgStr = await ffmpegHlPlugin.getAvcodecCfg();
    Get.snackbar("Avcodec配置", "",
        messageText: Text(cfgStr ?? "获取失败",
            maxLines: 10, // 最多显示 3 行
            overflow: TextOverflow.ellipsis));
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

  void startPathSelectScreen() async {
    var result = await MainChannel.startActivity(ActivityScreen.pathSelectScreen.route);
    print(result);
  }

  void goAboutPage() {
    Get.toNamed(AppRoutes.AboutPage);
  }


  // 测试方法
  testFunc() async {
    // var platformVersion = await ffmpegHlPlugin.getPlatformVersion();
    // print(platformVersion);

    // _cacheDataManager.setCachePlatform(CachePlatform.android);
    // _cacheDataManager.loadCacheData("C:\\Users\\moli\\FlutterProject\\hlbmerge_flutter\\testRes\\手机缓存文件");

    // var list = await getExternalStorageDirectory();
    // print(list?.path);
  }

  @override
  void onReady() {
    testFunc();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
