import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../dao/cache_data_manager.dart';
import '../../models/cache_group.dart';
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

    // 设置状态栏样式
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarIconBrightness: Brightness.dark, // 状态栏图标颜色
      statusBarBrightness: Brightness.light, // iOS 状态栏文字颜色
    ));
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
