import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hlbmerge/ui/base/ext/common_ui_ext.dart';
import 'package:hlbmerge/ui/base/widgets/common_widget.dart';

import '../provider/home_provider.dart';
import '../provider/sync_home_provider.dart';
import 'widgets/home_bottom_bar.dart';
import 'widgets/home_cache_group.dart';
import 'widgets/search_text_field.dart';

class MobileHome extends ConsumerWidget {
  const MobileHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final syncUiState = ref.watch(syncHomeProvider);
    final syncIntent = ref.read(syncHomeProvider.notifier);
    // final uiState = ref.watch(homeProvider);
    final intent = ref.read(homeProvider.notifier);

    bool checkSearch = ref.watch(
      syncHomeProvider.select((it) => it.checkSearch),
    );
    bool checkMultiSelectMode = ref.watch(
      syncHomeProvider.select((it) => it.checkMultiSelectMode),
    );

    return PopScope(
      canPop: !checkMultiSelectMode,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        syncIntent.changeMultiSelectMode(false);
        intent.changeAllGroupListChecked(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: checkSearch.when(
            nullWidget,
            const Text("首页", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          actions: checkSearch.when(
            [
              const SizedBox(width: 15),
              //搜索框
              SearchTextField(),
              //关闭按钮
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  syncIntent.changeCheckSearch(false);
                  intent.clearSearch();
                },
              ),
            ],
            [
              //搜索按钮
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  syncIntent.changeCheckSearch(true);
                },
              ),
              //刷新按钮
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  intent.refreshCacheData();
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            //body
            HomeCacheGroup(),
            //底部
            checkMultiSelectMode.when(HomeBottomBar(), nullWidget),
          ],
        ),
      ),
    );
  }
}
