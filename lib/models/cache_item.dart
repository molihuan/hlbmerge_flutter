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

  //avid、bvid、cid
  // 最早期 B 站视频的 视频 ID、2020 年之前是主要的 ID 形式.示例：av170001 → 170001 就是 avid
  String? avId;
  // B 站推出的 新的视频 ID.示例：BV17x411w7KC
  String? bvId;
  // 某个视频分 P 的具体内容 ID。示例：一个多 P 视频，可能有多个 cid，每个 P 一个 cid.如果视频有多 P，比如 "P1 开箱"、"P2 测评"，它们 共用同一个 bvid/avid，但是每个分 P 有不同的 cid
  String? cId;

  // 缓存组信息
  String? groupId;
  String? groupCoverPath;
  String? groupCoverUrl;
  String? groupTitle;

  // 在缓存组中的p(顺序/章节索引)
  int? p;

  //判断是否可以合并音视频
  bool canMergeAudioVideo(){
    //如果audioPath和videoPath其中有一个为空,并且blvPathList也为空,则返回false,表示不能合并,其他返回true
    return (audioPath != null && videoPath != null) || (blvPathList != null && blvPathList!.isNotEmpty);
  }

  @override
  String toString() {
    return 'CacheItem{checked: $checked, path: $path, parentPath: $parentPath, danmakuPath: $danmakuPath, jsonPath: $jsonPath, audioPath: $audioPath, videoPath: $videoPath, blvPathList: $blvPathList, title: $title, subTitle: $subTitle, coverPath: $coverPath, coverUrl: $coverUrl, avId: $avId, bvId: $bvId, cId: $cId, groupId: $groupId, groupCoverPath: $groupCoverPath, groupCoverUrl: $groupCoverUrl, groupTitle: $groupTitle, p: $p}';
  }
}
