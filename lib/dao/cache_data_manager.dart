import 'dart:convert';
import 'dart:io';

import 'package:ffmpeg_hl/beans/Pair.dart';
import 'package:get/get.dart';
import 'package:hlbmerge/models/cache_group.dart';
import 'package:hlbmerge/utils/FileUtils.dart';
import 'package:hlbmerge/utils/JsonUtils.dart';
import 'package:path/path.dart' as path;

import '../models/cache_item.dart';
import '../utils/PlatformUtils.dart';

//枚举,缓存平台
enum CachePlatform {
  //win
  win("Windows缓存"),
  //mac
  mac("Mac缓存"),
  //手机
  android("安卓缓存");
  final String title; // 枚举字段

  const CachePlatform(this.title); // 构造函数
}

//m4s文件类型
enum M4sFileType {
  //视频
  video,
  //音频
  audio,
}

class CacheDataManager {
  //缓存平台
  CachePlatform _cachePlatform = CachePlatform.win;

  //设置缓存平台
  void setCachePlatform(CachePlatform platform) {
    _cachePlatform = platform;
  }

  List<CacheGroup>? loadCacheData(String targetPath) {
    //判断路径是否存在并且是否是文件夹
    var rootDir = Directory(targetPath);
    if (!rootDir.existsSync()) {
      // 目录不存在
      return null;
    }

    return runPlatformFunc<List<CacheGroup>?>(onDefault: () {
      switch (_cachePlatform) {
        case CachePlatform.win:
          return loadWinCacheData(rootDir);
        case CachePlatform.android:
          return loadAndroidCacheData(rootDir);
        default:
          return null;
      }
    }, onAndroid: () {
      return loadAndroidCacheData(rootDir);
    });
  }

  // 加载安卓缓存数据
  List<CacheGroup>? loadAndroidCacheData(Directory rootDir) {
    List<CacheItem> cacheItemList = [];
    List<File> blvFiles = [];
    //遍历获取子目录
    var firstDirs = rootDir.listSync();
    for (var firstDir in firstDirs) {
      if (firstDir is Directory) {
        for (var secondDir in firstDir.listSync()) {
          blvFiles.clear();
          if (secondDir is Directory) {
            //创建缓存item
            var cacheItem = CacheItem();
            //缓存项父路径
            cacheItem.parentPath = firstDir.path;
            //缓存项路径
            cacheItem.path = secondDir.path;
            try {
              //遍历缓存项
              final entities = secondDir.listSync(recursive: true);
              for (var file in entities) {
                if (file is File) {
                  if (file.path.endsWith("entry.json")) {
                    //json信息文件
                    // print(file.path);
                    cacheItem.jsonPath = file.path;
                    //解析json文件信息
                    cacheItem = _parseAndroidJsonFile(cacheItem);
                  } else if (file.path.endsWith("danmaku.xml")) {
                    //弹幕文件
                    cacheItem.danmakuPath = file.path;
                  } else if (file.path.endsWith("audio.m4s")) {
                    cacheItem.audioPath = file.path;
                  } else if (file.path.endsWith("video.m4s")) {
                    cacheItem.videoPath = file.path;
                  } else if (file.path.endsWith("cover.jpg")) {
                    cacheItem.coverPath = file.path;
                  } else if (file.path.endsWith(".blv")) {
                    blvFiles.add(file);
                  }
                }
              }

              if (blvFiles.isNotEmpty) {
                cacheItem.blvPathList = blvFiles.map((it) {
                  return it.path;
                }).toList();
              }
              //判断是否可以合并音视频
              if (cacheItem.canMergeAudioVideo()) {
                cacheItem.groupId = firstDir.path;
                cacheItemList.add(cacheItem);
              }
            } catch (e) {
              print('递归遍历目录时出错: $e');
            }
          }
        }
      }
    }

    //缓存组列表
    List<CacheGroup> cacheGroupList = [];

    //遍历cacheItemList并按groupId进行分组
    for (var item in cacheItemList) {
      var groupIdList = cacheGroupList.map((group) {
        return group.groupId;
      });
      if (groupIdList.contains(item.groupId)) {
        //存在则添加到对应缓存组
        for (var group in cacheGroupList) {
          if (group.groupId == item.groupId) {
            //更新缓存组的路径为它们的父目录
            group.path = item.parentPath;
            group.cacheItemList.add(item);
            break;
          }
        }
      } else {
        //不存在则创建缓存组
        var cacheGroup = CacheGroup();
        cacheGroup.groupId = item.groupId;
        cacheGroup.path = item.path;
        cacheGroup.title = item.groupTitle;
        cacheGroup.coverPath = item.groupCoverPath;
        cacheGroup.coverUrl = item.groupCoverUrl;
        cacheGroup.cacheItemList.add(item);
        cacheGroupList.add(cacheGroup);
      }
    }

    print(cacheGroupList);
    return cacheGroupList;
  }

  // 加载Windows缓存数据
  List<CacheGroup>? loadWinCacheData(Directory rootDir) {
    List<CacheItem> cacheItemList = [];
    List<File> m4sFiles = [];

    //遍历获取子目录
    var firstDirs = rootDir.listSync();
    for (var firstDir in firstDirs) {
      m4sFiles.clear();
      if (firstDir is Directory) {
        //创建缓存item
        var cacheItem = CacheItem();
        //缓存项父路径
        cacheItem.parentPath = rootDir.path;
        //缓存项路径
        cacheItem.path = firstDir.path;
        var files = firstDir.listSync();
        for (var file in files) {
          if (file is File) {
            if (file.path.endsWith(".videoInfo")) {
              //json信息文件
              // print(file.path);
              cacheItem.jsonPath = file.path;
              //解析json文件信息
              cacheItem = _parseWinJsonFile(cacheItem);
            } else if (file.path.endsWith("dm1")) {
              //弹幕文件
              cacheItem.danmakuPath = file.path;
            } else if (file.path.endsWith(".m4s")) {
              //m4s文件
              // print(file.path);
              //收集m4s文件
              m4sFiles.add(file);
            } else if (file.path.endsWith("group.jpg")) {
              cacheItem.groupCoverPath = file.path;
            } else if (file.path.endsWith("image.jpg")) {
              cacheItem.coverPath = file.path;
            }
          }
        }
        //判断并设置音频文件, 视频文件
        var audioVideoM4s = _judgeM4sFile(m4sFiles);
        if (audioVideoM4s != null) {
          cacheItem.audioPath = audioVideoM4s.first;
          cacheItem.videoPath = audioVideoM4s.second;
          // print(cacheItem);
          //添加缓存项
          cacheItemList.add(cacheItem);
        }
      }
    }

    //缓存组列表
    List<CacheGroup> cacheGroupList = [];

    //遍历cacheItemList并按groupId进行分组
    for (var item in cacheItemList) {
      var groupIdList = cacheGroupList.map((group) {
        return group.groupId;
      });
      if (groupIdList.contains(item.groupId)) {
        //存在则添加到对应缓存组
        for (var group in cacheGroupList) {
          if (group.groupId == item.groupId) {
            //更新缓存组的路径为它们的父目录
            group.path = item.parentPath;
            group.cacheItemList.add(item);
            break;
          }
        }
      } else {
        //不存在则创建缓存组
        var cacheGroup = CacheGroup();
        cacheGroup.groupId = item.groupId;
        cacheGroup.path = item.path;
        cacheGroup.title = item.groupTitle;
        cacheGroup.coverPath = item.groupCoverPath;
        cacheGroup.coverUrl = item.groupCoverUrl;
        cacheGroup.cacheItemList.add(item);
        cacheGroupList.add(cacheGroup);
      }
    }

    print(cacheGroupList);
    return cacheGroupList;
  }

  //解析安卓json文件信息
  CacheItem _parseAndroidJsonFile(CacheItem item) {
    final jsonPath = item.jsonPath;
    if (jsonPath == null) {
      //抛出异常
      throw Exception("json路径不存在,请先设置");
    }
    //判断json文件是否是正常的json格式
    try {
      // 读取文件
      String content = File(jsonPath).readAsStringSync();
      Map<String, dynamic> data;
      try {
        // 第一次直接尝试解析
        data = json.decode(content);
      } catch (_) {
        // 如果失败，再尝试修复
        data = JsonUtils.tryFixJson(content);
      }

      item.avId = _getMapString(data, 'avid');
      item.bvId = _getMapString(data, 'bvid');

      if (data.containsKey('page_data')) {
        final pageData = data['page_data'];
        item.title = _getMapString(pageData, 'part');
        item.cId = _getMapString(pageData, 'cid');
      }

      if (data.containsKey('ep')) {
        final epData = data['ep'];
        if(epData != null){
          item.title =
              _getFirstNonNull([() => _getMapString(epData, 'index_title')]);
        }
      }

      // 获取标题
      item.title = _getFirstNonNull([
        () => item.title,
        () => _getMapString(data, 'title'),
        () => item.bvId,
        () => item.avId,
        () => item.cId,
      ]);

      item.coverUrl = _getMapString(data, 'cover');

      // item.groupId = _getMapString(data, 'groupId');
      item.groupCoverPath = item.coverPath;

      item.groupCoverUrl = item.coverUrl;
      item.groupTitle = _getMapString(data, 'title');
    } catch (e) {
      print("解析${item.jsonPath} json文件错误:${e.toString()}");
    }

    return item;
  }

  //解析电脑json文件信息
  CacheItem _parseWinJsonFile(CacheItem item) {
    final jsonPath = item.jsonPath;
    if (jsonPath == null) {
      //抛出异常
      throw Exception("json路径不存在,请先设置");
    }
    //判断json文件是否是正常的json格式
    try {
      // 读取文件
      String content = File(jsonPath).readAsStringSync();
      final Map<String, dynamic> data = json.decode(content);

      item.avId = _getMapString(data, 'aid');
      item.bvId = _getMapString(data, 'bvid');
      // 获取标题
      item.title = _getFirstNonNull([
        () => _getMapString(data, 'title'),
        () => _getMapString(data, 'tabName'),
        () => _getMapString(data, 'cid'),
        () => item.bvId,
        () => item.avId,
        () => _getMapString(data, 'itemId'),
        () => _getMapString(data, 'p'),
      ]);

      item.coverPath = item.coverPath ?? _getMapString(data, 'coverPath');
      item.coverUrl = _getMapString(data, 'coverUrl');

      item.groupId = _getMapString(data, 'groupId');
      item.groupCoverPath =
          item.groupCoverPath ?? _getMapString(data, 'groupCoverPath');
      item.groupCoverUrl = _getMapString(data, 'groupCoverUrl');
      item.groupTitle = _getMapString(data, 'groupTitle');
    } catch (e) {
      print("解析${item.jsonPath} json文件错误:");
      e.printError();
    }

    return item;
  }

  //获取Map中的字符串值
  static String? _getMapString(dynamic data, String key) {
    if (data is Map && data.containsKey(key)) {
      final value = data[key];
      return value is String ? value : value?.toString();
    }
    return null;
  }

  // 获取第一个非空的值
  static String? _getFirstNonNull(List<String? Function()> getters) {
    for (var get in getters) {
      final value = get();
      if (value != null && value.trim().isNotEmpty) return value;
    }
    return null;
  }

  //判断电脑缓存文件m4s文件
  //返回的Pair<音频文件, 视频文件>
  Pair<String, String>? _judgeM4sFile(List<File> m4sFiles) {
    if (m4sFiles.length != 2) {
      return null;
    }
    var file1 = m4sFiles[0];
    var file2 = m4sFiles[1];

    //根据文件名判断音频文件
    if (file1.path.endsWith("30280.m4s")) {
      return Pair(file1.path, file2.path);
    }
    if (file2.path.endsWith("30280.m4s")) {
      return Pair(file2.path, file1.path);
    }

    //根据文件大小判断音频文件
    if (file1.lengthSync() < file2.lengthSync()) {
      return Pair(file1.path, file2.path);
    } else {
      return Pair(file2.path, file1.path);
    }
  }
}
