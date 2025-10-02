import 'package:get/get.dart';

import 'about_logic.dart';

class AboutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AboutLogic());
  }
}
