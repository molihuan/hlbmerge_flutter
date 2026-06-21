import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../base/ext/common_ui_ext.dart';
import '../../provider/home_provider.dart';
import '../../provider/sync_home_provider.dart';

//搜索框
class SearchTextField extends ConsumerWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final syncUiState = ref.watch(syncHomeProvider);
    final syncIntent = ref.read(syncHomeProvider.notifier);
    // final uiState = ref.watch(homeProvider);
    final intent = ref.read(homeProvider.notifier);

    final searchValue = ref.watch(syncHomeProvider.select((it)=>it.searchValue));

    return Expanded(
      child: TextField(
        onChanged: (v) {
          syncIntent.changeSearchValue(v);
          // intent.searchCacheGroupList(v);
        },
        onSubmitted: (value) {
          intent.searchCacheGroupList(value);
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: '请输入搜索内容',
          enabledBorder: OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2), // 聚焦状态边框颜色
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 8,
          ),
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: () {
                intent.searchCacheGroupList(searchValue);
              }, icon: const Icon(Icons.search)),
            ],
          ),
        ),
      ),
    );
  }
}
