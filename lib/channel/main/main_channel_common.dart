import 'package:ffmpeg_hl/beans/Triple.dart';
import 'package:flutter/services.dart';

import 'main_channel_interface.dart';

class MainChannelCommon extends MainChannelInterface {
  late final MethodChannel _platform =
      const MethodChannel("com.molihuan.hlbmerge/mainChannel");
}
