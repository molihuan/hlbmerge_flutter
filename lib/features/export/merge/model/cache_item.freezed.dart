// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cache_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CacheItem {

// 是否选中
 bool get checked;// 缓存项路径
 String? get path;// 缓存项父路径
 String? get parentPath;// 弹幕文件路径
 String? get danmakuPath;// json文件路径
 String? get jsonPath;// 音频文件路径
 String? get audioPath;// 视频文件路径
 String? get videoPath;// blv文件列表路径
 List<String>? get blvPathList;// 标题
 String? get title;// 子标题
 String? get subTitle; String? get coverPath; String? get coverUrl;//avid、bvid、cid
// 最早期 B 站视频的 视频 ID、2020 年之前是主要的 ID 形式.示例：av170001 → 170001 就是 avid
 String? get avId;// B 站推出的 新的视频 ID.示例：BV17x411w7KC
 String? get bvId;// 某个视频分 P 的具体内容 ID。示例：一个多 P 视频，可能有多个 cid，每个 P 一个 cid.如果视频有多 P，比如 "P1 开箱"、"P2 测评"，它们 共用同一个 bvid/avid，但是每个分 P 有不同的 cid
 String? get cId;// 缓存组信息
 String? get groupId; String? get groupCoverPath; String? get groupCoverUrl; String? get groupTitle;// 在缓存组中的p(顺序/章节索引)
 int? get p;
/// Create a copy of CacheItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheItemCopyWith<CacheItem> get copyWith => _$CacheItemCopyWithImpl<CacheItem>(this as CacheItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheItem&&(identical(other.checked, checked) || other.checked == checked)&&(identical(other.path, path) || other.path == path)&&(identical(other.parentPath, parentPath) || other.parentPath == parentPath)&&(identical(other.danmakuPath, danmakuPath) || other.danmakuPath == danmakuPath)&&(identical(other.jsonPath, jsonPath) || other.jsonPath == jsonPath)&&(identical(other.audioPath, audioPath) || other.audioPath == audioPath)&&(identical(other.videoPath, videoPath) || other.videoPath == videoPath)&&const DeepCollectionEquality().equals(other.blvPathList, blvPathList)&&(identical(other.title, title) || other.title == title)&&(identical(other.subTitle, subTitle) || other.subTitle == subTitle)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.avId, avId) || other.avId == avId)&&(identical(other.bvId, bvId) || other.bvId == bvId)&&(identical(other.cId, cId) || other.cId == cId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupCoverPath, groupCoverPath) || other.groupCoverPath == groupCoverPath)&&(identical(other.groupCoverUrl, groupCoverUrl) || other.groupCoverUrl == groupCoverUrl)&&(identical(other.groupTitle, groupTitle) || other.groupTitle == groupTitle)&&(identical(other.p, p) || other.p == p));
}


@override
int get hashCode => Object.hashAll([runtimeType,checked,path,parentPath,danmakuPath,jsonPath,audioPath,videoPath,const DeepCollectionEquality().hash(blvPathList),title,subTitle,coverPath,coverUrl,avId,bvId,cId,groupId,groupCoverPath,groupCoverUrl,groupTitle,p]);

@override
String toString() {
  return 'CacheItem(checked: $checked, path: $path, parentPath: $parentPath, danmakuPath: $danmakuPath, jsonPath: $jsonPath, audioPath: $audioPath, videoPath: $videoPath, blvPathList: $blvPathList, title: $title, subTitle: $subTitle, coverPath: $coverPath, coverUrl: $coverUrl, avId: $avId, bvId: $bvId, cId: $cId, groupId: $groupId, groupCoverPath: $groupCoverPath, groupCoverUrl: $groupCoverUrl, groupTitle: $groupTitle, p: $p)';
}


}

/// @nodoc
abstract mixin class $CacheItemCopyWith<$Res>  {
  factory $CacheItemCopyWith(CacheItem value, $Res Function(CacheItem) _then) = _$CacheItemCopyWithImpl;
@useResult
$Res call({
 bool checked, String? path, String? parentPath, String? danmakuPath, String? jsonPath, String? audioPath, String? videoPath, List<String>? blvPathList, String? title, String? subTitle, String? coverPath, String? coverUrl, String? avId, String? bvId, String? cId, String? groupId, String? groupCoverPath, String? groupCoverUrl, String? groupTitle, int? p
});




}
/// @nodoc
class _$CacheItemCopyWithImpl<$Res>
    implements $CacheItemCopyWith<$Res> {
  _$CacheItemCopyWithImpl(this._self, this._then);

  final CacheItem _self;
  final $Res Function(CacheItem) _then;

/// Create a copy of CacheItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? checked = null,Object? path = freezed,Object? parentPath = freezed,Object? danmakuPath = freezed,Object? jsonPath = freezed,Object? audioPath = freezed,Object? videoPath = freezed,Object? blvPathList = freezed,Object? title = freezed,Object? subTitle = freezed,Object? coverPath = freezed,Object? coverUrl = freezed,Object? avId = freezed,Object? bvId = freezed,Object? cId = freezed,Object? groupId = freezed,Object? groupCoverPath = freezed,Object? groupCoverUrl = freezed,Object? groupTitle = freezed,Object? p = freezed,}) {
  return _then(_self.copyWith(
checked: null == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as bool,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,parentPath: freezed == parentPath ? _self.parentPath : parentPath // ignore: cast_nullable_to_non_nullable
as String?,danmakuPath: freezed == danmakuPath ? _self.danmakuPath : danmakuPath // ignore: cast_nullable_to_non_nullable
as String?,jsonPath: freezed == jsonPath ? _self.jsonPath : jsonPath // ignore: cast_nullable_to_non_nullable
as String?,audioPath: freezed == audioPath ? _self.audioPath : audioPath // ignore: cast_nullable_to_non_nullable
as String?,videoPath: freezed == videoPath ? _self.videoPath : videoPath // ignore: cast_nullable_to_non_nullable
as String?,blvPathList: freezed == blvPathList ? _self.blvPathList : blvPathList // ignore: cast_nullable_to_non_nullable
as List<String>?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subTitle: freezed == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,avId: freezed == avId ? _self.avId : avId // ignore: cast_nullable_to_non_nullable
as String?,bvId: freezed == bvId ? _self.bvId : bvId // ignore: cast_nullable_to_non_nullable
as String?,cId: freezed == cId ? _self.cId : cId // ignore: cast_nullable_to_non_nullable
as String?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,groupCoverPath: freezed == groupCoverPath ? _self.groupCoverPath : groupCoverPath // ignore: cast_nullable_to_non_nullable
as String?,groupCoverUrl: freezed == groupCoverUrl ? _self.groupCoverUrl : groupCoverUrl // ignore: cast_nullable_to_non_nullable
as String?,groupTitle: freezed == groupTitle ? _self.groupTitle : groupTitle // ignore: cast_nullable_to_non_nullable
as String?,p: freezed == p ? _self.p : p // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CacheItem].
extension CacheItemPatterns on CacheItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CacheItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CacheItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CacheItem value)  $default,){
final _that = this;
switch (_that) {
case _CacheItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CacheItem value)?  $default,){
final _that = this;
switch (_that) {
case _CacheItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool checked,  String? path,  String? parentPath,  String? danmakuPath,  String? jsonPath,  String? audioPath,  String? videoPath,  List<String>? blvPathList,  String? title,  String? subTitle,  String? coverPath,  String? coverUrl,  String? avId,  String? bvId,  String? cId,  String? groupId,  String? groupCoverPath,  String? groupCoverUrl,  String? groupTitle,  int? p)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CacheItem() when $default != null:
return $default(_that.checked,_that.path,_that.parentPath,_that.danmakuPath,_that.jsonPath,_that.audioPath,_that.videoPath,_that.blvPathList,_that.title,_that.subTitle,_that.coverPath,_that.coverUrl,_that.avId,_that.bvId,_that.cId,_that.groupId,_that.groupCoverPath,_that.groupCoverUrl,_that.groupTitle,_that.p);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool checked,  String? path,  String? parentPath,  String? danmakuPath,  String? jsonPath,  String? audioPath,  String? videoPath,  List<String>? blvPathList,  String? title,  String? subTitle,  String? coverPath,  String? coverUrl,  String? avId,  String? bvId,  String? cId,  String? groupId,  String? groupCoverPath,  String? groupCoverUrl,  String? groupTitle,  int? p)  $default,) {final _that = this;
switch (_that) {
case _CacheItem():
return $default(_that.checked,_that.path,_that.parentPath,_that.danmakuPath,_that.jsonPath,_that.audioPath,_that.videoPath,_that.blvPathList,_that.title,_that.subTitle,_that.coverPath,_that.coverUrl,_that.avId,_that.bvId,_that.cId,_that.groupId,_that.groupCoverPath,_that.groupCoverUrl,_that.groupTitle,_that.p);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool checked,  String? path,  String? parentPath,  String? danmakuPath,  String? jsonPath,  String? audioPath,  String? videoPath,  List<String>? blvPathList,  String? title,  String? subTitle,  String? coverPath,  String? coverUrl,  String? avId,  String? bvId,  String? cId,  String? groupId,  String? groupCoverPath,  String? groupCoverUrl,  String? groupTitle,  int? p)?  $default,) {final _that = this;
switch (_that) {
case _CacheItem() when $default != null:
return $default(_that.checked,_that.path,_that.parentPath,_that.danmakuPath,_that.jsonPath,_that.audioPath,_that.videoPath,_that.blvPathList,_that.title,_that.subTitle,_that.coverPath,_that.coverUrl,_that.avId,_that.bvId,_that.cId,_that.groupId,_that.groupCoverPath,_that.groupCoverUrl,_that.groupTitle,_that.p);case _:
  return null;

}
}

}

/// @nodoc


class _CacheItem extends CacheItem {
  const _CacheItem({this.checked = false, this.path, this.parentPath, this.danmakuPath, this.jsonPath, this.audioPath, this.videoPath, final  List<String>? blvPathList, this.title, this.subTitle, this.coverPath, this.coverUrl, this.avId, this.bvId, this.cId, this.groupId, this.groupCoverPath, this.groupCoverUrl, this.groupTitle, this.p}): _blvPathList = blvPathList,super._();
  

// 是否选中
@override@JsonKey() final  bool checked;
// 缓存项路径
@override final  String? path;
// 缓存项父路径
@override final  String? parentPath;
// 弹幕文件路径
@override final  String? danmakuPath;
// json文件路径
@override final  String? jsonPath;
// 音频文件路径
@override final  String? audioPath;
// 视频文件路径
@override final  String? videoPath;
// blv文件列表路径
 final  List<String>? _blvPathList;
// blv文件列表路径
@override List<String>? get blvPathList {
  final value = _blvPathList;
  if (value == null) return null;
  if (_blvPathList is EqualUnmodifiableListView) return _blvPathList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// 标题
@override final  String? title;
// 子标题
@override final  String? subTitle;
@override final  String? coverPath;
@override final  String? coverUrl;
//avid、bvid、cid
// 最早期 B 站视频的 视频 ID、2020 年之前是主要的 ID 形式.示例：av170001 → 170001 就是 avid
@override final  String? avId;
// B 站推出的 新的视频 ID.示例：BV17x411w7KC
@override final  String? bvId;
// 某个视频分 P 的具体内容 ID。示例：一个多 P 视频，可能有多个 cid，每个 P 一个 cid.如果视频有多 P，比如 "P1 开箱"、"P2 测评"，它们 共用同一个 bvid/avid，但是每个分 P 有不同的 cid
@override final  String? cId;
// 缓存组信息
@override final  String? groupId;
@override final  String? groupCoverPath;
@override final  String? groupCoverUrl;
@override final  String? groupTitle;
// 在缓存组中的p(顺序/章节索引)
@override final  int? p;

/// Create a copy of CacheItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CacheItemCopyWith<_CacheItem> get copyWith => __$CacheItemCopyWithImpl<_CacheItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CacheItem&&(identical(other.checked, checked) || other.checked == checked)&&(identical(other.path, path) || other.path == path)&&(identical(other.parentPath, parentPath) || other.parentPath == parentPath)&&(identical(other.danmakuPath, danmakuPath) || other.danmakuPath == danmakuPath)&&(identical(other.jsonPath, jsonPath) || other.jsonPath == jsonPath)&&(identical(other.audioPath, audioPath) || other.audioPath == audioPath)&&(identical(other.videoPath, videoPath) || other.videoPath == videoPath)&&const DeepCollectionEquality().equals(other._blvPathList, _blvPathList)&&(identical(other.title, title) || other.title == title)&&(identical(other.subTitle, subTitle) || other.subTitle == subTitle)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.avId, avId) || other.avId == avId)&&(identical(other.bvId, bvId) || other.bvId == bvId)&&(identical(other.cId, cId) || other.cId == cId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupCoverPath, groupCoverPath) || other.groupCoverPath == groupCoverPath)&&(identical(other.groupCoverUrl, groupCoverUrl) || other.groupCoverUrl == groupCoverUrl)&&(identical(other.groupTitle, groupTitle) || other.groupTitle == groupTitle)&&(identical(other.p, p) || other.p == p));
}


@override
int get hashCode => Object.hashAll([runtimeType,checked,path,parentPath,danmakuPath,jsonPath,audioPath,videoPath,const DeepCollectionEquality().hash(_blvPathList),title,subTitle,coverPath,coverUrl,avId,bvId,cId,groupId,groupCoverPath,groupCoverUrl,groupTitle,p]);

@override
String toString() {
  return 'CacheItem(checked: $checked, path: $path, parentPath: $parentPath, danmakuPath: $danmakuPath, jsonPath: $jsonPath, audioPath: $audioPath, videoPath: $videoPath, blvPathList: $blvPathList, title: $title, subTitle: $subTitle, coverPath: $coverPath, coverUrl: $coverUrl, avId: $avId, bvId: $bvId, cId: $cId, groupId: $groupId, groupCoverPath: $groupCoverPath, groupCoverUrl: $groupCoverUrl, groupTitle: $groupTitle, p: $p)';
}


}

/// @nodoc
abstract mixin class _$CacheItemCopyWith<$Res> implements $CacheItemCopyWith<$Res> {
  factory _$CacheItemCopyWith(_CacheItem value, $Res Function(_CacheItem) _then) = __$CacheItemCopyWithImpl;
@override @useResult
$Res call({
 bool checked, String? path, String? parentPath, String? danmakuPath, String? jsonPath, String? audioPath, String? videoPath, List<String>? blvPathList, String? title, String? subTitle, String? coverPath, String? coverUrl, String? avId, String? bvId, String? cId, String? groupId, String? groupCoverPath, String? groupCoverUrl, String? groupTitle, int? p
});




}
/// @nodoc
class __$CacheItemCopyWithImpl<$Res>
    implements _$CacheItemCopyWith<$Res> {
  __$CacheItemCopyWithImpl(this._self, this._then);

  final _CacheItem _self;
  final $Res Function(_CacheItem) _then;

/// Create a copy of CacheItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? checked = null,Object? path = freezed,Object? parentPath = freezed,Object? danmakuPath = freezed,Object? jsonPath = freezed,Object? audioPath = freezed,Object? videoPath = freezed,Object? blvPathList = freezed,Object? title = freezed,Object? subTitle = freezed,Object? coverPath = freezed,Object? coverUrl = freezed,Object? avId = freezed,Object? bvId = freezed,Object? cId = freezed,Object? groupId = freezed,Object? groupCoverPath = freezed,Object? groupCoverUrl = freezed,Object? groupTitle = freezed,Object? p = freezed,}) {
  return _then(_CacheItem(
checked: null == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as bool,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,parentPath: freezed == parentPath ? _self.parentPath : parentPath // ignore: cast_nullable_to_non_nullable
as String?,danmakuPath: freezed == danmakuPath ? _self.danmakuPath : danmakuPath // ignore: cast_nullable_to_non_nullable
as String?,jsonPath: freezed == jsonPath ? _self.jsonPath : jsonPath // ignore: cast_nullable_to_non_nullable
as String?,audioPath: freezed == audioPath ? _self.audioPath : audioPath // ignore: cast_nullable_to_non_nullable
as String?,videoPath: freezed == videoPath ? _self.videoPath : videoPath // ignore: cast_nullable_to_non_nullable
as String?,blvPathList: freezed == blvPathList ? _self._blvPathList : blvPathList // ignore: cast_nullable_to_non_nullable
as List<String>?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subTitle: freezed == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,avId: freezed == avId ? _self.avId : avId // ignore: cast_nullable_to_non_nullable
as String?,bvId: freezed == bvId ? _self.bvId : bvId // ignore: cast_nullable_to_non_nullable
as String?,cId: freezed == cId ? _self.cId : cId // ignore: cast_nullable_to_non_nullable
as String?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,groupCoverPath: freezed == groupCoverPath ? _self.groupCoverPath : groupCoverPath // ignore: cast_nullable_to_non_nullable
as String?,groupCoverUrl: freezed == groupCoverUrl ? _self.groupCoverUrl : groupCoverUrl // ignore: cast_nullable_to_non_nullable
as String?,groupTitle: freezed == groupTitle ? _self.groupTitle : groupTitle // ignore: cast_nullable_to_non_nullable
as String?,p: freezed == p ? _self.p : p // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
