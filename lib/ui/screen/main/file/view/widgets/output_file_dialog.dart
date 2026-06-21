import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hlbmerge/ui/base/ext/common_ui_ext.dart';

import '../../../../../../utils/file_util.dart';
import '../../provider/file_provider.dart';
import 'package:path/path.dart' as path;

void showOutputFileDialog(BuildContext context, FileSystemEntity file) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return OutputFileDialog(file);
    },
  );
}

class OutputFileDialog extends ConsumerWidget {
  OutputFileDialog(this.file, {super.key});

  final FileSystemEntity file;
  late final outputFileList = Directory(file.path).listSync();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intent = ref.read(fileProvider.notifier);

    return Dialog(
      child: Container(
        height: 500,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: outputFileList.length,
                itemBuilder: (context, index) {
                  final item = outputFileList[index];
                  return ListTile(
                    onTap: () {
                      intent.openFile(context, item);
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
                    // subtitle: SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //       const Text(
                    //         "位置:",
                    //         style: TextStyle(color: Colors.grey, fontSize: 12),
                    //       ),
                    //       SelectableText(
                    //         item.path,
                    //         style: TextStyle(color: Colors.grey, fontSize: 12),
                    //         maxLines: 1,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  );
                },
              ),
            ),
            // 关闭按钮
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
