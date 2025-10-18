import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'progress/view.dart';
import 'settings/view.dart';
import 'home/view.dart';
import 'state.dart';

class MainLogic extends GetxController {
  final MainState state = MainState();

  final pages = [
    HomePage(),
    ProgressPage(),
    SettingsPage(),
  ];

  //获取当前页面
  getCurrPage() {
    return pages[state.currPageIndex];
  }
  //切换页面
  void changePage(int index) {
    state.currPageIndex = index;
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    // 设置状态栏样式 - 根据主题动态调整
    _updateSystemUI();
  }

  // 更新系统UI样式
  void _updateSystemUI() {
    final brightness = Get.theme.brightness;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarIconBrightness: brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark, // 动态调整状态栏图标颜色
      statusBarBrightness: brightness == Brightness.dark
          ? Brightness.dark
          : Brightness.light, // iOS 状态栏文字颜色
    ));
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}