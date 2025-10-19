import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'about_logic.dart';
import 'about_state.dart';

class AboutPage extends StatelessWidget {
  AboutPage({Key? key}) : super(key: key);
  final AboutLogic logic = Get.put(AboutLogic());
  final AboutState state = Get.find<AboutLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于&教程'),
      ),
      body: Container(
        child: ListView(
          children: [
            _buildAppIntroduction(context),
            //软件版本
            Obx(() {
              return _buildAppVersionView();
            }),
            //开源地址跳转
            ListTile(
              title: const Text('开源地址'),
              subtitle: Text(logic.openSourceUrl),
              onTap: () {
                logic.goOpenSourceUrl();
              },
            ),
            ListTile(
              title: const Text('使用教程'),
              onTap: () {
                logic.goTutorialUrl();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppIntroduction(BuildContext context) {
    final widget = Column(
      children: [
        //app ico
        Image.asset(
          "assets/icons/app_logo.png",
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        //app name
        Container(margin: const EdgeInsets.symmetric(vertical: 10),child: const Text("HLB站缓存合并", style: TextStyle(fontSize: 20)),),
        //app介绍
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          child: const Text(
            "将B站缓存文件合并导出为MP4,支持Android、windows(10以上)、linux、mac、ios,支持B站Android客户端缓存,支持B站Windows客户端缓存",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
    return widget;
  }

  Widget _buildAppVersionView() {
    final appUpdateData = state.appUpdateData;
    if (appUpdateData == null ||
        appUpdateData.enableUpdateCheck != true ||
        (logic.localVersionCode >= appUpdateData.versionCode)) {
      return ListTile(
        title: const Text('软件版本'),
        trailing: Text(state.appVersionName),
      );
    } else {
      return ListTile(
        title: const Text('软件版本'),
        onTap: () {
          logic.goAppUpdatePage();
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "有新版本",
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(state.appVersionName)
          ],
        ),
      );
    }
  }
}
