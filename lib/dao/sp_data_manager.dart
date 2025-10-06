import 'dart:io';

import 'package:get/get.dart';
import 'package:hlbmerge/channel/main/main_channel.dart';
import 'package:hlbmerge/utils/PlatformUtils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/pages/main/home/state.dart';
import '../utils/FileUtils.dart';
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
  static setOutputDirPath(String? path) {
    if (path == null) {
      prefs.remove(outputDirPathKey);
      return;
    }
    prefs.setString(outputDirPathKey, path);
  }

  static String? getOutputDirPath({void Function(String)? futureCallback}) {
    return prefs.getString(outputDirPathKey) ??
        _getDefaultOutputDirPath(futureCallback: futureCallback);
  }

  //获取默认的输出路径
  static String? _getDefaultOutputDirPath(
      {void Function(String)? futureCallback}) {
    var outputDir = runPlatformFunc<Directory?>(onDefault: () {
      var currExeDir = FileUtils.getCurrExeDir();
      return Directory('${currExeDir.path}/outputDir');
    }, onAndroid: () {
      MainChannel.getDefaultOutputDirPath().then((result) {
        print("获取安卓默认输出路径结果:${result}");
        if (result.first != 0) {
          return;
        }
        final path = result.third;
        if (path == null) {
          return;
        }
        //持久化
        SpDataManager.setOutputDirPath(path);
        futureCallback?.call(path);
      });
      return null;
    }, onOhos: () {
      return null;
    }, onMacOS: () {
      return null;
    });

    if (outputDir == null) {
      return null;
    }

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

  static Future<String?> getInputCacheDirPathByReload() async {
    await prefs.reload(); // 确保读的是最新的
    return prefs.getString(inputCacheDirPathKey);
  }

  //缓存数据平台
  static setCachePlatform(CachePlatform platform) {
    prefs.setString(cachePlatformKey, platform.name);
  }

  static CachePlatform? getCachePlatform() {
    String? target = prefs.getString(cachePlatformKey);
    return CachePlatform.values
        .firstWhereOrNull((element) => element.name == target);
  }

  //key
  static const String androidParseCachePermissionKey =
      'androidParseCachePermission';

  //安卓解析缓存权限
  static setAndroidParseCachePermission(
      AndroidParseCachePermission permission) {
    prefs.setString(androidParseCachePermissionKey, permission.name);
  }

  static Future<AndroidParseCachePermission?>
      getAndroidParseCachePermission() async {
    await prefs.reload();
    String? target = prefs.getString(androidParseCachePermissionKey);
    return AndroidParseCachePermission.values
        .firstWhereOrNull((element) => element.name == target);
  }

  //是否单一输出目录
  static const String singleOutputPathCheckedKey = 'singleOutputPathChecked';

  static setSingleOutputPathChecked(bool checked) {
    prefs.setBool(singleOutputPathCheckedKey, checked);
  }

  static bool getSingleOutputPathChecked() {
    return prefs.getBool(singleOutputPathCheckedKey) ?? false;
  }

  //导出弹幕文件Checked
  static const String exportDanmakuFileCheckedKey = 'exportDanmakuFileChecked';
  static setExportDanmakuFileChecked(bool checked) {
    prefs.setBool(exportDanmakuFileCheckedKey, checked);
  }
  static bool getExportDanmakuFileChecked() {
    return prefs.getBool(exportDanmakuFileCheckedKey) ?? false;
  }

  //导出时添加序号
  static const String exportFileAddIndexKey = 'exportFileAddIndex';

  static setExportFileAddIndex(bool checked) {
    prefs.setBool(exportFileAddIndexKey, checked);
  }

  static bool getExportFileAddIndex() {
    return prefs.getBool(exportFileAddIndexKey) ??
        runPlatformFunc(onDefault: () {
          return false;
        }, onAndroid: () {
          return true;
        });
  }
}
