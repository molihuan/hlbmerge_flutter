import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../service/ffmpeg/ffmpeg_task.dart';
import 'logic.dart';
import 'state.dart';
import 'package:path/path.dart' as path;

class ProgressPage extends StatelessWidget {
  ProgressPage({Key? key}) : super(key: key);

  final ProgressLogic logic = Get.put(ProgressLogic());
  final ProgressState state = Get.find<ProgressLogic>().state;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "任务列表",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            FilledButton(
              onPressed: () {
                logic.loadOutputChildDirList();
              },
              child: const Text("归档"),
            )
          ],
        )),
        Expanded(
          child: Obx(() {
            final tasks = logic.taskController.tasks;
            final files = state.outputChildFileList;
            final totalLength = tasks.length + files.length;

            return ListView.builder(
              itemCount: totalLength,
              itemBuilder: (context, index) {
                if (index < tasks.length) {
                  // 任务条目
                  final task = tasks[index];
                  return ListTile(
                    onTap: () {},
                    title: Text("任务: ${task.cacheItem.title}"),
                    subtitle: Obx((){
                      final status = task.status.value;
                      switch (status) {
                        case FFmpegTaskStatus.failed:
                          return SelectableText("失败:${task.errorMsg.value}");
                        default:
                          return Text("${task.groupTitle ?? ''}");
                      }
                    }),
                    trailing: Obx(() {
                      final status = task.status.value;
                      return Text(
                        switch (status) {
                          FFmpegTaskStatus.pending => "等待中",
                          FFmpegTaskStatus.running => "进行中",
                          FFmpegTaskStatus.completed => "完成",
                          FFmpegTaskStatus.failed => "失败",
                        },
                        style: TextStyle(
                          color: switch (status) {
                            FFmpegTaskStatus.completed => Colors.green,
                            FFmpegTaskStatus.running => Colors.orange,
                            FFmpegTaskStatus.failed => Colors.red,
                            _ => Colors.grey,
                          },
                        ),
                      );
                    }),
                  );
                } else {
                  // 目录条目
                  final dirIndex = index - tasks.length;
                  final item = files[dirIndex];
                  return ListTile(
                    onTap: () {
                      logic.openFile(item.path);
                    },
                    title: Text(path.basename(item.path)),
                    subtitle: Text("位置: ${item.path}"),
                  );
                }
              },
            );
          }),
        ),
      ],
    );
  }
}
