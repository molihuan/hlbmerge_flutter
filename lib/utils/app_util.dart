import 'dart:io';

import 'package:path/path.dart' as p;

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtil {
  AppUtil._();

  // 浏览器打开
  static Future<bool> openUrl(
    String url, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: mode);
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
