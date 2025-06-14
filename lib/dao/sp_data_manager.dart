import 'package:shared_preferences/shared_preferences.dart';

class SpDataManager {
  static late SharedPreferences prefs;

  //输出目录key
  static const String outputPathKey = 'outputPath';

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  //输出目录
  static setOutputPath(String path) {
    prefs.setString(outputPathKey, path);
  }

  static String? getOutputPath() {
    return prefs.getString(outputPathKey);
  }
  //清空
  static clear() {
    prefs.clear();
  }
}
