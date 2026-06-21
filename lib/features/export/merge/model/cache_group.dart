import 'package:freezed_annotation/freezed_annotation.dart';

import './cache_item.dart';

part 'cache_group.freezed.dart';

@freezed
abstract class CacheGroup with _$CacheGroup {
  const CacheGroup._();

  const factory CacheGroup({
    // 是否选中
    @Default(false) bool checked,
    // 缓存组路径,如果是合集的话就是合集路径(不是某一个缓存路径,而是它们的父目录),如果是单个的话就是单个具体的缓存路径
    String? path,
    String? groupId,
    // 缓存组标题
    String? title,
    // 缓存组副标题
    String? subTitle,
    // 缓存组item列表
    @Default([]) List<CacheItem> cacheItemList,

    String? coverPath,
    String? coverUrl,
  }) = _CacheGroup;
}

/// 缓存组构建者
class CacheGroupBuilder {
  bool checked = false;
  String? path;
  String? groupId;
  String? title;
  String? subTitle;
  List<CacheItem> cacheItemList = [];
  String? coverPath;
  String? coverUrl;

  CacheGroupBuilder();

  CacheGroupBuilder.from(CacheGroup group) {
    checked = group.checked;
    path = group.path;
    groupId = group.groupId;
    title = group.title;
    subTitle = group.subTitle;
    cacheItemList = List<CacheItem>.from(group.cacheItemList);
    coverPath = group.coverPath;
    coverUrl = group.coverUrl;
  }

  CacheGroup build() {
    return CacheGroup(
      checked: checked,
      path: path,
      groupId: groupId,
      title: title,
      subTitle: subTitle,
      cacheItemList: cacheItemList,
      coverPath: coverPath,
      coverUrl: coverUrl,
    );
  }
}
