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
  static const String outputPathKey = 'outputPath';


  //输出目录
  static setOutputPath(String path) {
    prefs.setString(outputPathKey, path);
  }

  static String? getOutputPath() {
    return prefs.getString(outputPathKey);
  }

}
