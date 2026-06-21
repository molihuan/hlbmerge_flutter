// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppInfo _$AppInfoFromJson(Map<String, dynamic> json) => _AppInfo(
  notice: json['notice'] as String? ?? "",
  updateData:
      (json['updateData'] as List<dynamic>?)
          ?.map((e) => AppUpdateData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$AppInfoToJson(_AppInfo instance) => <String, dynamic>{
  'notice': instance.notice,
  'updateData': instance.updateData,
};

_AppUpdateData _$AppUpdateDataFromJson(Map<String, dynamic> json) =>
    _AppUpdateData(
      platform: json['platform'] as String? ?? "",
      enableUpdateCheck: json['enableUpdateCheck'] as bool? ?? false,
      versionCode: (json['versionCode'] as num?)?.toInt() ?? 1,
      versionName: json['versionName'] as String? ?? "1.0.0",
      updateTime: json['updateTime'] as String? ?? "1999-11-11",
      updateContent: json['updateContent'] as String? ?? "",
      downloadUrl: json['downloadUrl'] as String? ?? "",
      downloadPageUrl: json['downloadPageUrl'] as String? ?? "",
      appSize: (json['appSize'] as num?)?.toInt() ?? 0,
      md5: json['md5'] as String? ?? "",
    );

Map<String, dynamic> _$AppUpdateDataToJson(_AppUpdateData instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'enableUpdateCheck': instance.enableUpdateCheck,
      'versionCode': instance.versionCode,
      'versionName': instance.versionName,
      'updateTime': instance.updateTime,
      'updateContent': instance.updateContent,
      'downloadUrl': instance.downloadUrl,
      'downloadPageUrl': instance.downloadPageUrl,
      'appSize': instance.appSize,
      'md5': instance.md5,
    };
