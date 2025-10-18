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
              Text(
                "任务列表",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground, // 使用主题文字颜色
                ),
              ),
              FilledButton(
                onPressed: () {
                  logic.loadOutputChildDirList();
                },
                child: Text(
                  "归档",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary, // 使用主题按钮文字颜色
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.surface, // 使用主题表面颜色
          foregroundColor: Theme.of(context).colorScheme.onSurface, // 使用主题表面文字颜色
        ),
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
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Theme.of(context).colorScheme.surface, // 使用主题表面颜色
                    child: ListTile(
                      onTap: () {},
                      title: Text(
                        "任务: ${task.cacheItem.title}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface, // 使用主题表面文字颜色
                        ),
                      ),
                      subtitle: Obx(() {
                        final status = task.status.value;
                        switch (status) {
                          case FFmpegTaskStatus.failed:
                            return SelectableText(
                              "失败:${task.errorMsg.value}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error, // 使用主题错误颜色
                              ),
                            );
                          default:
                            return Text(
                              "${task.groupTitle ?? ''}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), // 使用主题次要文字颜色
                              ),
                            );
                        }
                      }),
                      trailing: Obx(() {
                        final status = task.status.value;
                        final color = _getStatusColor(status, context);
                        return Text(
                          switch (status) {
                            FFmpegTaskStatus.pending => "等待中",
                            FFmpegTaskStatus.running => "进行中",
                            FFmpegTaskStatus.completed => "完成",
                            FFmpegTaskStatus.failed => "失败",
                          },
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                    ),
                  );
                } else {
                  // 目录条目
                  final dirIndex = index - tasks.length;
                  final item = files[dirIndex];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Theme.of(context).colorScheme.surface, // 使用主题表面颜色
                    child: ListTile(
                      onTap: () {
                        logic.openFile(item.path);
                      },
                      title: Text(
                        path.basename(item.path),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface, // 使用主题表面文字颜色
                        ),
                      ),
                      subtitle: Text(
                        "位置: ${item.path}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), // 使用主题次要文字颜色
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          }),
        ),
      ],
    );
  }

  // 根据状态获取颜色
  Color _getStatusColor(FFmpegTaskStatus status, BuildContext context) {
    switch (status) {
      case FFmpegTaskStatus.completed:
        return Colors.green; // 保持绿色表示成功
      case FFmpegTaskStatus.running:
        return Colors.orange; // 保持橙色表示进行中
      case FFmpegTaskStatus.failed:
        return Theme.of(context).colorScheme.error; // 使用主题错误颜色
      case FFmpegTaskStatus.pending:
        return Theme.of(context).colorScheme.onSurface.withOpacity(0.5); // 使用主题表面颜色
    }
  }
}