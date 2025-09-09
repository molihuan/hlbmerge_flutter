import 'dart:convert';
import 'dart:io';

import 'package:ffmpeg_hl/beans/Pair.dart';
import 'package:get/get.dart';
import 'package:hlbmerge/models/cache_group.dart';
import 'package:hlbmerge/utils/FileUtil.dart';
import 'package:hlbmerge/utils/JsonUtils.dart';
import 'package:path/path.dart' as path;

import '../models/cache_item.dart';

//枚举,缓存平台
enum CachePlatform {
  //电脑
  PC,
  //手机
  Phone,
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
  CachePlatform cachePlatform = CachePlatform.PC;

  List<CacheGroup> loadCacheData(String targetPath) {
    //缓存组列表
    List<CacheGroup> cacheGroupList = [];

    var rootDir = Directory(targetPath);
    if (!rootDir.existsSync()) {
      // 目录不存在
      return cacheGroupList;
    }

    //m4s文件大小
    var m4sSize = 0;
    //遍历获取子目录
    var firstDirs = rootDir.listSync();
    //创建PC缓存组
    var pcCacheGroup = CacheGroup();
    pcCacheGroup.path = rootDir.path;

    for (var firstDir in firstDirs) {
      if (firstDir is Directory) {
        var secondDirs = firstDir.listSync();
        //创建手机缓存组
        var phoneCacheGroup = CacheGroup();
        phoneCacheGroup.path = firstDir.path;

        //创建电脑缓存项
        var pcCacheItem = CacheItem();
        pcCacheItem.path = firstDir.path;

        for (var secondDir in secondDirs) {
          //创建手机缓存项
          var phoneCacheItem = CacheItem();
          phoneCacheItem.parentPath = secondDir.path;

          if (secondDir is Directory) {
            var thirdDirs = secondDir.listSync();
            for (var thirdDir in thirdDirs) {
              if (thirdDir is Directory) {
                var fourthDirs = thirdDir.listSync();
                for (var fourthDir in fourthDirs) {
                  if (fourthDir is File) {
                    if (fourthDir.path.endsWith("video.m4s")) {
                      phoneCacheItem.videoPath = fourthDir.path;
                    } else if (fourthDir.path.endsWith("audio.m4s")) {
                      phoneCacheItem.audioPath = fourthDir.path;
                    } else if (fourthDir.path.endsWith(".blv")) {
                      phoneCacheItem.blvPathList ??= [];
                      phoneCacheItem.blvPathList?.add(fourthDir.path);
                    }
                  }
                }
              } else if (thirdDir is File) {
                if (thirdDir.path.endsWith("entry.json")) {
                  cachePlatform = CachePlatform.Phone;
                  phoneCacheItem.jsonPath = thirdDir.path;
                } else if (thirdDir.path.endsWith("danmaku.xml")) {
                  phoneCacheItem.danmakuPath = thirdDir.path;
                }
              }
            }

            if (phoneCacheItem.videoPath != null &&
                phoneCacheItem.audioPath != null) {
              phoneCacheGroup.cacheItemList.add(phoneCacheItem);
            } else if (phoneCacheItem.blvPathList?.isNotEmpty == true) {
              phoneCacheGroup.cacheItemList.add(phoneCacheItem);
            }
          } else if (secondDir is File) {
            if (secondDir.path.endsWith(".videoInfo")) {
              cachePlatform = CachePlatform.PC;
              pcCacheItem.jsonPath = secondDir.path;
            } else if (secondDir.path.endsWith(".m4s")) {
              var currM4sSize = secondDir.lengthSync();
              if (m4sSize < currM4sSize) {
                pcCacheItem.videoPath = secondDir.path;
              } else {
                pcCacheItem.audioPath = secondDir.path;
              }
              m4sSize = currM4sSize;
            } else if (secondDir.path.endsWith("dm1")) {
              pcCacheItem.danmakuPath = secondDir.path;
            }
          }
        }

        switch (cachePlatform) {
          case CachePlatform.PC:
            m4sSize = 0;
            if (pcCacheItem.videoPath != null &&
                pcCacheItem.audioPath != null) {
              pcCacheGroup.cacheItemList.add(pcCacheItem);
            } else if (pcCacheItem.blvPathList?.isNotEmpty == true) {
              pcCacheGroup.cacheItemList.add(pcCacheItem);
            }
            break;
          case CachePlatform.Phone:
            break;
        }

        if (phoneCacheGroup.cacheItemList.isNotEmpty) {
          cacheGroupList.add(phoneCacheGroup);
        }
      }
    }

    if (pcCacheGroup.cacheItemList.isNotEmpty) {
      cacheGroupList.add(pcCacheGroup);
    }

    //解析json
    if (cacheGroupList.isNotEmpty) {
      var jsonInfo =
          JsonUtils.parseCacheJson(cacheGroupList[1].cacheItemList[0].jsonPath);
      print(jsonInfo);
    }

    return cacheGroupList;
  }

  List<CacheGroup>? loadPcCacheData(String targetPath) {
    //判断路径是否存在并且是否是文件夹
    var rootDir = Directory(targetPath);
    if (!rootDir.existsSync()) {
      // 目录不存在
      return null;
    }

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
        cacheItem.parentPath = targetPath;
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
              cacheItem = _parsePcJsonFile(cacheItem);
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

  //解析电脑json文件信息
  CacheItem _parsePcJsonFile(CacheItem item) {
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
      // 获取标题
      item.title = _getFirstNonNull([
        () => _getMapString(data, 'title'),
        () => _getMapString(data, 'tabName'),
        () => _getMapString(data, 'cid'),
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
