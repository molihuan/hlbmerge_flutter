import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hlbmerge/ui/base/responsive/responsive_ext.dart';
import 'package:hlbmerge/ui/base/widgets/common_widget.dart';

import '../../../../../../features/export/cache_data_manager.dart';
import '../../../../../../features/export/merge/model/cache_group.dart';
import '../../../../../base/ext/common_ui_ext.dart';
import '../../provider/home_provider.dart';
import '../../provider/sync_home_provider.dart';

class HomeBottomBar extends ConsumerWidget {
  const HomeBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final syncUiState = ref.watch(syncHomeProvider);
    final syncIntent = ref.read(syncHomeProvider.notifier);
    // final uiState = ref.watch(homeProvider);
    final intent = ref.read(homeProvider.notifier);

    List<CacheGroup> cacheGroupList = ref.watch(
      homeProvider.select((it) => it.value?.cacheGroupList ?? []),
    );

    final outputFileMode = ref.watch(
      syncHomeProvider.select((it) => it.outputFileMode),
    );
    //是否全选
    bool allChecked = cacheGroupList.every((e) => e.checked);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            intent.changeAllGroupListChecked(!allChecked);
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
              context.responsive.isMobile.when(nullWidget, const SizedBox(width: 15)),
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

        TextButton.icon(
          onPressed: () {
            intent.exportFileByCacheGroup(cacheGroupList,outputFileMode);
          },
          icon: const Icon(Icons.file_upload, size: 28),
          label: const Text("导出"),
        ),
      ],
    );
  }
}
