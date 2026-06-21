import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hlbmerge/generate/pigeon/flutter_native_api.g.dart';
import 'package:hlbmerge/log/log.dart';
import 'package:hlbmerge/ui/screen/main/file/view/widgets/output_file_dialog.dart';
import 'package:hlbmerge/utils/platform_util.dart';
import 'package:hlbmerge/utils/toast_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../repository/settings_repository.dart';
import '../../../../../utils/file_util.dart';
import '../model/file_state.dart';

part 'file_provider.g.dart';

@riverpod
class FileNotifier extends _$FileNotifier {
  @override
  FutureOr<FileState> build() async {
    final outputFileList = await loadOutputFileList();
    return FileState(outputFileList: outputFileList);
  }

  //刷新
  Future<void> refresh() async {
    final outputFileList = await loadOutputFileList();
    state = AsyncData(
      state.requireValue.copyWith(outputFileList: outputFileList),
    );
    ToastUtil.show("刷新完成");
  }

  Future<List<FileSystemEntity>> loadOutputFileList() async {
    final outputDirPath = await SettingsRepository.getOutputDirPath();
    if (outputDirPath == null || outputDirPath.isEmpty) {
      return [];
    }

    final targetDir = Directory(outputDirPath);
    if (!targetDir.existsSync()) {
      return [];
    }

    final fileList = targetDir.listSync();
    //过滤出文件夹和后缀为.mp4的文件
    final outputFileList = fileList.where((it) {
      return FileUtil.isDir(it.path) ||
          it.path.endsWith(".mp4") ||
          it.path.endsWith(".mp3");
    }).toList();

    runPlatform(
      orElse: () {},
      onAndroid: () {
        //通知系统文件导出完成
        NativeApis().notifyExportComplete();
      },
    );

    return outputFileList;
  }

  void openFile(BuildContext context, FileSystemEntity file) async {
    final isDir = FileUtil.isDir(file.path);
    if (isDir) {
      //显示弹窗
      showOutputFileDialog(context, file);
      return;
    }

    final uri = Uri.file(file.path);

    final cancelToast = ToastUtil.showLoading("正在打开...");

    try {
      if (!await launchUrl(uri)) {
        ToastUtil.warning("无法打开,请在路径中手动打开");
      }
    } catch (e) {
      Log.e("无法打开", e);
      ToastUtil.warning("无法打开,请在路径中手动打开");
    } finally {
      cancelToast();
    }
  }
}
