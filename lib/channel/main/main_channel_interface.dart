import 'package:ffmpeg_hl/beans/Triple.dart';

abstract class MainChannelInterface {
  // 返回错误
  final returnError = Triple(-1, "fail return error", null);

  Future<Triple<int, String, Map?>> startActivity(String to,
      {Map<String, String>? args}) {
    throw UnimplementedError();
  }

  Future<Triple<int, String, bool?>> hasReadWritePermission() {
    return Future.value(Triple(0, "ok", true));
  }

  Future<Triple<int, String, bool?>> grantReadWritePermission() {
    return Future.value(Triple(0, "ok", true));
  }

  Future<Triple<int, String, String?>> getExternalStorageRootPath() {
    throw UnimplementedError();
  }

  Future<Triple<int, String, String?>> getDefaultOutputDirPath() {
    throw UnimplementedError();
  }

}