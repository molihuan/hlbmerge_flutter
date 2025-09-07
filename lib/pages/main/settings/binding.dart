import 'package:get/get.dart';

import 'logic.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsLogic());
  }
}
