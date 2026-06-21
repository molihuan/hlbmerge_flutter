import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_info.freezed.dart';

part 'app_info.g.dart';

@freezed
abstract class AppInfo with _$AppInfo {
  const factory AppInfo({
    @Default("") String notice,
    @Default([]) List<AppUpdateData> updateData,
  }) = _AppInfo;

  factory AppInfo.fromJson(Map<String, dynamic> json) =>
      _$AppInfoFromJson(json);
}

@freezed
abstract class AppUpdateData with _$AppUpdateData {
  const factory AppUpdateData({
    @Default("") String platform,
    @Default(false) bool enableUpdateCheck,
    @Default(1) int versionCode,
    @Default("1.0.0") String versionName,
    @Default("1999-11-11") String updateTime,
    @Default("") String updateContent,
    @Default("") String downloadUrl,
    @Default("") String downloadPageUrl,
    @Default(0) int appSize,
    @Default("") String md5,
  }) = _AppUpdateData;

  factory AppUpdateData.fromJson(Map<String, dynamic> json) =>
      _$AppUpdateDataFromJson(json);
}
