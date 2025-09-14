import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/FileUtil.dart';
import 'cache_data_manager.dart';

class SpDataManager {
  static late SharedPreferences prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  //清空
  static clear() {
    prefs.clear();
  }

  //输出目录key
  static const String outputDirPathKey = 'outputDirPath';

  //输入缓存文件夹路径
  static const String inputCacheDirPathKey = 'inputCacheDirPath';
  static const String cachePlatformKey = 'cachePlatform';

  //输出目录
  static setOutputDirPath(String path) {
    prefs.setString(outputDirPathKey, path);
  }

  static String getOutputDirPath() {
    return prefs.getString(outputDirPathKey) ?? _getDefaultOutputDirPath();
  }

  //获取默认的输出路径
  static String _getDefaultOutputDirPath() {
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

  //输入缓存文件夹路径
  static setInputCacheDirPath(String path) {
    prefs.setString(inputCacheDirPathKey, path);
  }

  static String? getInputCacheDirPath() {
    return prefs.getString(inputCacheDirPathKey);
  }

  //缓存数据平台
  static setCachePlatform(CachePlatform platform){
    prefs.setString(cachePlatformKey, platform.name);
  }

  static CachePlatform? getCachePlatform(){
    String? target = prefs.getString(cachePlatformKey);
    return CachePlatform.values.firstWhereOrNull((element) => element.name == target);
  }
}
