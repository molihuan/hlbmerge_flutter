import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final MainLogic logic = Get.put(MainLogic());
  final MainState state = Get.find<MainLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: SafeArea(
        child: logic.getCurrPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.currPageIndex,
        onTap: logic.changePage,
        // 使用主题颜色
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: '进度'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
        ],
      ),
    ));
  }
}