import 'dart:convert';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:ffmpeg_hl/beans/Pair.dart';
import 'package:ffmpeg_hl/ffmpeg_hl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dao/cache_data_manager.dart';
import '../../../dao/sp_data_manager.dart';
import '../../../models/cache_group.dart';
import '../../../models/cache_item.dart';
import '../../../service/ffmpeg/ffmpeg_task.dart';
import '../../../utils/FileUtil.dart';
import '../../../utils/PlatformUtils.dart';
import '../../../utils/StrUtil.dart';
import 'state.dart';
import 'package:path/path.dart' as path;

class HomeLogic extends SuperController with WidgetsBindingObserver {
  final HomeState state = HomeState();

  late final ffmpegPlugin = FfmpegHl();

  // 任务控制器
  final FFmpegTaskController taskController = Get.put(FFmpegTaskController());

  void exportFileByCacheGroup(FileFormat fileType) {
    for (int i = 0; i < state.cacheGroupList.length; i++) {
      CacheGroup cacheGroup = state.cacheGroupList[i];
      if (cacheGroup.checked) {
        exportFileByCacheItem(i, fileType, alwaysExport: true);
      }
    }
  }

  //导出
  void exportFileByCacheItem(int cacheGroupIndex, FileFormat fileType,
      {bool alwaysExport = false}) async {
    //获取缓存组
    CacheGroup cacheGroup = state.cacheGroupList[cacheGroupIndex];

    List<CacheItem> needExportCacheItemList;
    if (alwaysExport) {
      needExportCacheItemList = cacheGroup.cacheItemList;
    } else {
      //过滤出需要导出的缓存项
      needExportCacheItemList =
          getNeedHandleCacheItemList(paramCacheGroup: cacheGroup);
    }

    for (int i = 0; i < needExportCacheItemList.length; i++) {
      CacheItem item = needExportCacheItemList[i];
      await exportFile(item, fileType, groupTitle: cacheGroup.title);
    }
  }

  //导出
  exportFile(CacheItem item, FileFormat fileType, {String? groupTitle}) async {
    var title = item.title;

    var exportTargetPath;
    switch (fileType) {
      case FileFormat.mp4:
        exportTargetPath = item.videoPath;
        break;
      case FileFormat.mp3:
        exportTargetPath = item.audioPath;
        break;
    }

    if (exportTargetPath == null) {
      return;
    }

    var result = await runPlatformFuncFuture<Pair<bool, String>?>(
      onDefault: () async {
        // 输出目录
        var outputDirPath = getOutputDirPath(groupTitle: groupTitle);
        //文件名
        var outputFileName = title == null
            ? "${DateTime.now().millisecondsSinceEpoch}_only${fileType.extension}.${fileType.extension}"
            : "${title}_only${fileType.extension}.${fileType.extension}";
        var outputAudioPath = path.join(outputDirPath, outputFileName);
        //解密m4s
        var result =
            await decryptPcM4sAfter202403(exportTargetPath, outputAudioPath);
        if (result) {
          return Pair(true, "");
        }
        return Pair(false, "解密失败");
      }
    );
    if (result == null) {
      print("${title}导出未知错误");
      return;
    }
    if (result.first) {
      print("${title}导出完成");
    } else {
      print("${title}导出错误${result.second}");
    }
  }

  void mergeAudioVideoByCacheGroup() {
    //过滤出需要合并的缓存组索引
    List<MapEntry<int, CacheGroup>> indexCacheGroupList = state.cacheGroupList
        .asMap()
        .entries
        .where((entry) => entry.value.checked)
        .toList();

    for (int i = 0; i < indexCacheGroupList.length; i++) {
      int index = indexCacheGroupList[i].key;
      mergeAudioVideoByCacheItem(index, alwaysMerge: true);
    }
    Get.snackbar("", "已添加任务,请前往进度页面查看");
  }

  void mergeAudioVideoByCacheItem(int cacheGroupIndex,
      {bool alwaysMerge = false}) async {
    //获取缓存组
    CacheGroup cacheGroup = state.cacheGroupList[cacheGroupIndex];

    List<CacheItem> needMergeCacheItemList;
    if (alwaysMerge) {
      needMergeCacheItemList = cacheGroup.cacheItemList;
    } else {
      //过滤出需要合并的缓存项
      needMergeCacheItemList =
          getNeedHandleCacheItemList(paramCacheGroup: cacheGroup);
    }

    //遍历并进行合并
    for (int i = 0; i < needMergeCacheItemList.length; i++) {
      CacheItem item = needMergeCacheItemList[i];
      // await mergeAudioVideo(item, groupTitle: cacheGroup.title);
      taskController.addTask(
          FFmpegTaskBean(cacheItem: item, groupTitle: cacheGroup.title));
    }
  }

  //过滤出需要处理的缓存项
  List<CacheItem> getNeedHandleCacheItemList(
      {CacheGroup? paramCacheGroup, int? cacheGroupIndex}) {
    CacheGroup cacheGroup;
    if (paramCacheGroup != null) {
      cacheGroup = paramCacheGroup;
    } else if (cacheGroupIndex != null) {
      //获取缓存组
      cacheGroup = state.cacheGroupList[cacheGroupIndex];
    } else {
      //抛出异常
      throw Exception("paramCacheGroup 和 cacheGroupIndex 不能同时为空");
    }
    //过滤出需要合并的缓存项
    List<CacheItem> needMergeCacheItemList =
        cacheGroup.cacheItemList.where((element) {
      return element.checked;
    }).toList();
    return needMergeCacheItemList;
  }


  //获取输出目录
  static String getOutputDirPath({String? groupTitle}) {
    var outputRootPath = SpDataManager.getOutputDirPath();

    var outputDirPath;
    if (groupTitle == null) {
      outputDirPath = outputRootPath;
    } else {
      outputDirPath = path.join(outputRootPath, groupTitle);
    }

    // 创建目录
    if (!Directory(outputDirPath).existsSync()) {
      Directory(outputDirPath).createSync(recursive: true);
    }

    return outputDirPath;
  }

  void onInputCacheDirPathDragDone(List<DropItem> dropItemList) {
    if (dropItemList.length != 1) {
      Get.snackbar("", "只能拖入一个路径");
      return;
    }
    DropItem dropItem = dropItemList.first;
    var isDir = FileUtil.isDir(dropItem.path);
    if (!isDir) {
      Get.snackbar("", "请拖入一个目录");
      return;
    }
    state.inputCacheDirPath = dropItem.path;
    // 解析缓存数据
    parseCacheData();
  }

  //选择输入缓存文件夹路径
  void pickInputCacheDirPath() async {
    String? dirPath = await FilePicker.platform.getDirectoryPath();

    if (dirPath == null) {
      Get.snackbar("提示", "您未选择路径");
      return;
    }

    print(dirPath);
    //判断路径中是否有空格
    if (StrUtil.containsAnySpace(dirPath)) {
      Get.snackbar("提示", "路径中不能包含空格,请重新选择");
      return;
    }
    state.inputCacheDirPath = dirPath;
    parseCacheData();
    //持久化
    //SpDataManager.setInputCacheDirPath(dirPath);
  }

  // 解析缓存数据
  void parseCacheData() {
    String dirPath = state.inputCacheDirPath;

    var manager = CacheDataManager();
    List<CacheGroup>? cacheGroupList =
        runPlatformFunc<List<CacheGroup>?>(onDefault: () {
          return manager.loadPcCacheData(dirPath);
    });

    if (cacheGroupList == null) {
      return;
    }

    state.cacheGroupList = cacheGroupList;
    // print(cacheGroupList);
  }

  //改变多选状态
  changeMultiSelectMode(bool value) {
    state.isMultiSelectMode = value;
    // 取消全选
    changeAllGroupListChecked(false);
  }

  // 改变缓存组选择状态
  void changeGroupListChecked(int index, bool value) {
    state.changeGroupListCheckedAndRefresh(index, value);
    var isAllChecked = _judgeAllGroupListChecked();
    state.isAllGroupListChecked = isAllChecked;
  }

  // 改变缓存项选择状态
  void changeCacheItemListChecked(int cacheGroupIndex, int index, bool value) {
    state.changeCacheItemListCheckedAndRefresh(cacheGroupIndex, index, value);
    var isAllChecked = _judgeAllCacheItemListChecked(cacheGroupIndex);
    state.isAllCacheItemListChecked = isAllChecked;
  }

  // 判断缓存组是否全选
  bool _judgeAllGroupListChecked() {
    for (int i = 0; i < state.cacheGroupList.length; i++) {
      if (!state.cacheGroupList[i].checked) {
        return false;
      }
    }
    return true;
  }

  //判断缓存项是否全选
  bool _judgeAllCacheItemListChecked(int cacheGroupIndex) {
    for (int i = 0;
        i < state.cacheGroupList[cacheGroupIndex].cacheItemList.length;
        i++) {
      if (!state.cacheGroupList[cacheGroupIndex].cacheItemList[i].checked) {
        return false;
      }
    }
    return true;
  }

  //缓存组全选
  void changeAllGroupListChecked(bool value) {
    for (int i = 0; i < state.cacheGroupList.length; i++) {
      state.changeGroupListChecked(i, value);
    }
    state.refreshGroupList();

    state.isAllGroupListChecked = value;
  }

  //缓存项全选
  void changeAllCacheItemListChecked(int cacheGroupIndex, bool value) {
    for (int i = 0;
        i < state.cacheGroupList[cacheGroupIndex].cacheItemList.length;
        i++) {
      state.changeCacheItemListChecked(cacheGroupIndex, i, value);
    }
    state.refreshGroupList();
    state.isAllCacheItemListChecked = value;
  }

  changeTextFieldDragging(bool value) {
    state.isTextFieldDragging = value;
  }

  // 解密电脑缓存文件2024.03之后的
  static Future<bool>  decryptPcM4sAfter202403(
    String targetPath,
    String outputPath, {
    int bufSize = 256 * 1024 * 1024, // 256MB
  }) async {
    final targetFile = File(targetPath);
    final outputFile = File(outputPath);

    final target = await targetFile.open();
    final output = await outputFile.open(mode: FileMode.write);

    try {
      // 1. 读取前 32 字节
      final headerBytes = await target.read(32);

      // 2. 转成字符串再替换（只会动 ASCII 部分）
      var headerStr = ascii.decode(headerBytes, allowInvalid: true);
      headerStr = headerStr.replaceAll("000000000", "");
      final newHeader = ascii.encode(headerStr);

      // 3. 写入替换后的 header
      await output.writeFrom(newHeader);

      // 4. 分块写剩余的内容
      while (true) {
        final chunk = await target.read(bufSize);
        if (chunk.isEmpty) break;
        await output.writeFrom(chunk);
      }
    } catch (e) {
      e.printError();
      return false;
    } finally {
      await target.close();
      await output.close();
    }
    return true;
  }

  // 监听生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.detached ||
        appState == AppLifecycleState.inactive) {
      SpDataManager.setInputCacheDirPath(state.inputCacheDirPath);
    }
    super.didChangeAppLifecycleState(appState);
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    parseCacheData();
    super.onReady();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}
}
