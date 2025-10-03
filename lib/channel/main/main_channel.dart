import 'dart:async';

import 'package:ffmpeg_hl/beans/Pair.dart';
import 'package:ffmpeg_hl/beans/Triple.dart';
import 'package:flutter/services.dart';
import 'package:hlbmerge/channel/main/main_channel_common.dart';
import 'package:hlbmerge/utils/PlatformUtils.dart';

import 'main_channel_android.dart';
import 'main_channel_interface.dart';

class MainChannel {
  MainChannel._();
  //是否初始化
  static bool _isInit = false;

  static MainChannelInterface? _interface;

  static MainChannelInterface get interface => _interface ?? _initInterface();

  static _initInterface() {
    _interface = runPlatformFunc<MainChannelInterface>(onDefault: () {
      return MainChannelCommon();
    },onAndroid: (){
      return MainChannelAndroid();
    });
    return _interface;
  }

  static void init(){
    if(_isInit){
      return;
    }
    _isInit = true;
    interface.init();
  }

  static Stream<Pair<NativePageEventType, NativePageEventParams?>> get onNativePageEvent {
    init();
    return interface.onNativePageEvent;
  }


  static Future<Triple<int, String, Map?>> startActivity(String to,
      {Map<String, String>? args}) async {
    return await interface.startActivity(to, args: args);
  }

  static Future<Triple<int, String, bool?>> hasReadWritePermission() async {
    return await interface.hasReadWritePermission();
  }
  static Future<Triple<int, String, bool?>> grantReadWritePermission() async {
    return await interface.grantReadWritePermission();
  }
  static Future<Triple<int, String, String?>> getExternalStorageRootPath() async {
    return await interface.getExternalStorageRootPath();
  }
  static Future<Triple<int, String, String?>> getDefaultOutputDirPath() async {
    return await interface.getDefaultOutputDirPath();
  }
  static Future<Triple<int, String, Map?>> copyCacheAudioVideoFile(String sufPath) async {
    return await interface.copyCacheAudioVideoFile(sufPath);
  }
  static Future<Triple<int, String, Map?>> copyCacheStructureFile() async {
    return await interface.copyCacheStructureFile();
  }
  static void notifySystemFileExportComplete(){
    interface.notifySystemFileExportComplete();
  }
}
