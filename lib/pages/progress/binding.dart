import 'package:get/get.dart';

import 'logic.dart';

class ProgressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProgressLogic());
  }
}
