
import 'dart:io';

import 'package:hlbmerge/features/export/copy/base_copy_file_server.dart';
import 'package:hlbmerge/log/log.dart';
import 'package:hlbmerge/repository/settings_repository.dart';
import 'package:tuple/tuple.dart';

import '../../../../generate/pigeon/flutter_native_api.g.dart';
import '../../../../utils/file_util.dart';
import '../../merge/model/cache_item.dart';



class AndroidCopyFileServer extends BaseCopyFileServer {
  late final _copyTempDirPath = SettingsRepository.getInputCacheDirPath();
  late final _nativeApis = NativeApis();

  @override
  Future<bool> prepareData(CacheItem item) async {
    //如果不是安卓就直接返回成功
    if (!Platform.isAndroid) {
      return true;
    }
    final sufPath = item.path?.replaceFirst(_copyTempDirPath, "");
    if (sufPath == null || sufPath.isEmpty) {
      return false;
    }
    //拷贝缓存数据
    final copyResult = await _nativeApis.copyCacheAudioVideoFile(sufPath);

    if (copyResult.data) {
      return true;
    }
    return false;
  }

  @override
  Future<Tuple2<bool, String?>> finalExportFile(
    String srcPath,
    String destPath,
  ) async {
    try {
      bool result = await FileUtil.copyFile(srcPath, destPath);
      return Tuple2(result, null);
    } catch (e) {
      Log.e("finalExportFile err", e);
      return Tuple2(false, e.toString());
    }
  }
}
