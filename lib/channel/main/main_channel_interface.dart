import 'package:ffmpeg_hl/beans/Triple.dart';

abstract class MainChannelInterface {
  Future<Triple<int, String, Map?>> startActivity(String to,{Map<String,String>? args});
}