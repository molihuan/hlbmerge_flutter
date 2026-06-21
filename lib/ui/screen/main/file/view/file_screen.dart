import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hlbmerge/utils/file_util.dart';

import '../provider/file_provider.dart';
import 'package:path/path.dart' as path;
import 'package:hlbmerge/ui/base/ext/common_ui_ext.dart';

class FileScreen extends ConsumerWidget {
  const FileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final uiState = ref.watch(fileProvider);
    final intent = ref.read(fileProvider.notifier);
    final outputFileList = ref.watch(
      fileProvider.select((it) => it.value?.outputFileList ?? []),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "导出文件",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          //刷新按钮
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              intent.refresh();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: outputFileList.length,
        itemBuilder: (context, index) {
          final item = outputFileList[index];
          return ListTile(
            onTap: () {
              intent.openFile(context,item);
            },
            leading: FileUtil.isDir(item.path).when(
              Icon(Icons.folder_open, size: 30),
              Icon(Icons.insert_drive_file, size: 30),
            ),
            title: Text(
              path.basename(item.path),
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 2,
            ),
            subtitle: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text(
                    "位置:",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SelectableText(
                    item.path,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
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
