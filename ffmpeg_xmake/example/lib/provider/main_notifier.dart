import 'dart:io';

import 'package:ffmpeg_hl/ffmpeg_hl.dart';
import 'package:file_picker_ohos/file_picker_ohos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../model/main_state.dart';
import '../utils/file_util.dart';
import '../utils/platform_util.dart';

final mainNotifierProvider = NotifierProvider<MainNotifier, MainState>(
  MainNotifier.new,
);

class MainNotifier extends Notifier<MainState> {
  @override
  MainState build() {
    return MainState();
  }
  final ffmpeg_hl = ffmpegInterface;

  void getFfmpegVersion(BuildContext context) async {
    await ffmpeg_hl.init();
    final version = ffmpeg_hl.ffmpegVersion();
    print('ffmpeg version: $version');
    context.showToast(version ?? "err");
  }

  // 合并
  Future<void> merge(BuildContext context) async {
    await ffmpeg_hl.init();
    final inputAudio = state.inputAudio;
    final inputVideo = state.inputVideo;
    if (inputAudio == null || inputVideo == null) {
      context.showToast("请选择视频和音频文件");
      return;
    }

    String outputPath;
    if(kIsWeb){
      outputPath = "output.mp4";
    }else{
      outputPath = await _getOutputFilePath();
    }

    print("Video: $inputVideo");
    print("Audio: $inputAudio");
    print("Output: $outputPath");
    try {
      final result = await ffmpeg_hl.mergeAudioVideo(
        inputVideo,
        inputAudio,
        outputPath,
      );

      if (result == null) {
        context.showToast("合并成功");
        state = state.copyWith(outputFile: outputPath);
        return;
      }

      context.showToast("失败");
      print("执行合并结果: $result");
    } catch (e) {
      print(e);
    }
  }

  ///合并多个视频
  void mergeVideos(BuildContext context) async {
    final inputVideos = state.inputVideos;
    if (inputVideos.isEmpty) {
      context.showToast("请选择视频文件");
      return;
    }

    final outputPath = await _getOutputFilePath();
    //打印输入文件
    for (var item in inputVideos) {
      print("Video: $item");
    }
    print("Output: $outputPath");

    try {
      final result = await ffmpeg_hl.mergeVideos(inputVideos, outputPath);

      if (result == null) {
        context.showToast("合并成功");
        state = state.copyWith(outputFile: outputPath);
        return;
      }

      context.showToast("失败");
      print("执行合并结果: $result");
    } catch (e) {
      print(e);
    }
  }

  //获取输出文件
  Future<String> _getOutputFilePath() async {
    final outputDirPath = await getOutputDirPath();
    final outputDir = Directory(outputDirPath);
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    final outputPath = p.join(
      outputDirPath,
      "${DateTime.now().millisecondsSinceEpoch}.mp4",
    );
    return outputPath;
  }

  //选择视频文件
  Future<void> pickVideoFile() async {
    final filePaths = await _pickInputFile();

    final first = filePaths?.first;
    if (first == null) {
      return;
    }
    print(first);
    state = state.copyWith(inputVideo: first);
  }

  //选择视频文件
  Future<void> pickVideoFiles() async {
    final filePaths = await _pickInputFile();

    if (filePaths == null) {
      return;
    }
    state = state.copyWith(inputVideos: filePaths.nonNulls.toList());
  }

  //选择音频文件
  Future<void> pickAudioFile() async {
    final filePaths = await _pickInputFile();

    final first = filePaths?.first;

    if (first == null) {
      return;
    }
    print(first);
    state = state.copyWith(inputAudio: first);
  }

  //选择文件
  Future<List<String?>?> _pickInputFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      allowMultiple: true,
      type: FileType.any,
    );
    if (result == null) {
      return null;
    }

    final paths = result.files.map((item){
      return item.xFile.path;
    }).toList();

    return paths;
  }

  Future<void> openFolder() async {
    final dir = await getOutputDirPath();
    FileUtil.openFolder(dir);
  }

  // 获取弹幕输出目录
  Future<String> getOutputDirPath() async {
    final OUTPUT_DIR_NAME = "output";
    final cacheDanmakuOutputDirPath = await runPlatformAsync<String>(
      onWindows: () {
        final exePath = Platform.resolvedExecutable;
        final dir = p.dirname(exePath);
        return p.join(dir, OUTPUT_DIR_NAME);
      },
      onLinux: () {
        final exePath = Platform.resolvedExecutable;
        final dir = p.dirname(exePath);
        return p.join(dir, OUTPUT_DIR_NAME);
      },
      orElse: () async {
        final appDocDir = await getApplicationDocumentsDirectory();
        return p.join(appDocDir.path, OUTPUT_DIR_NAME);
      },
    );
    return cacheDanmakuOutputDirPath;
  }

  Future<void> shareFile() async {
    final path = state.outputFile;
    if (path == null) {
      return;
    }
    FileUtil.openFolder(path);
  }
}

extension ContextExt on BuildContext {
  void showToast(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        // 使其悬浮，更接近Toast
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

typedef PickFileCallback = void Function(List<String?>? paths);
