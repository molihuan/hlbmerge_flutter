import 'package:get/get.dart';



class MainState {
  MainState() {
    ///Initialize variables
  }

  // 页面索引
  final _currPageIndex = 0.obs;
  set currPageIndex(value) => _currPageIndex.value = value;
  get currPageIndex => _currPageIndex.value;


}
