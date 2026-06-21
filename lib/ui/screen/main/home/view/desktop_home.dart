import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hlbmerge/ui/base/ext/common_ui_ext.dart';
import 'package:hlbmerge/ui/base/widgets/common_widget.dart';

import '../../../../../features/export/cache_data_manager.dart';
import '../provider/home_provider.dart';
import '../provider/sync_home_provider.dart';
import 'widgets/home_bottom_bar.dart';
import 'widgets/home_cache_group.dart';
import 'widgets/search_text_field.dart';

class DesktopHome extends ConsumerWidget {
  const DesktopHome({super.key});

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
    bool checkTextFieldDragging = ref.watch(
      syncHomeProvider.select((it) => it.checkTextFieldDragging),
    );
    final cachePlatform = ref.watch(
      syncHomeProvider.select((it) => it.cachePlatform),
    );

    String inputCacheDirPath = ref.watch(
      homeProvider.select((it) => it.value?.inputCacheDirPath ?? ""),
    );
    //菜单按钮
    final menuBtn = IconButton(
      icon: Icon(
        Icons.menu,
        color: checkMultiSelectMode ? Colors.red : Colors.black,
      ),
      onPressed: () {
        syncIntent.changeMultiSelectMode(!checkMultiSelectMode);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: checkSearch.when(
          nullWidget,
          const Text("首页", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        actions: checkSearch.when(
          [
            const SizedBox(width: 15),
            //搜索框
            const SearchTextField(),
            //关闭按钮
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                syncIntent.changeCheckSearch(false);
                intent.clearSearch();
              },
            ),
            menuBtn,
          ],
          [
            const SizedBox(width: 10),
            const Text("缓存类型:"),
            const SizedBox(width: 8),
            //缓存类型
            IntrinsicWidth(
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 0,
                  ),
                ),
                initialValue: cachePlatform,
                items: CachePlatform.values
                    .map(
                      (platform) => DropdownMenuItem<CachePlatform>(
                        value: platform,
                        alignment: AlignmentDirectional.center,
                        child: Text(platform.title),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  syncIntent.changeCachePlatform(v);
                },
              ),
            ),

            const SizedBox(width: 0),
            //输入缓存文件夹路径
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: DropTarget(
                  onDragDone: (detail) {
                    syncIntent.onInputCacheDirPathDragDone(detail.files);
                  },
                  onDragEntered: (detail) {
                    syncIntent.changeTextFieldDragging(true);
                  },
                  onDragExited: (detail) {
                    syncIntent.changeTextFieldDragging(false);
                  },
                  child: TextField(
                    controller: TextEditingController(text: inputCacheDirPath),
                    onChanged: (value) {
                      intent.changeInputCacheDirPath(value);
                    },
                    decoration: InputDecoration(
                      labelText: '如果加载数据失败请查看设置中的教程',
                      border: const OutlineInputBorder(),
                      hintText: '请输入缓存文件夹路径(支持拖拽)',
                      enabledBorder: OutlineInputBorder(
                        borderSide: checkTextFieldDragging
                            ? const BorderSide(color: Colors.blue, width: 2)
                            : const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ), // 聚焦状态边框颜色
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              intent.pickInputCacheDirPath();
                            },
                            child: const Text("选择"),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

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
            menuBtn,
          ],
        ),
      ),
      body: Column(
        children: [
          //操作
          checkMultiSelectMode.when(HomeBottomBar(), nullWidget),
          //body
          HomeCacheGroup(),
        ],
      ),
    );
  }
}
