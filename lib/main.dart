import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hlbmerge/dao/sp_data_manager.dart';
import 'package:hlbmerge/pages/app_pages.dart';

void main() async {
  await SpDataManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // SmartDialog观察者
      navigatorObservers: [FlutterSmartDialog.observer],
      // SmartDialog初始化
      builder: FlutterSmartDialog.init(),
      /// 初始路由
      initialRoute: AppPages.INITIAL,
      /// 所有的页面
      getPages: AppPages.routes,
    );
  }
}
