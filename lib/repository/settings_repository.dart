import 'dart:io';

import '../features/export/cache_data_manager.dart';
import '../generate/pigeon/flutter_native_api.g.dart';
import '../storage/impl/local/mmkv/mmkv_storage.dart';
import '../storage/impl/local_storage.dart';
import '../utils/file_util.dart';
import '../utils/platform_util.dart';

class SettingsRepository {
  SettingsRepository._();

  static const String storageName = "app_settings";
  static final LocalStorage _localStorage = MMKVStorage();

  static Future<void> init() async {
    await _localStorage.init();
  }

  //清空
  static clear() {
    _localStorage.removeAll();
  }

  //输出目录key
  static const String outputDirPathKey = 'outputDirPath';

  //输入缓存文件夹路径
  static const String inputCacheDirPathKey = 'inputCacheDirPath';

  //缓存数据平台
  static const String cachePlatformKey = 'cachePlatform';

  //输出目录
  static setOutputDirPath(String? path) {
    if (path == null) {
      _localStorage.remove(outputDirPathKey);
      return;
    }
    _localStorage.saveValue(outputDirPathKey, path);
  }

  static Future<String?> getOutputDirPath() async {
    String? path = _localStorage.loadValue<String>(
      outputDirPathKey,
      defaultValue: "",
    );

    if (path.isEmpty) {
      path = await _getDefaultOutputDirPath();
    }

    return path;
  }

  //获取默认的输出路径
  static Future<String?> _getDefaultOutputDirPath() async {
    var outputDir = await runPlatformAsync<Directory?>(
      orElse: () {
        final currExeDir = FileUtil.getCurrExeDir();
        return Directory('${currExeDir.path}/outputDir');
      },
      onAndroid: () async {
        final nativeApis = NativeApis();
        final result = await nativeApis.getDefaultOutputDirPath();
        print("获取安卓默认输出路径结果:${result}");
        if (result.code != 0) {
          return null;
        }
        final path = result.data;
        if (path == null) {
          return null;
        }
        return Directory(path);
      },
      onOhos: () {
        return null;
      },
      onMacOS: () {
        return null;
      },
      onWeb: () {
        return null;
      },
    );

    if (outputDir == null) {
      return null;
    }

    // 如果目录不存在则创建
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }
    //持久化
    SettingsRepository.setOutputDirPath(outputDir.path);

    return outputDir.path;
  }

  //输入缓存文件夹路径
  static setInputCacheDirPath(String path) {
    _localStorage.saveValue(inputCacheDirPathKey, path);
  }

  static String getInputCacheDirPath() {
    return _localStorage.loadValue<String>(
      inputCacheDirPathKey,
      defaultValue: "",
    );
  }

  //导出模式
  static const String outputFileModeKey = 'outputFileMode';

  //设置导出模式
  static setOutputFileMode(OutputFileMode mode) {
    _localStorage.saveValue(outputFileModeKey, mode.name);
  }

  //获取导出模式
  static OutputFileMode getOutputFileMode() {
    String target = _localStorage.loadValue<String>(
      outputFileModeKey,
      defaultValue: "",
    );
    return OutputFileMode.values.firstWhereOrNull(
          (element) => element.name == target,
        ) ??
        OutputFileMode.all;
  }

  //缓存数据平台
  static setCachePlatform(CachePlatform platform) {
    _localStorage.saveValue(cachePlatformKey, platform.name);
  }

  static CachePlatform getCachePlatform() {
    String target = _localStorage.loadValue<String>(
      cachePlatformKey,
      defaultValue: "",
    );

    var type = CachePlatform.values.firstWhereOrNull(
      (element) => element.name == target,
    );

    if (type == null) {
      return runPlatform<CachePlatform>(
        onAndroid: () {
          return CachePlatform.android;
        },
        onWindows: () {
          return CachePlatform.win;
        },
        onMacOS: () {
          return CachePlatform.mac;
        },
        orElse: () {
          return CachePlatform.android;
        },
      );
    }

    return type;
  }

  //key
  static const String androidParseCachePermissionKey =
      'androidParseCachePermission';

  //安卓解析缓存权限
  static setAndroidParseCachePermission(
    AndroidParseCachePermission permission,
  ) {
    _localStorage.saveValue(androidParseCachePermissionKey, permission.name);
  }

  static Future<AndroidParseCachePermission?>
  getAndroidParseCachePermission() async {
    String target = _localStorage.loadValue<String>(
      androidParseCachePermissionKey,
      defaultValue: "",
    );
    return AndroidParseCachePermission.values.firstWhereOrNull(
      (element) => element.name == target,
    );
  }

  //是否单一输出目录
  static const String singleOutputPathCheckedKey = 'singleOutputPathChecked';

  static setSingleOutputPathChecked(bool checked) {
    _localStorage.saveValue(singleOutputPathCheckedKey, checked);
  }

  static bool getSingleOutputPathChecked() {
    return _localStorage.loadValue(
      singleOutputPathCheckedKey,
      defaultValue: false,
    );
  }

  //导出弹幕文件Checked
  static const String exportDanmakuFileCheckedKey = 'exportDanmakuFileChecked';

  static setExportDanmakuFileChecked(bool checked) {
    _localStorage.saveValue(exportDanmakuFileCheckedKey, checked);
  }

  static bool getExportDanmakuFileChecked() {
    return _localStorage.loadValue(
      exportDanmakuFileCheckedKey,
      defaultValue: false,
    );
  }

  //导出时添加序号
  static const String exportFileAddIndexKey = 'exportFileAddIndex';

  static setExportFileAddIndex(bool checked) {
    _localStorage.saveValue(exportFileAddIndexKey, checked);
  }

  static bool getExportFileAddIndex() {
    return _localStorage.loadValue(
      exportFileAddIndexKey,
      defaultValue: runPlatform(
        orElse: () {
          return false;
        },
        onAndroid: () {
          return true;
        },
      ),
    );
  }

  //安卓读取InputCache packageName
  static const String androidInputCachePackageNameKey =
      'androidInputCachePackageName';

  static String getAndroidInputCachePackageName() {
    return _localStorage.loadValue<String>(
      androidInputCachePackageNameKey,
      defaultValue: "",
    );
  }
}

/// 扩展
extension FirstWhereExt<T> on List<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

/// 安卓解析缓存权限
enum AndroidParseCachePermission {
  //读写权限
  readWrite,
  //document uri权限
  documentUri,
  //shizuku
  shizuku,
}
