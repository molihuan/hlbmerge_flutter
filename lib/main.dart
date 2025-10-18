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

      // 浅色主题
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,

        // 扩展浅色主题配置
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // 浅色背景
        cardColor: Colors.white, // 卡片颜色
        dialogBackgroundColor: Colors.white, // 对话框背景

        // 文字主题
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF333333)),
          bodyMedium: TextStyle(color: Color(0xFF666666)),
          titleLarge: TextStyle(color: Color(0xFF222222)),
        ),

        // 应用栏主题
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF333333),
          elevation: 1,
        ),

        // 底部导航栏主题
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Color(0xFF888888),
        ),
      ),

      // 深色主题
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,

        // 扩展深色主题配置
        scaffoldBackgroundColor: const Color(0xFF121212), // 深色背景
        cardColor: const Color(0xFF1E1E1E), // 深色卡片
        dialogBackgroundColor: const Color(0xFF1E1E1E), // 深色对话框背景

        // 文字主题
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
          bodyMedium: TextStyle(color: Color(0xFFBBBBBB)),
          titleLarge: TextStyle(color: Color(0xFFFFFFFF)),
        ),

        // 应用栏主题
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          elevation: 1,
        ),

        // 底部导航栏主题
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Color(0xFF888888),
        ),

        // 输入框主题
        inputDecorationTheme: InputDecorationTheme(
          fillColor: const Color(0xFF2D2D2D),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(color: Color(0xFFBBBBBB)),
        ),
      ),

      // 设置主题模式为跟随系统
      themeMode: ThemeMode.system,

      /// 初始路由
      initialRoute: AppPages.INITIAL,
      /// 所有的页面
      getPages: AppPages.routes,
    );
  }
}