import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hlbmerge/ui/base/responsive/responsive_widget.dart';

import 'provider/main_provider.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  final _bottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
    BottomNavigationBarItem(icon: Icon(Icons.file_open), label: '导出文件'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
  ];

  final _navDestinations = const [
    NavigationRailDestination(icon: Icon(Icons.home), label: Text('首页')),
    NavigationRailDestination(icon: Icon(Icons.file_open), label: Text('导出文件')),
    NavigationRailDestination(
      icon: Icon(Icons.settings),
      label: Text('设置'),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveWidget(
      mobile: _mobileLayout(context, ref),
      tablet: _desktopLayout(context, ref),
    );
  }

  Widget _mobileLayout(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) =>
            ref.read(mainProvider.notifier).changeIndex(navigationShell, i),
        items: _bottomNavItems,
      ),
    );
  }

  Widget _desktopLayout(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: isDark
                      ? Colors.white.withAlpha(25)
                      : Colors.black.withAlpha(25),
                  width: 1,
                ),
              ),
            ),
            child: NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (i) => ref
                  .read(mainProvider.notifier)
                  .changeIndex(navigationShell, i),
              labelType: NavigationRailLabelType.all,
              backgroundColor: Colors.transparent,
              minWidth: 80,
              destinations: _navDestinations,
            ),
          ),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
