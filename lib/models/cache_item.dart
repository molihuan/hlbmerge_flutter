class CacheItem {
  // 是否选中
  bool checked = false;

  // 缓存项路径
  String? path;

  // 缓存项父路径
  String? parentPath;

  // 弹幕文件路径
  String? danmakuPath;

  // json文件路径
  String? jsonPath;

  // 音频文件路径
  String? audioPath;

  // 视频文件路径
  String? videoPath;

  // blv文件列表路径
  List<String>? blvPathList;

  // 标题
  String? title;

  // 子标题
  String? subTitle;

  String? coverPath;
  String? coverUrl;

  // 缓存组信息
  String? groupId;
  String? groupCoverPath;
  String? groupCoverUrl;
  String? groupTitle;

  @override
  String toString() {
    return 'CacheItem{checked: $checked, path: $path, parentPath: $parentPath, danmakuPath: $danmakuPath, jsonPath: $jsonPath, audioPath: $audioPath, videoPath: $videoPath, blvPathList: $blvPathList, title: $title, subTitle: $subTitle, coverPath: $coverPath, coverUrl: $coverUrl, groupId: $groupId, groupCoverPath: $groupCoverPath, groupCoverUrl: $groupCoverUrl, groupTitle: $groupTitle}';
  }
}
