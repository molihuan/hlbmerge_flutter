import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/main_state.dart';

part 'main_provider.g.dart';

@riverpod
class MainNotifier extends _$MainNotifier {
  @override
  MainState build() => const MainState();

  void changeIndex(StatefulNavigationShell navigationShell, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
