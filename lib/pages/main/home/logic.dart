import 'dart:convert';
import 'dart:io';

import 'package:ffmpeg_hl/beans/Pair.dart';
import 'package:ffmpeg_hl/ffmpeg_hl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dao/cache_data_manager.dart';
import '../../../models/cache_group.dart';
import '../../../models/cache_item.dart';
import '../../../utils/PlatformUtils.dart';
import 'state.dart';

class HomeLogic extends GetxController {
  final HomeState state = HomeState();

  late final ffmpegPlugin = FfmpegHl();

  mergeAudioVideoByCacheItem(int cacheGroupIndex) async{
    //获取缓存组
    CacheGroup cacheGroup = state.cacheGroupList[cacheGroupIndex];
    //过滤出需要合并的缓存项
    List<CacheItem> needMergeCacheItemList = cacheGroup.cacheItemList.where((element) {
      return element.checked;
    }).toList();

    //遍历并进行合并
    for (int i = 0; i < needMergeCacheItemList.length; i++) {
      CacheItem item = needMergeCacheItemList[i];
      await mergeAudioVideo(item);
    }
  }

  //合并音视频
  mergeAudioVideo(CacheItem item) async {
    var audioPath = item.audioPath;
    var videoPath = item.videoPath;
    var title = item.title;

    if (audioPath == null || videoPath == null) {
      return;
    }

    var tempAudioPath = "${audioPath}.temp.mp3";
    var tempVideoPath = "${videoPath}.temp.mp4";

    var result = await runPlatformFuncFuture<Pair<bool, String>?>(
      onWindows: () async {
        //解密m4s
        await decryptPcM4sAfter202403(audioPath, tempAudioPath);
        await decryptPcM4sAfter202403(videoPath, tempVideoPath);
        //文件名
        var outputFileName = title == null
            ? "${DateTime.now().millisecondsSinceEpoch}.mp4"
            : "${title}.mp4";
        //完成文件路径
        var outputPath =
            "C:/Users/moli/FlutterProject/hlbmerge_flutter/testRes/合并完成目录/${outputFileName}";

        return await ffmpegPlugin.mergeAudioVideo(
            tempAudioPath, tempVideoPath, outputPath);
      },
      onDefault: () => null,
    );

    //删除临时文件
    runPlatformFunc(onDefault: () {}, onWindows: () {
      File(tempAudioPath).delete();
      File(tempVideoPath).delete();
    });

    if (result == null) {
      print("${title}合并未知错误");
      return;
    }

    if (result.first) {
      print("${title}合并完成");
    }else{
      print("${title}合并错误${result.second}");
    }
  }

  // 解析缓存数据
  parseCacheData() {
    String dirPath =
        "C:/Users/moli/FlutterProject/hlbmerge_flutter/testRes/电脑缓存文件";

    var manager = CacheDataManager();
    List<CacheGroup>? cacheGroupList =
        runPlatformFunc<List<CacheGroup>?>(onDefault: () {
      return null;
    }, onWindows: () {
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

  // 解密电脑缓存文件2024.03之后的
  Future<void> decryptPcM4sAfter202403(
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
    } finally {
      await target.close();
      await output.close();
    }
  }

  @override
  void onReady() {
    parseCacheData();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
