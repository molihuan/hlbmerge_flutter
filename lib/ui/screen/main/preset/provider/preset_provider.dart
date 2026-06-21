import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hlbmerge/features/update/model/app_info.dart';
import 'package:hlbmerge/log/log.dart';
import 'package:hlbmerge/utils/platform_util.dart';
import 'package:hlbmerge/utils/toast_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../generate/gen/assets.gen.dart';
import '../../../../../generate/pigeon/flutter_native_api.g.dart';
import '../../../../../repository/settings_repository.dart';
import '../../../../../utils/app_util.dart';
import '../../../../../utils/str_util.dart';
import '../model/preset_state.dart';
import 'package:http/http.dart' as http;

part 'preset_provider.g.dart';

const openSourceUrl = 'https://github.com/molihuan/hlbmerge_flutter';
const tutorialUrl = '${openSourceUrl}/blob/master/res/tutorial/README.md';

@riverpod
class PresetNotifier extends _$PresetNotifier {
  final List<String> _appInfoUrls = [
    "https://raw.githubusercontent.com/molihuan/hlbmerge_flutter/master/res/appInfo/AppInfo.json",
    "https://raw.gitcode.com/bigmolihuan/hlbmerge_flutter/raw/master/res/appInfo/AppInfo.json",
    "https://gitee.com/molihuan/hlbmerge_flutter/raw/master/res/appInfo/AppInfo.json",
  ];

  @override
  FutureOr<PresetState> build() async {
    final outputDirPath = await SettingsRepository.getOutputDirPath();
    final bean = PresetState(outputDirPath: outputDirPath);
    return bean;
  }

  void goPathSelectScreen() {
    final nativeApis = NativeApis();
    // TODO: 跳转
    nativeApis.goNativePage("", null);
  }

  void pickInputCacheDirPath() async {
    String? dirPath = await FilePicker.platform.getDirectoryPath();
    Log.e("dirPath: $dirPath");
    if (dirPath == null) {
      ToastUtil.warning("您未选择路径");
      return;
    }

    //判断路径中是否有空格
    if (StrUtil.containsAnySpace(dirPath)) {
      ToastUtil.warning("路径中不能包含空格,请重新选择");
      return;
    }
    SettingsRepository.setInputCacheDirPath(dirPath);
  }

  void selectOutputPath() async {
    String? dirPath = await FilePicker.platform.getDirectoryPath();

    if (dirPath == null) {
      ToastUtil.warning("您未选择路径");
      return;
    }

    Log.d(dirPath);
    //判断路径中是否有空格
    if (StrUtil.containsAnySpace(dirPath)) {
      ToastUtil.error("路径中不能包含空格,请重新选择");
      return;
    }
    state = AsyncValue.data(
      state.requireValue.copyWith(outputDirPath: dirPath),
    );
    //持久化
    SettingsRepository.setOutputDirPath(dirPath);
    ToastUtil.success("已选择输出路径:$dirPath");
  }

  //获取远程app数据
  Future<AppInfo?> loadRemoteAppInfo({
    Duration timeout = const Duration(seconds: 4),
  }) async {
    for (final String url in _appInfoUrls) {
      try {
        // 带超时限制发起GET请求
        final response = await http.get(Uri.parse(url)).timeout(timeout);

        // 请求成功且状态码200，解析JSON并返回
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonData = jsonDecode(response.body);
          return AppInfo.fromJson(jsonData);
        }
        // 状态码非200（404/500等），进入下一轮循环请求下一个地址
        Log.w("地址 $url 请求异常，状态码：${response.statusCode}");
      } on TimeoutException {
        Log.e("地址 $url 请求超时，切换备用源");
      } catch (e) {
        // 网络错误、域名无法访问、跨域等所有异常捕获
        Log.e("地址 $url 请求失败，异常：$e");
      }
    }
    // 三个地址全部请求失败
    return null;
  }

  //检查更新
  Future<void> checkUpdate(PackageInfo localInfo) async {
    final cancelToast = ToastUtil.showLoading("正在检查更新...");
    final remoteAppInfo = await loadRemoteAppInfo();
    cancelToast();
    if (remoteAppInfo == null) {
      ToastUtil.error("获取数据失败,请前往开源地址查看更新详情");
      return;
    }

    Log.e(remoteAppInfo);

    // 根据平台获取对应的更新数据
    AppUpdateData? appUpdateDate;
    for (var item in remoteAppInfo.updateData) {
      appUpdateDate = runPlatform<AppUpdateData?>(
        orElse: () {
          return null;
        },
        onAndroid: () {
          if (item.platform == "android") {
            return item;
          }
          return null;
        },
        onWindows: () {
          if (item.platform == "windows") {
            return item;
          }
          return null;
        },
        onLinux: () {
          if (item.platform == "linux") {
            return item;
          }
          return null;
        },
        onOhos: () {
          if (item.platform == "ohos") {
            return item;
          }
          return null;
        },
        onMacOS: () {
          if (item.platform == "mac") {
            return item;
          }
          return null;
        },
      );

      if (appUpdateDate != null) {
        break;
      }
    }

    if (appUpdateDate == null) {
      ToastUtil.error("未找到更新数据,请前往开源地址查看更新详情");
      return;
    }

    //解析本地版本code
    int localVersionCode = int.tryParse(localInfo.buildNumber) ?? 0;
    // int localVersionCode = 1;

    if (appUpdateDate.enableUpdateCheck == true &&
        (localVersionCode < appUpdateDate.versionCode)) {
      ToastUtil.showAlways(
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("有新版本: ${appUpdateDate.versionName}"),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {
                updateApp(appUpdateDate);
              },
              child: const Text("前往更新", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );
      return;
    }

    ToastUtil.success("当前版本为最新版本");
  }

  Future<void> updateApp(AppUpdateData? appUpdateDate) async {
    final downloadPageUrl = appUpdateDate?.downloadPageUrl;
    if (downloadPageUrl == null) {
      ToastUtil.error("无法跳转更新页面,请前往开源地址查看更新详情");
      return;
    }

    final openResult = await AppUtil.openUrl(downloadPageUrl);
    if (!openResult) {
      ToastUtil.error("无法跳转更新页面,请手动访问:$downloadPageUrl");
    }
  }

  void goTutorialUrlPage() {
    AppUtil.openUrl(tutorialUrl);
  }

  void goOpenSourceUrlPage() {
    AppUtil.openUrl(openSourceUrl);
  }

  void showAboutUsDialog(BuildContext context) async {
    final navigator = Navigator.of(context);
    PackageInfo info = await PackageInfo.fromPlatform();
    showAboutDialog(
      context: navigator.context,
      applicationName: info.appName,
      applicationVersion:
          "版本:${info.version}   versionCode:${info.buildNumber}",
      applicationIcon: Image.asset(
        Assets.icons.appLogo.path,
        width: 50,
        height: 50,
      ),
      children: [
        Consumer(
          builder: (context, ref, child) {
            return Column(
              children: [
                const Center(
                  child: Text(
                    "将B站缓存文件合并导出为MP4,支持Android、windows(10以上)、linux、mac、ios,支持B站Android客户端缓存,支持B站Windows客户端缓存",
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        goOpenSourceUrlPage();
                      },
                      child: const Text("开源地址"),
                    ),
                    TextButton(
                      onPressed: () {
                        checkUpdate(info);
                      },
                      child: const Text("检查更新"),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
