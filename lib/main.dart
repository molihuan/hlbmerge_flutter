import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hlbmerge/utils/platform_util.dart';
import 'package:nativeapi/nativeapi.dart';

import 'features/export/merge/ffmpeg_server.dart';
import 'log/provider_logger.dart';
import 'repository/app_repository.dart';
import 'ui/screen/app/app_screen.dart';

void main() async {
  await _init();
  // Provider 监听
  final List<ProviderObserver> providerObservers = [];
  if (kDebugMode) {
    providerObservers.add(ProviderLogger());
  }

  runApp(ProviderScope(observers: providerObservers, child: const AppScreen()));
}

// 初始化
_init() async {
  WidgetsFlutterBinding.ensureInitialized();

  await runPlatformGroupAsync(
    onDesktop: () {
      // 窗口居中
      final windowManager = WindowManager.instance;
      final window = windowManager.getCurrent();
      window?.show();
      window?.center();
    },
    orElse: () {},
  );

  // 初始化仓库
  await AppRepository.init();
  // 初始化 FFmpeg
  await FFmpegServer.init();
}
