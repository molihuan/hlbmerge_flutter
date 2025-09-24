import 'dart:async';

import 'package:ffmpeg_hl/beans/Pair.dart';
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

  late final nativePageController = StreamController<Pair<NativePageEventType, NativePageEventParams?>>.broadcast();

  Stream<Pair<NativePageEventType, NativePageEventParams?>> get onNativePageEvent => nativePageController.stream;

  void init() {}
}
// native页面事件类型
enum NativePageEventType {
  //onReturnFlutterPageFromNativePage
  onReturnFlutterPageFromNativePage("onReturnFlutterPageFromNativePage");

  final String v;

  const NativePageEventType(this.v);
}
//native页面事件参数
class NativePageEventParams {
}
