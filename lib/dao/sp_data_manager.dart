import 'package:shared_preferences/shared_preferences.dart';

class SpDataManager {
  static late SharedPreferences prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  //清空
  static clear() {
    prefs.clear();
  }

  //输出目录key
  static const String outputDirPathKey = 'outputDirPathKey';


  //输出目录
  static setOutputDirPath(String path) {
    prefs.setString(outputDirPathKey, path);
  }

  static String? getOutputDirPath() {
    return prefs.getString(outputDirPathKey);
  }

}
