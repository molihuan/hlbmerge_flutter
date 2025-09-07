import 'package:get/get.dart';
import 'package:hlbmerge/dao/sp_data_manager.dart';

class SettingsState {
  SettingsState() {
    ///Initialize variables
    var outPath = SpDataManager.getOutputPath() ?? "";
    outputPath = outPath;
  }

  //输出路径
  final _outputPath = ''.obs;

  set outputPath(value) => _outputPath.value = value;

  get outputPath => _outputPath.value;
}
