import 'dart:io';

import 'package:hlbmerge/utils/file_util.dart';
import 'package:hlbmerge/utils/platform_util.dart';

import '../base_storage.dart';

abstract class LocalStorage implements BaseStorage {
  //存储数据路径
  String? getDataStoragePath() {
    return runPlatformGroup(
      orElse: () {
        return null;
      },
      onDesktop: () {
        final currExeDir = FileUtil.getCurrExeDir();
        final dataDir = Directory('${currExeDir.path}/data/storage');
        //如果不存在就创建
        if (!dataDir.existsSync()) {
          dataDir.createSync();
        }
        return dataDir.path;
      },
    );
  }
}
