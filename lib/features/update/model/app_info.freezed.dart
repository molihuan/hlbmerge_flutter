// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppInfo {

 String get notice; List<AppUpdateData> get updateData;
/// Create a copy of AppInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppInfoCopyWith<AppInfo> get copyWith => _$AppInfoCopyWithImpl<AppInfo>(this as AppInfo, _$identity);

  /// Serializes this AppInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppInfo&&(identical(other.notice, notice) || other.notice == notice)&&const DeepCollectionEquality().equals(other.updateData, updateData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notice,const DeepCollectionEquality().hash(updateData));

@override
String toString() {
  return 'AppInfo(notice: $notice, updateData: $updateData)';
}


}

/// @nodoc
abstract mixin class $AppInfoCopyWith<$Res>  {
  factory $AppInfoCopyWith(AppInfo value, $Res Function(AppInfo) _then) = _$AppInfoCopyWithImpl;
@useResult
$Res call({
 String notice, List<AppUpdateData> updateData
});




}
/// @nodoc
class _$AppInfoCopyWithImpl<$Res>
    implements $AppInfoCopyWith<$Res> {
  _$AppInfoCopyWithImpl(this._self, this._then);

  final AppInfo _self;
  final $Res Function(AppInfo) _then;

/// Create a copy of AppInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notice = null,Object? updateData = null,}) {
  return _then(_self.copyWith(
notice: null == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String,updateData: null == updateData ? _self.updateData : updateData // ignore: cast_nullable_to_non_nullable
as List<AppUpdateData>,
  ));
}

}


/// Adds pattern-matching-related methods to [AppInfo].
extension AppInfoPatterns on AppInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppInfo value)  $default,){
final _that = this;
switch (_that) {
case _AppInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppInfo value)?  $default,){
final _that = this;
switch (_that) {
case _AppInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String notice,  List<AppUpdateData> updateData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppInfo() when $default != null:
return $default(_that.notice,_that.updateData);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String notice,  List<AppUpdateData> updateData)  $default,) {final _that = this;
switch (_that) {
case _AppInfo():
return $default(_that.notice,_that.updateData);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String notice,  List<AppUpdateData> updateData)?  $default,) {final _that = this;
switch (_that) {
case _AppInfo() when $default != null:
return $default(_that.notice,_that.updateData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppInfo implements AppInfo {
  const _AppInfo({this.notice = "", final  List<AppUpdateData> updateData = const []}): _updateData = updateData;
  factory _AppInfo.fromJson(Map<String, dynamic> json) => _$AppInfoFromJson(json);

@override@JsonKey() final  String notice;
 final  List<AppUpdateData> _updateData;
@override@JsonKey() List<AppUpdateData> get updateData {
  if (_updateData is EqualUnmodifiableListView) return _updateData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_updateData);
}


/// Create a copy of AppInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppInfoCopyWith<_AppInfo> get copyWith => __$AppInfoCopyWithImpl<_AppInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppInfo&&(identical(other.notice, notice) || other.notice == notice)&&const DeepCollectionEquality().equals(other._updateData, _updateData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notice,const DeepCollectionEquality().hash(_updateData));

@override
String toString() {
  return 'AppInfo(notice: $notice, updateData: $updateData)';
}


}

/// @nodoc
abstract mixin class _$AppInfoCopyWith<$Res> implements $AppInfoCopyWith<$Res> {
  factory _$AppInfoCopyWith(_AppInfo value, $Res Function(_AppInfo) _then) = __$AppInfoCopyWithImpl;
@override @useResult
$Res call({
 String notice, List<AppUpdateData> updateData
});




}
/// @nodoc
class __$AppInfoCopyWithImpl<$Res>
    implements _$AppInfoCopyWith<$Res> {
  __$AppInfoCopyWithImpl(this._self, this._then);

  final _AppInfo _self;
  final $Res Function(_AppInfo) _then;

/// Create a copy of AppInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notice = null,Object? updateData = null,}) {
  return _then(_AppInfo(
notice: null == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String,updateData: null == updateData ? _self._updateData : updateData // ignore: cast_nullable_to_non_nullable
as List<AppUpdateData>,
  ));
}


}


/// @nodoc
mixin _$AppUpdateData {

 String get platform; bool get enableUpdateCheck; int get versionCode; String get versionName; String get updateTime; String get updateContent; String get downloadUrl; String get downloadPageUrl; int get appSize; String get md5;
/// Create a copy of AppUpdateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUpdateDataCopyWith<AppUpdateData> get copyWith => _$AppUpdateDataCopyWithImpl<AppUpdateData>(this as AppUpdateData, _$identity);

  /// Serializes this AppUpdateData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdateData&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.enableUpdateCheck, enableUpdateCheck) || other.enableUpdateCheck == enableUpdateCheck)&&(identical(other.versionCode, versionCode) || other.versionCode == versionCode)&&(identical(other.versionName, versionName) || other.versionName == versionName)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.updateContent, updateContent) || other.updateContent == updateContent)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.downloadPageUrl, downloadPageUrl) || other.downloadPageUrl == downloadPageUrl)&&(identical(other.appSize, appSize) || other.appSize == appSize)&&(identical(other.md5, md5) || other.md5 == md5));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,platform,enableUpdateCheck,versionCode,versionName,updateTime,updateContent,downloadUrl,downloadPageUrl,appSize,md5);

@override
String toString() {
  return 'AppUpdateData(platform: $platform, enableUpdateCheck: $enableUpdateCheck, versionCode: $versionCode, versionName: $versionName, updateTime: $updateTime, updateContent: $updateContent, downloadUrl: $downloadUrl, downloadPageUrl: $downloadPageUrl, appSize: $appSize, md5: $md5)';
}


}

/// @nodoc
abstract mixin class $AppUpdateDataCopyWith<$Res>  {
  factory $AppUpdateDataCopyWith(AppUpdateData value, $Res Function(AppUpdateData) _then) = _$AppUpdateDataCopyWithImpl;
@useResult
$Res call({
 String platform, bool enableUpdateCheck, int versionCode, String versionName, String updateTime, String updateContent, String downloadUrl, String downloadPageUrl, int appSize, String md5
});




}
/// @nodoc
class _$AppUpdateDataCopyWithImpl<$Res>
    implements $AppUpdateDataCopyWith<$Res> {
  _$AppUpdateDataCopyWithImpl(this._self, this._then);

  final AppUpdateData _self;
  final $Res Function(AppUpdateData) _then;

/// Create a copy of AppUpdateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? platform = null,Object? enableUpdateCheck = null,Object? versionCode = null,Object? versionName = null,Object? updateTime = null,Object? updateContent = null,Object? downloadUrl = null,Object? downloadPageUrl = null,Object? appSize = null,Object? md5 = null,}) {
  return _then(_self.copyWith(
platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,enableUpdateCheck: null == enableUpdateCheck ? _self.enableUpdateCheck : enableUpdateCheck // ignore: cast_nullable_to_non_nullable
as bool,versionCode: null == versionCode ? _self.versionCode : versionCode // ignore: cast_nullable_to_non_nullable
as int,versionName: null == versionName ? _self.versionName : versionName // ignore: cast_nullable_to_non_nullable
as String,updateTime: null == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String,updateContent: null == updateContent ? _self.updateContent : updateContent // ignore: cast_nullable_to_non_nullable
as String,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,downloadPageUrl: null == downloadPageUrl ? _self.downloadPageUrl : downloadPageUrl // ignore: cast_nullable_to_non_nullable
as String,appSize: null == appSize ? _self.appSize : appSize // ignore: cast_nullable_to_non_nullable
as int,md5: null == md5 ? _self.md5 : md5 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUpdateData].
extension AppUpdateDataPatterns on AppUpdateData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUpdateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUpdateData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUpdateData value)  $default,){
final _that = this;
switch (_that) {
case _AppUpdateData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUpdateData value)?  $default,){
final _that = this;
switch (_that) {
case _AppUpdateData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String platform,  bool enableUpdateCheck,  int versionCode,  String versionName,  String updateTime,  String updateContent,  String downloadUrl,  String downloadPageUrl,  int appSize,  String md5)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUpdateData() when $default != null:
return $default(_that.platform,_that.enableUpdateCheck,_that.versionCode,_that.versionName,_that.updateTime,_that.updateContent,_that.downloadUrl,_that.downloadPageUrl,_that.appSize,_that.md5);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String platform,  bool enableUpdateCheck,  int versionCode,  String versionName,  String updateTime,  String updateContent,  String downloadUrl,  String downloadPageUrl,  int appSize,  String md5)  $default,) {final _that = this;
switch (_that) {
case _AppUpdateData():
return $default(_that.platform,_that.enableUpdateCheck,_that.versionCode,_that.versionName,_that.updateTime,_that.updateContent,_that.downloadUrl,_that.downloadPageUrl,_that.appSize,_that.md5);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String platform,  bool enableUpdateCheck,  int versionCode,  String versionName,  String updateTime,  String updateContent,  String downloadUrl,  String downloadPageUrl,  int appSize,  String md5)?  $default,) {final _that = this;
switch (_that) {
case _AppUpdateData() when $default != null:
return $default(_that.platform,_that.enableUpdateCheck,_that.versionCode,_that.versionName,_that.updateTime,_that.updateContent,_that.downloadUrl,_that.downloadPageUrl,_that.appSize,_that.md5);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUpdateData implements AppUpdateData {
  const _AppUpdateData({this.platform = "", this.enableUpdateCheck = false, this.versionCode = 1, this.versionName = "1.0.0", this.updateTime = "1999-11-11", this.updateContent = "", this.downloadUrl = "", this.downloadPageUrl = "", this.appSize = 0, this.md5 = ""});
  factory _AppUpdateData.fromJson(Map<String, dynamic> json) => _$AppUpdateDataFromJson(json);

@override@JsonKey() final  String platform;
@override@JsonKey() final  bool enableUpdateCheck;
@override@JsonKey() final  int versionCode;
@override@JsonKey() final  String versionName;
@override@JsonKey() final  String updateTime;
@override@JsonKey() final  String updateContent;
@override@JsonKey() final  String downloadUrl;
@override@JsonKey() final  String downloadPageUrl;
@override@JsonKey() final  int appSize;
@override@JsonKey() final  String md5;

/// Create a copy of AppUpdateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUpdateDataCopyWith<_AppUpdateData> get copyWith => __$AppUpdateDataCopyWithImpl<_AppUpdateData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUpdateDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUpdateData&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.enableUpdateCheck, enableUpdateCheck) || other.enableUpdateCheck == enableUpdateCheck)&&(identical(other.versionCode, versionCode) || other.versionCode == versionCode)&&(identical(other.versionName, versionName) || other.versionName == versionName)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.updateContent, updateContent) || other.updateContent == updateContent)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.downloadPageUrl, downloadPageUrl) || other.downloadPageUrl == downloadPageUrl)&&(identical(other.appSize, appSize) || other.appSize == appSize)&&(identical(other.md5, md5) || other.md5 == md5));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,platform,enableUpdateCheck,versionCode,versionName,updateTime,updateContent,downloadUrl,downloadPageUrl,appSize,md5);

@override
String toString() {
  return 'AppUpdateData(platform: $platform, enableUpdateCheck: $enableUpdateCheck, versionCode: $versionCode, versionName: $versionName, updateTime: $updateTime, updateContent: $updateContent, downloadUrl: $downloadUrl, downloadPageUrl: $downloadPageUrl, appSize: $appSize, md5: $md5)';
}


}

/// @nodoc
abstract mixin class _$AppUpdateDataCopyWith<$Res> implements $AppUpdateDataCopyWith<$Res> {
  factory _$AppUpdateDataCopyWith(_AppUpdateData value, $Res Function(_AppUpdateData) _then) = __$AppUpdateDataCopyWithImpl;
@override @useResult
$Res call({
 String platform, bool enableUpdateCheck, int versionCode, String versionName, String updateTime, String updateContent, String downloadUrl, String downloadPageUrl, int appSize, String md5
});




}
/// @nodoc
class __$AppUpdateDataCopyWithImpl<$Res>
    implements _$AppUpdateDataCopyWith<$Res> {
  __$AppUpdateDataCopyWithImpl(this._self, this._then);

  final _AppUpdateData _self;
  final $Res Function(_AppUpdateData) _then;

/// Create a copy of AppUpdateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? platform = null,Object? enableUpdateCheck = null,Object? versionCode = null,Object? versionName = null,Object? updateTime = null,Object? updateContent = null,Object? downloadUrl = null,Object? downloadPageUrl = null,Object? appSize = null,Object? md5 = null,}) {
  return _then(_AppUpdateData(
platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,enableUpdateCheck: null == enableUpdateCheck ? _self.enableUpdateCheck : enableUpdateCheck // ignore: cast_nullable_to_non_nullable
as bool,versionCode: null == versionCode ? _self.versionCode : versionCode // ignore: cast_nullable_to_non_nullable
as int,versionName: null == versionName ? _self.versionName : versionName // ignore: cast_nullable_to_non_nullable
as String,updateTime: null == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String,updateContent: null == updateContent ? _self.updateContent : updateContent // ignore: cast_nullable_to_non_nullable
as String,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,downloadPageUrl: null == downloadPageUrl ? _self.downloadPageUrl : downloadPageUrl // ignore: cast_nullable_to_non_nullable
as String,appSize: null == appSize ? _self.appSize : appSize // ignore: cast_nullable_to_non_nullable
as int,md5: null == md5 ? _self.md5 : md5 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
