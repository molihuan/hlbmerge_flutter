import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final SettingsLogic logic = Get.put(SettingsLogic());
  final SettingsState state = Get.find<SettingsLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ListTile(
            title: const Text("测试按钮"),
            onTap: () async {
                logic.mergeAudioVideo();
            },
          ),
          ListTile(
            title: const Text("Avcodec配置"),
            onTap: () async {
              String? avcodecCfg = await logic.getAvcodecCfg();
              Get.snackbar("Avcodec配置", avcodecCfg ?? "获取失败");
            },
          ),
          Obx(() {
            return ListTile(
              title: Text("输出路径:${state.outputPath}"),
              onTap: () async {
                logic.selectOutputPath();
              },
            );
          }),
        ],
      ),
    );
  }
}
