import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hlbmerge/ui/base/responsive/responsive_ext.dart';
import 'package:hlbmerge/ui/base/widgets/common_widget.dart';

import '../../../../../../features/export/cache_data_manager.dart';
import '../../../../../base/ext/common_ui_ext.dart';
import '../../provider/home_provider.dart';
import '../../provider/sync_home_provider.dart';
import 'cache_cover_image.dart';

void showCacheItemsDialog(BuildContext context, int cacheGroupIndex) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return CacheItemsDialog(cacheGroupIndex);
    },
  );
}

//缓存项列表弹窗
class CacheItemsDialog extends ConsumerStatefulWidget {
  const CacheItemsDialog(this.cacheGroupIndex, {super.key});

  final cacheGroupIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CacheItemsDialogState();
}

class _CacheItemsDialogState extends ConsumerState<CacheItemsDialog> {
  int get cacheGroupIndex => widget.cacheGroupIndex;

  late final HomeNotifier intent;

  @override
  void initState() {
    super.initState();
    intent = ref.read(homeProvider.notifier);
  }

  @override
  void dispose() {
    Future(() {
      intent.changeAllCacheItemListChecked(cacheGroupIndex, false);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final syncUiState = ref.watch(syncHomeProvider);
    final syncIntent = ref.read(syncHomeProvider.notifier);
    final uiState = ref.watch(homeProvider);

    final cacheGroup = uiState.requireValue.cacheGroupList[cacheGroupIndex];

    final cacheItemList = cacheGroup.cacheItemList;

    bool allChecked = cacheItemList.every((e) => e.checked);

    final outputFileMode = ref.watch(
      syncHomeProvider.select((it) => it.outputFileMode),
    );

    return Dialog(
      insetPadding: context.responsive.isMobile.when(EdgeInsets.zero, null),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 500,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 18),
            const Text(
              "请选择需要合并的缓存项",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: cacheItemList.length,
                itemExtent: 70,
                itemBuilder: (context, index) {
                  var item = cacheItemList[index];
                  return InkWell(
                    onTap: () {
                      intent.changeCacheItemListChecked(
                        cacheGroupIndex,
                        index,
                        !item.checked,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 封面图片
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 70,
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
                                // 选中
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.3),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Icon(
                                      item.checked.when(
                                        Icons.check_circle,
                                        Icons.radio_button_unchecked,
                                      ),
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //文字
                          Expanded(
                            child: Container(
                              height: 70,
                              margin: const EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 标题文本区域
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        item.title ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // 路径文本区域
                                  SizedBox(
                                    height: 20,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          const Text(
                                            "路径:",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SelectableText(
                                            item.path ?? "",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
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
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const Divider(thickness: 0.4),
            ),
            //选项
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //全选按钮
                InkWell(
                  onTap: () {
                    intent.changeAllCacheItemListChecked(
                      cacheGroupIndex,
                      !allChecked,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: allChecked.when(
                      const [Icon(Icons.check_box), Text("全选")],
                      const [Icon(Icons.check_box_outline_blank), Text("全选")],
                    ),
                  ),
                ),

                //单选按钮
                RadioGroup(
                  groupValue: outputFileMode,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    syncIntent.changeOutputFileMode(value);
                  },
                  child: Row(
                    children: [
                      InkWell(
                        child: Row(
                          children: [
                            Radio(value: OutputFileMode.audio),
                            Text("音频"),
                          ],
                        ),
                        onTap: () {
                          syncIntent.changeOutputFileMode(OutputFileMode.audio);
                        },
                      ),
                      InkWell(
                        child: Row(
                          children: [
                            Radio(value: OutputFileMode.all),
                            Text("视频"),
                          ],
                        ),
                        onTap: () {
                          syncIntent.changeOutputFileMode(OutputFileMode.all);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            context.responsive.isMobile.when(
              nullWidget,
              const SizedBox(height: 20),
            ),

            //按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton.icon(
                  onPressed: () {
                    intent.exportFileByCacheItem(
                      cacheItemList,
                      outputFileMode,
                      cacheGroup.title,
                    );
                  },
                  icon: const Icon(Icons.upload),
                  label: const Text("导出"),
                ),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text("取消"),
                ),
              ],
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
