import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../service/ffmpeg/ffmpeg_task.dart';
import 'logic.dart';
import 'state.dart';
import 'package:path/path.dart' as path;

class ProgressPage extends StatelessWidget {
  ProgressPage({Key? key}) : super(key: key);

  final ProgressLogic logic = Get.put(ProgressLogic());
  final ProgressState state = Get.find<ProgressLogic>().state;

  @override
  Widget build(BuildContext context) {
    final FFmpegTaskController taskController = Get.find();

    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "任务列表",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FilledButton(onPressed: () {
                  taskController.tasks.clear();
                  taskController.tasks.refresh();
                  logic.archive();
                }, child: const Text("归档"))
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              // 合并两个列表
              final tasks = taskController.tasks;
              final dirs = state.outputChildDirList;
              final totalLength = tasks.length + dirs.length;

              return ListView.builder(
                itemCount: totalLength,
                itemBuilder: (context, index) {
                  if (index < tasks.length) {
                    // 任务列表
                    final task = tasks[index];
                    return ListTile(
                      onTap: () {},
                      title: Text("任务: ${task.cacheItem.title}"),
                      subtitle: Text("${task.groupTitle}"),
                      trailing: Text(
                        switch (task.status) {
                          FFmpegTaskStatus.pending => "等待中",
                          FFmpegTaskStatus.running => "进行中",
                          FFmpegTaskStatus.completed => "完成",
                          FFmpegTaskStatus.failed => "失败",
                        },
                        style: TextStyle(
                          color: switch (task.status) {
                            FFmpegTaskStatus.completed => Colors.green,
                            FFmpegTaskStatus.running => Colors.orange,
                            FFmpegTaskStatus.failed => Colors.red,
                            _ => Colors.grey,
                          },
                        ),
                      ),
                    );
                  } else {
                    // 输出目录列表
                    final dirIndex = index - tasks.length;
                    final item = dirs[dirIndex];
                    return ListTile(
                      onTap: () {},
                      title: Text("${path.basename(item.path)}"),
                      subtitle: Text("位置: ${item.path}"),
                    );
                  }
                },
              );
            }),
          ),

        ],
      ),
    );
  }
}
