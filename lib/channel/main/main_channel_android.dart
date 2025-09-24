import 'dart:async';

import 'package:ffmpeg_hl/beans/Pair.dart';
import 'package:ffmpeg_hl/beans/Triple.dart';
import 'package:flutter/services.dart';

import 'main_channel_interface.dart';

enum ActivityScreen {
  pathSelectScreen("AndroidActivity/PathSelectScreen");

  //route
  final String route;

  const ActivityScreen(this.route);
}

class MainChannelAndroid extends MainChannelInterface {
  late final MethodChannel _platform =
      const MethodChannel("com.molihuan.hlbmerge/mainChannel");

  @override
  void init() {
    _platform.setMethodCallHandler(methodCallHandler);
  }

  Future<dynamic> methodCallHandler(MethodCall call) async {
    if (call.method ==
        NativePageEventType.onReturnFlutterPageFromNativePage.v) {
      super.nativePageController.add(
          Pair(NativePageEventType.onReturnFlutterPageFromNativePage, null));
    }
  }

  @override
  Future<Triple<int, String, Map?>> startActivity(String to,
      {Map<String, String>? args}) async {
    final result =
        await _platform.invokeMethod("startActivity", {"to": to, "args": args});
    print(result);
    if (result is Map) {
      final int code = result["code"];
      final String msg = result["msg"];
      final Map? data = result["data"];
      return Triple(code, msg, data);
    }
    return returnError;
  }

  @override
  Future<Triple<int, String, bool?>> hasReadWritePermission() async {
    final result = await _platform.invokeMethod("hasReadWritePermission");
    print(result);
    if (result is Map) {
      final int code = result["code"];
      final String msg = result["msg"];
      final Map? data = result["data"];
      final bool? hasPermission = data?["hasPermission"];
      return Triple(code, msg, hasPermission);
    }
    return returnError;
  }

  @override
  Future<Triple<int, String, bool?>> grantReadWritePermission() async {
    final result = await _platform.invokeMethod("grantReadWritePermission");
    print(result);
    if (result is Map) {
      final int code = result["code"];
      final String msg = result["msg"];
      final Map? data = result["data"];
      final bool? grantPermission = data?["grantPermission"];
      return Triple(code, msg, grantPermission);
    }
    return returnError;
  }

  @override
  Future<Triple<int, String, String?>> getExternalStorageRootPath() async {
    final result = await _platform.invokeMethod("getExternalStorageRootPath");
    print(result);
    if (result is Map) {
      final int code = result["code"];
      final String msg = result["msg"];
      final Map? data = result["data"];
      final String? path = data?["path"];
      return Triple(code, msg, path);
    }
    return returnError;
  }

  @override
  Future<Triple<int, String, String?>> getDefaultOutputDirPath() async {
    final result = await _platform.invokeMethod("getDefaultOutputDirPath");
    print(result);
    if (result is Map) {
      final int code = result["code"];
      final String msg = result["msg"];
      final Map? data = result["data"];
      final String? path = data?["path"];
      return Triple(code, msg, path);
    }
    return returnError;
  }
}
