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
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
