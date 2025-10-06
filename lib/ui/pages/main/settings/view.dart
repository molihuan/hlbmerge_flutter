import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hlbmerge/utils/PlatformUtils.dart';

import 'logic.dart';
import 'state.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final SettingsLogic logic = Get.put(SettingsLogic());
  final SettingsState state = Get.find<SettingsLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AppBar(title: const Text("设置",style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: ListView(
            children: [
              ListTile(
                title: const Text("Avcodec配置"),
                onTap: () async {
                  logic.showAvcodecCfg();
                },
              ),
              _buildInputCacheItem("输入缓存项"),
              Obx(() {
                return ListTile(
                  title: Text("输出路径:${state.outputDirPath}"),
                  onTap: () async {
                    logic.selectOutputPath();
                  },
                );
              }),
              //输出单一目录
              Obx((){
                return ListTile(
                  title: const Text("导出到单一目录"),
                  trailing: Switch(value: state.singleOutputPathChecked,onChanged: (v) {
                    logic.changeSingleOutputPathChecked(v);
                  },),
                );
              }),
              //导出时添加序号
              Obx((){
                return ListTile(
                  title: const Text("导出时添加序号"),
                  trailing: Switch(value: state.exportFileAddIndex,onChanged: (v) {
                    logic.changeExportFileAddIndexChecked(v);
                  },),
                );
              }),
              //导出时导出弹幕文件
              Obx((){
                return ListTile(
                  title: const Text("导出时导出弹幕文件"),
                  trailing: Switch(value: state.exportDanmakuFileChecked,onChanged: (v) {
                    logic.changeExportDanmakuFileChecked(v);
                  },),
                );
              }),
              ListTile(
                title: const Text("测试按钮"),
                onTap: () async {
                  logic.testFunc();
                },
              ),
              ListTile(
                title: const Text("关于&教程"),
                onTap: () async {
                  logic.goAboutPage();
                },
              ),
            ],
          ))
        ],
      ),
    );
  }

  //输入缓存项设置
  Widget _buildInputCacheItem(String title) {
    return runPlatformFunc<Widget>(onDefault: () {
      return const SizedBox.shrink();
    }, onAndroid: () {
      return ListTile(
        title: Text(title),
        onTap: () {
          logic.startPathSelectScreen();
        },
      );
    });
  }
}
