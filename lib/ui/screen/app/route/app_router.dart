import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../about/about_screen.dart';
import '../../main/file/view/file_screen.dart';
import '../../main/home/view/home_screen.dart';
import '../../main/index/main_screen.dart';
import '../../main/preset/view/preset_screen.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.initRoute,
    debugLogDiagnostics: kDebugMode,
    observers: [BotToastNavigatorObserver()],
    routes: [
      /// 主页
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          /// 首页
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => HomeScreen(),
              ),
            ],
          ),

          /// 文件
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.file,
                builder: (context, state) => FileScreen(),
              ),
            ],
          ),

          /// 预设
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.preset,
                builder: (context, state) => PresetScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.about,
        builder: (context, state) => AboutScreen(),
      ),
    ],
  );
}
