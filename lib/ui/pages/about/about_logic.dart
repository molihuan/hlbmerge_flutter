import 'package:get/get.dart';
import 'package:hlbmerge/utils/PlatformUtils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../dao/app_info.dart';
import '../../../utils/GetxHttpUtils.dart';
import 'about_state.dart';

class AboutLogic extends GetxController {
  final AboutState state = AboutState();
  final openSourceUrl = 'https://github.com/molihuan/hlbmerge_flutter';
  final tutorialUrl =
      'https://github.com/molihuan/hlbmerge_flutter/blob/master/res/tutorial';

  final appInfoGiteeUrl =
      "https://gitee.com/molihuan/hlbmerge_flutter/raw/master/res/appInfo/AppInfo.json";
  final appInfoGitcodeUrl =
      "https://raw.gitcode.com/bigmolihuan/hlbmerge_flutter/raw/master/res/appInfo/AppInfo.json";
  final appInfoGithubUrl =
      "https://raw.githubusercontent.com/molihuan/hlbmerge_flutter/master/res/appInfo/AppInfo.json";

  late final httpUtils = GetxHttpUtils();

  int localVersionCode = 0;

  //跳转开源地址
  Future<void> goOpenSourceUrl() async {
    goUrl(openSourceUrl);
  }

  void goTutorialUrl() {
    goUrl(tutorialUrl);
  }

  void goAppUpdatePage() {
    final downloadPageUrl = state.appUpdateData?.downloadPageUrl;
    if (downloadPageUrl == null) {
      Get.snackbar("提示", "无法跳转更新页面,请前往开源地址查看更新详情");
      return;
    }
    goUrl(downloadPageUrl);
  }

  goUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      Get.snackbar("提示", "无法跳转,请手动访问:$url");
    }
  }

  Future<void> loadLocalAppInfo() async {
    //本地appInfo
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    state.appVersionName = version;
    final buildNumber = packageInfo.buildNumber;
    //将appVersionCode转换为数字,如果无法转换就默认为0
    localVersionCode = int.tryParse(buildNumber) ?? 0;
  }

  //获取网络app数据
  Future<void> loadRemoteAppInfo() async {
    // 网络appInfo
    final res = await httpUtils.getRequest(appInfoGitcodeUrl);
    final appInfoBody = res.body;
    //print("获取appInfo结果:"+appInfoBody);
    if (res.isOk && appInfoBody != null) {

      try {
        AppInfo? appInfo;
        if(appInfoBody is Map<String, dynamic>){
          appInfo = AppInfo.fromJson(appInfoBody);
        }else if(appInfoBody is String){
          appInfo = AppInfo.fromJsonString(appInfoBody);
        }
        print("appInfo: $appInfo");
        if(appInfo == null){
          return;
        }

        AppUpdateData? appUpdateDate;
        for (var item in appInfo.updateData) {
          appUpdateDate = runPlatformFunc<AppUpdateData?>(onDefault: () {
            return null;
          }, onAndroid: () {
            if (item.platform == "android") {
              return item;
            }
            return null;
          }, onWindows: () {
            if (item.platform == "windows") {
              return item;
            }
            return null;
          }, onLinux: () {
            if (item.platform == "linux") {
              return item;
            }
            return null;
          }, onOhos: () {
            if (item.platform == "ohos") {
              return item;
            }
            return null;
          },onMacOS: () {
            if (item.platform == "mac") {
              return item;
            }
            return null;
          });

          if (appUpdateDate != null) {
            state.appUpdateData = appUpdateDate;
            break;
          }
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("请求appInfo失败:${res.statusText}");
    }
  }

  Future<void> init() async {
    await loadLocalAppInfo();
    loadRemoteAppInfo();
  }

  @override
  void onReady() {
    init();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
