// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cache_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CacheGroup {

// 是否选中
 bool get checked;// 缓存组路径,如果是合集的话就是合集路径(不是某一个缓存路径,而是它们的父目录),如果是单个的话就是单个具体的缓存路径
 String? get path; String? get groupId;// 缓存组标题
 String? get title;// 缓存组副标题
 String? get subTitle;// 缓存组item列表
 List<CacheItem> get cacheItemList; String? get coverPath; String? get coverUrl;
/// Create a copy of CacheGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheGroupCopyWith<CacheGroup> get copyWith => _$CacheGroupCopyWithImpl<CacheGroup>(this as CacheGroup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheGroup&&(identical(other.checked, checked) || other.checked == checked)&&(identical(other.path, path) || other.path == path)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.title, title) || other.title == title)&&(identical(other.subTitle, subTitle) || other.subTitle == subTitle)&&const DeepCollectionEquality().equals(other.cacheItemList, cacheItemList)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl));
}


@override
int get hashCode => Object.hash(runtimeType,checked,path,groupId,title,subTitle,const DeepCollectionEquality().hash(cacheItemList),coverPath,coverUrl);

@override
String toString() {
  return 'CacheGroup(checked: $checked, path: $path, groupId: $groupId, title: $title, subTitle: $subTitle, cacheItemList: $cacheItemList, coverPath: $coverPath, coverUrl: $coverUrl)';
}


}

/// @nodoc
abstract mixin class $CacheGroupCopyWith<$Res>  {
  factory $CacheGroupCopyWith(CacheGroup value, $Res Function(CacheGroup) _then) = _$CacheGroupCopyWithImpl;
@useResult
$Res call({
 bool checked, String? path, String? groupId, String? title, String? subTitle, List<CacheItem> cacheItemList, String? coverPath, String? coverUrl
});




}
/// @nodoc
class _$CacheGroupCopyWithImpl<$Res>
    implements $CacheGroupCopyWith<$Res> {
  _$CacheGroupCopyWithImpl(this._self, this._then);

  final CacheGroup _self;
  final $Res Function(CacheGroup) _then;

/// Create a copy of CacheGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? checked = null,Object? path = freezed,Object? groupId = freezed,Object? title = freezed,Object? subTitle = freezed,Object? cacheItemList = null,Object? coverPath = freezed,Object? coverUrl = freezed,}) {
  return _then(_self.copyWith(
checked: null == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as bool,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subTitle: freezed == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String?,cacheItemList: null == cacheItemList ? _self.cacheItemList : cacheItemList // ignore: cast_nullable_to_non_nullable
as List<CacheItem>,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CacheGroup].
extension CacheGroupPatterns on CacheGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CacheGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CacheGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CacheGroup value)  $default,){
final _that = this;
switch (_that) {
case _CacheGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CacheGroup value)?  $default,){
final _that = this;
switch (_that) {
case _CacheGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool checked,  String? path,  String? groupId,  String? title,  String? subTitle,  List<CacheItem> cacheItemList,  String? coverPath,  String? coverUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CacheGroup() when $default != null:
return $default(_that.checked,_that.path,_that.groupId,_that.title,_that.subTitle,_that.cacheItemList,_that.coverPath,_that.coverUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool checked,  String? path,  String? groupId,  String? title,  String? subTitle,  List<CacheItem> cacheItemList,  String? coverPath,  String? coverUrl)  $default,) {final _that = this;
switch (_that) {
case _CacheGroup():
return $default(_that.checked,_that.path,_that.groupId,_that.title,_that.subTitle,_that.cacheItemList,_that.coverPath,_that.coverUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool checked,  String? path,  String? groupId,  String? title,  String? subTitle,  List<CacheItem> cacheItemList,  String? coverPath,  String? coverUrl)?  $default,) {final _that = this;
switch (_that) {
case _CacheGroup() when $default != null:
return $default(_that.checked,_that.path,_that.groupId,_that.title,_that.subTitle,_that.cacheItemList,_that.coverPath,_that.coverUrl);case _:
  return null;

}
}

}

/// @nodoc


class _CacheGroup extends CacheGroup {
  const _CacheGroup({this.checked = false, this.path, this.groupId, this.title, this.subTitle, final  List<CacheItem> cacheItemList = const [], this.coverPath, this.coverUrl}): _cacheItemList = cacheItemList,super._();
  

// 是否选中
@override@JsonKey() final  bool checked;
// 缓存组路径,如果是合集的话就是合集路径(不是某一个缓存路径,而是它们的父目录),如果是单个的话就是单个具体的缓存路径
@override final  String? path;
@override final  String? groupId;
// 缓存组标题
@override final  String? title;
// 缓存组副标题
@override final  String? subTitle;
// 缓存组item列表
 final  List<CacheItem> _cacheItemList;
// 缓存组item列表
@override@JsonKey() List<CacheItem> get cacheItemList {
  if (_cacheItemList is EqualUnmodifiableListView) return _cacheItemList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cacheItemList);
}

@override final  String? coverPath;
@override final  String? coverUrl;

/// Create a copy of CacheGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CacheGroupCopyWith<_CacheGroup> get copyWith => __$CacheGroupCopyWithImpl<_CacheGroup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CacheGroup&&(identical(other.checked, checked) || other.checked == checked)&&(identical(other.path, path) || other.path == path)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.title, title) || other.title == title)&&(identical(other.subTitle, subTitle) || other.subTitle == subTitle)&&const DeepCollectionEquality().equals(other._cacheItemList, _cacheItemList)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl));
}


@override
int get hashCode => Object.hash(runtimeType,checked,path,groupId,title,subTitle,const DeepCollectionEquality().hash(_cacheItemList),coverPath,coverUrl);

@override
String toString() {
  return 'CacheGroup(checked: $checked, path: $path, groupId: $groupId, title: $title, subTitle: $subTitle, cacheItemList: $cacheItemList, coverPath: $coverPath, coverUrl: $coverUrl)';
}


}

/// @nodoc
abstract mixin class _$CacheGroupCopyWith<$Res> implements $CacheGroupCopyWith<$Res> {
  factory _$CacheGroupCopyWith(_CacheGroup value, $Res Function(_CacheGroup) _then) = __$CacheGroupCopyWithImpl;
@override @useResult
$Res call({
 bool checked, String? path, String? groupId, String? title, String? subTitle, List<CacheItem> cacheItemList, String? coverPath, String? coverUrl
});




}
/// @nodoc
class __$CacheGroupCopyWithImpl<$Res>
    implements _$CacheGroupCopyWith<$Res> {
  __$CacheGroupCopyWithImpl(this._self, this._then);

  final _CacheGroup _self;
  final $Res Function(_CacheGroup) _then;

/// Create a copy of CacheGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? checked = null,Object? path = freezed,Object? groupId = freezed,Object? title = freezed,Object? subTitle = freezed,Object? cacheItemList = null,Object? coverPath = freezed,Object? coverUrl = freezed,}) {
  return _then(_CacheGroup(
checked: null == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as bool,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subTitle: freezed == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String?,cacheItemList: null == cacheItemList ? _self._cacheItemList : cacheItemList // ignore: cast_nullable_to_non_nullable
as List<CacheItem>,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
