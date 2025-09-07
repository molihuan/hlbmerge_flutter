import './cache_item.dart';
class CacheGroup{
  // 是否选中
  bool checked = false;
  // 缓存组路径,如果是合集的话就是合集路径(不是某一个缓存路径,而是它们的父目录),如果是单个的话就是单个具体的缓存路径
  String? path;
  String? groupId;
  // 缓存组标题
  String? title;
  // 缓存组副标题
  String? subTitle;
  // 缓存组item列表
  List<CacheItem> cacheItemList = [];

  String? coverPath;
  String? coverUrl;

  @override
  String toString() {
    return 'CacheGroup{checked: $checked, path: $path, groupId: $groupId, title: $title, subTitle: $subTitle, cacheItemList: $cacheItemList, coverPath: $coverPath, coverUrl: $coverUrl}';
  }
}