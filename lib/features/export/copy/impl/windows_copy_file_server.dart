

import 'package:hlbmerge/features/export/copy/base_copy_file_server.dart';


import 'package:hlbmerge/log/log.dart';

import 'package:tuple/tuple.dart';

import '../../../../utils/file_util.dart';
import '../../merge/model/cache_item.dart';



class WindowsCopyFileServer extends BaseCopyFileServer {

  @override
  Future<bool> prepareData(CacheItem item) async {
    return true;
  }

  @override
  Future<Tuple2<bool, String?>> finalExportFile(
    String srcPath,
    String destPath,
  ) async {
    //解密m4s
    try {
      bool result = await FileUtil.decryptPcM4sAfter202403(srcPath, destPath);
      return Tuple2(result, null);
    } catch (e) {
      Log.e("finalExportFile err:解密失败", e);
      return Tuple2(false, e.toString());
    }
  }
}
