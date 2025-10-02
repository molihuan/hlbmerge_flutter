import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hlbmerge/dao/sp_data_manager.dart';

import 'ui/pages/app_pages.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      /// 初始路由
      initialRoute: AppPages.INITIAL,
      /// 所有的页面
      getPages: AppPages.routes,
    );
  }
}
