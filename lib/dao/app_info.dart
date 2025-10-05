import 'dart:convert';

/// 列表里的每条更新信息
class AppUpdateData {
  final String platform;
  final bool enableUpdateCheck;
  final int versionCode;
  final String versionName;
  final String updateTime;
  final String updateContent;
  final String downloadUrl;
  final String downloadPageUrl;
  final int appSize;
  final String md5;

  AppUpdateData({
    required this.platform,
    required this.enableUpdateCheck,
    required this.versionCode,
    required this.versionName,
    required this.updateTime,
    required this.updateContent,
    required this.downloadUrl,
    required this.downloadPageUrl,
    required this.appSize,
    required this.md5,
  });

  factory AppUpdateData.fromJson(Map<String, dynamic> json) {
    return AppUpdateData(
      platform: json['platform'] ?? "",
      enableUpdateCheck: json['enableUpdateCheck'] ?? false,
      versionCode: json['versionCode'] ?? 0,
      versionName: json['versionName'] ?? "",
      updateTime: json['updateTime'] ?? "",
      updateContent: json['updateContent'] ?? "",
      downloadUrl: json['downloadUrl'] ?? "",
      downloadPageUrl: json['downloadPageUrl'] ?? "",
      appSize: json['appSize'] ?? 0,
      md5: json['md5'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "platform": platform,
    "enableUpdateCheck": enableUpdateCheck,
    "versionCode": versionCode,
    "versionName": versionName,
    "updateTime": updateTime,
    "updateContent": updateContent,
    "downloadUrl": downloadUrl,
    "downloadPageUrl": downloadPageUrl,
    "appSize": appSize,
    "md5": md5,
  };

  @override
  String toString() {
    return 'AppUpdateData{platform: $platform, enableUpdateCheck: $enableUpdateCheck, versionCode: $versionCode, versionName: $versionName, updateTime: $updateTime, updateContent: $updateContent, downloadUrl: $downloadUrl, downloadPageUrl: $downloadPageUrl, appSize: $appSize, md5: $md5}';
  }
}

/// 整个接口返回数据
class AppInfo {
  final String notice;
  final List<AppUpdateData> updateData;

  AppInfo({
    required this.notice,
    required this.updateData,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      notice: json['notice'] ?? "",
      updateData: (json['updateData'] as List? ?? [])
          .map((e) => AppUpdateData.fromJson(e))
          .toList(),
    );
  }

  static AppInfo fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return AppInfo.fromJson(jsonMap);
  }

  Map<String, dynamic> toJson() => {
    "notice": notice,
    "updateData": updateData.map((e) => e.toJson()).toList(),
  };

  @override
  String toString() {
    return 'AppInfo{notice: $notice, updateData: $updateData}';
  }
}