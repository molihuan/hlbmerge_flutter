import 'dart:io';

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

class CacheDataManager {
  //缓存平台
  CachePlatform cachePlatform = CachePlatform.PC;

  List<CacheGroup> loadCacheData(String targetPath) {
    List<CacheGroup> cacheGroupList = [];

    var rootDir = Directory(targetPath);
    if (!rootDir.existsSync()) {
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
    if(cacheGroupList.isNotEmpty){
      var jsonInfo = JsonUtils.parseCacheJson(cacheGroupList[1].cacheItemList[0].jsonPath);
      print(jsonInfo);
    }

    return cacheGroupList;
  }
}
