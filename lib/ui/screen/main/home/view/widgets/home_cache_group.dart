import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hlbmerge/ui/base/ext/common_ui_ext.dart';

import '../../../../../../features/export/merge/model/cache_group.dart';
import '../../../../../base/widgets/common_widget.dart';
import '../../provider/home_provider.dart';
import '../../provider/sync_home_provider.dart';
import 'cache_cover_image.dart';
import 'cache_items_dialog.dart';

class HomeCacheGroup extends ConsumerWidget {
  const HomeCacheGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final syncUiState = ref.watch(syncHomeProvider);
    final syncIntent = ref.read(syncHomeProvider.notifier);
    // final uiState = ref.watch(homeProvider);
    final intent = ref.read(homeProvider.notifier);

    List<CacheGroup> cacheGroupList = ref.watch(
      homeProvider.select((it) => it.value?.cacheGroupList ?? []),
    );

    bool hasPermission = ref.watch(
      homeProvider.select((it) => it.value?.hasPermission ?? false),
    );

    bool checkMultiSelectMode = ref.watch(
      syncHomeProvider.select((it) => it.checkMultiSelectMode),
    );

    if (!hasPermission) {
      return Expanded(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              intent.grantReadWritePermission();
            },
            child: const Text("授权"),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: cacheGroupList.length,
        itemBuilder: (context, index) {
          var item = cacheGroupList[index];

          return InkWell(
            onTap: () {
              if (checkMultiSelectMode) {
                intent.changeGroupListChecked(item, !item.checked);
              } else {
                showCacheItemsDialog(context, index);
              }
            },
            onLongPress: () {
              syncIntent.changeMultiSelectMode(!checkMultiSelectMode);

              if (checkMultiSelectMode) {
                intent.changeAllGroupListChecked(false);
              }else{
                intent.changeGroupListChecked(item, true);
              }

            },
            child: Container(
              height: 85,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 图片部分
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 85,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: buildCacheCoverImage(
                                    item.coverPath,
                                    item.coverUrl,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),

                        ...checkMultiSelectMode.when(
                          [
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withValues(alpha: 0.4),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Icon(
                                  item.checked.when(
                                    Icons.check_circle,
                                    Icons.radio_button_unchecked,
                                  ),
                                  size: 38,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                          [nullWidget],
                        ),
                      ],
                    ),
                  ),
                  // 文字信息部分
                  Expanded(
                    child: Container(
                      height: 85,
                      margin: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.title ?? "无标题",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 85 * 0.3,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  const Text(
                                    "路径:",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SelectableText(
                                    '${item.path}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
