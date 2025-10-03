import 'dart:io';

import 'package:get/get.dart';

class ProgressState {
  ProgressState() {
    ///Initialize variables
  }
  final _outputChildFileList = <FileSystemEntity>[].obs;

  List<FileSystemEntity> get outputChildFileList => _outputChildFileList.toList();
  set outputChildFileList(List<FileSystemEntity> value) => _outputChildFileList.assignAll(value);
}
