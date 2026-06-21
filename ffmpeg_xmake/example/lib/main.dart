import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider/main_notifier.dart';
void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  final smallPadding = const SizedBox(width: 10, height: 10);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听状态变化
    final uiState = ref.watch(mainNotifierProvider);
    // 获取 Notifier 发送动作
    final intent = ref.read(mainNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Native')),
      body: Center(
        child: Column(
          children: [
            // Text('sum(1, 2) = ${ffmpeg_hl.sum(1, 2)}'),
            smallPadding,
            ElevatedButton(
              onPressed: () {
                intent.getFfmpegVersion(context);
              },
              child: const Text("获取ffmpeg版本"),
            ),
            smallPadding,
            ElevatedButton(
              onPressed: () {
                intent.pickVideoFile();
              },
              child: const Text("选择视频"),
            ),
            smallPadding,
            ElevatedButton(
              onPressed: () {
                intent.pickAudioFile();
              },
              child: const Text("选择音频"),
            ),
            smallPadding,
            ElevatedButton(
              onPressed: () {
                intent.merge(context);
              },
              child: const Text("合并音视频"),
            ),
            smallPadding,
            ElevatedButton(
              onPressed: () {
                intent.pickVideoFiles();
              },
              child: const Text("选择多个视频"),
            ),
            smallPadding,
            ElevatedButton(
              onPressed: () {
                intent.mergeVideos(context);
              },
              child: const Text("合并多个视频"),
            ),
            smallPadding,
            ElevatedButton(
              onPressed: () {
                intent.shareFile();
              },
              child: const Text("分享文件"),
            ),
            smallPadding,
            ElevatedButton(
              onPressed: () {
                intent.openFolder();
              },
              child: const Text("完成目录"),
            ),
          ],
        ),
      ),
    );
  }
}
