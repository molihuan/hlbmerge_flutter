import 'package:ffmpeg_hl/beans/Triple.dart';
import 'package:flutter/services.dart';
import 'package:hlbmerge/utils/PlatformUtils.dart';

import 'main_channel_android.dart';
import 'main_channel_interface.dart';

class MainChannel {
  late MainChannelInterface _interface;
  MainChannel(){
    _interface = runPlatformFunc<MainChannelInterface>(onDefault: () {
      return MainChannelAndroid();
    });
  }

  Future<Triple<int, String, Map?>> startActivity(String to,{Map<String,String>? args}) async {
    return await _interface.startActivity(to, args: args);
  }
}
