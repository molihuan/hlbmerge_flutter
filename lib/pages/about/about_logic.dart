import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/GetxHttpUtils.dart';
import 'about_state.dart';

class AboutLogic extends GetxController {
  final AboutState state = AboutState();
  final openSourceUrl = 'https://github.com/molihuan/hlbmerge_flutter';
  final tutorialUrl = 'https://github.com/molihuan/hlbmerge_flutter/blob/master/res/tutorial';

  final appInfoGiteeUrl = "https://gitee.com/molihuan/hlbmerge_flutter/raw/master/res/appInfo/AppInfo.json";
  final appInfoGithubUrl = "https://raw.githubusercontent.com/molihuan/hlbmerge_flutter/master/res/appInfo/AppInfo.json";

  late final httpUtils = GetxHttpUtils();

  //跳转开源地址
  Future<void> goOpenSourceUrl() async {
    goUrl(openSourceUrl);
  }

  void goTutorialUrl() {
    goUrl(tutorialUrl);
  }

  goUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      Get.snackbar("提示", "无法跳转,请手动访问:$url");
    }
  }

  Future<void> init() async {
    //获取安装包版本
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    state.appVersionName = version;
    // 网络appInfo
    final res = await httpUtils.getRequest(appInfoGiteeUrl);
    if (res.isOk) {
      print(res.body);
    } else {
      Get.snackbar("错误", res.statusText ?? "未知错误");
    }

  }
  @override
  void onReady() {
    // TODO: implement onReady
    init();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
