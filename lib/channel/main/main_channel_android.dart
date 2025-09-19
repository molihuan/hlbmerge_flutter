import 'package:ffmpeg_hl/beans/Triple.dart';
import 'package:flutter/services.dart';

import 'main_channel_interface.dart';

class MainChannelAndroid extends MainChannelInterface {
  late final MethodChannel _platform =
      const MethodChannel("com.molihuan.hlbmerge/mainChannel");

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
    return Triple(0, "", null);
  }
}
