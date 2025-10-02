import 'dart:io';

import 'package:get/get.dart';

class ProgressState {
  ProgressState() {
    ///Initialize variables
  }
  final _outputChildDirList = <Directory>[].obs;

  List<Directory> get outputChildDirList => _outputChildDirList.toList();
  set outputChildDirList(List<Directory> value) => _outputChildDirList.assignAll(value);
}
