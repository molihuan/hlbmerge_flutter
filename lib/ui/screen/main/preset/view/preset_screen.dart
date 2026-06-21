import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../utils/platform_util.dart';
import '../provider/preset_provider.dart';
import '../provider/sync_preset_provider.dart';

class PresetScreen extends ConsumerWidget {
  const PresetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncUiState = ref.watch(syncPresetProvider);
    final syncIntent = ref.read(syncPresetProvider.notifier);
    final uiState = ref.watch(presetProvider);
    final intent = ref.read(presetProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("设置", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("开源地址 (点个赞)"),
            subtitle: const Text(openSourceUrl),
            onTap: () async {
              intent.goOpenSourceUrlPage();
            },
          ),
          ListTile(
            title: const Text("使用教程"),
            onTap: () async {
              intent.goTutorialUrlPage();
            },
          ),
          _buildInputCacheItem("缓存视频解析位置", () {
            intent.goPathSelectScreen();
          }),
          ListTile(
            title: const Text("导出路径"),
            subtitle: Text(uiState.value?.outputDirPath ?? "未设置"),
            onTap: () async {
              intent.selectOutputPath();
            },
          ),
          ListTile(
            title: const Text("导出到单一目录"),
            trailing: Switch(
              value: syncUiState.checkSingleOutputPath,
              onChanged: (v) {
                syncIntent.changeSingleOutputPathChecked(v);
              },
            ),
          ),
          ListTile(
            title: const Text("导出时添加序号"),
            trailing: Switch(
              value: syncUiState.checkExportAddIndex,
              onChanged: (v) {
                syncIntent.changeExportFileAddIndexChecked(v);
              },
            ),
          ),
          ListTile(
            title: const Text("导出时导出弹幕文件"),
            trailing: Switch(
              value: syncUiState.checkExportDanmakuFile,
              onChanged: (v) {
                syncIntent.changeExportDanmakuFileChecked(v);
              },
            ),
          ),
          ListTile(
            title: const Text("关于我们"),
            onTap: () async {
              intent.showAboutUsDialog(context);
            },
          ),
          ListTile(
            title: const Text("FFmpeg版本"),
            onTap: () async {
              syncIntent.showFfmpegVersion();
            },
          ),
        ],
      ),
    );
  }

  //输入缓存项设置
  Widget _buildInputCacheItem(String title, void Function() onTap) {
    return runPlatform<Widget>(
      orElse: () {
        return const SizedBox.shrink();
      },
      onAndroid: () {
        return ListTile(title: Text(title), onTap: onTap);
      },
    );
  }
}
