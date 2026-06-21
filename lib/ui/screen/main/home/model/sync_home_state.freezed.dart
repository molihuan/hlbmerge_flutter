// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncHomeState {

 CachePlatform get cachePlatform;//导出模式
 OutputFileMode get outputFileMode; bool get checkMultiSelectMode;// 缓存项是否全选
 bool get checkAllCacheItemList;//输入框是否拖拽中
 bool get checkTextFieldDragging;//开启搜索
 bool get checkSearch;//搜索值
 String get searchValue; String? get errMsg;
/// Create a copy of SyncHomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncHomeStateCopyWith<SyncHomeState> get copyWith => _$SyncHomeStateCopyWithImpl<SyncHomeState>(this as SyncHomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncHomeState&&(identical(other.cachePlatform, cachePlatform) || other.cachePlatform == cachePlatform)&&(identical(other.outputFileMode, outputFileMode) || other.outputFileMode == outputFileMode)&&(identical(other.checkMultiSelectMode, checkMultiSelectMode) || other.checkMultiSelectMode == checkMultiSelectMode)&&(identical(other.checkAllCacheItemList, checkAllCacheItemList) || other.checkAllCacheItemList == checkAllCacheItemList)&&(identical(other.checkTextFieldDragging, checkTextFieldDragging) || other.checkTextFieldDragging == checkTextFieldDragging)&&(identical(other.checkSearch, checkSearch) || other.checkSearch == checkSearch)&&(identical(other.searchValue, searchValue) || other.searchValue == searchValue)&&(identical(other.errMsg, errMsg) || other.errMsg == errMsg));
}


@override
int get hashCode => Object.hash(runtimeType,cachePlatform,outputFileMode,checkMultiSelectMode,checkAllCacheItemList,checkTextFieldDragging,checkSearch,searchValue,errMsg);

@override
String toString() {
  return 'SyncHomeState(cachePlatform: $cachePlatform, outputFileMode: $outputFileMode, checkMultiSelectMode: $checkMultiSelectMode, checkAllCacheItemList: $checkAllCacheItemList, checkTextFieldDragging: $checkTextFieldDragging, checkSearch: $checkSearch, searchValue: $searchValue, errMsg: $errMsg)';
}


}

/// @nodoc
abstract mixin class $SyncHomeStateCopyWith<$Res>  {
  factory $SyncHomeStateCopyWith(SyncHomeState value, $Res Function(SyncHomeState) _then) = _$SyncHomeStateCopyWithImpl;
@useResult
$Res call({
 CachePlatform cachePlatform, OutputFileMode outputFileMode, bool checkMultiSelectMode, bool checkAllCacheItemList, bool checkTextFieldDragging, bool checkSearch, String searchValue, String? errMsg
});




}
/// @nodoc
class _$SyncHomeStateCopyWithImpl<$Res>
    implements $SyncHomeStateCopyWith<$Res> {
  _$SyncHomeStateCopyWithImpl(this._self, this._then);

  final SyncHomeState _self;
  final $Res Function(SyncHomeState) _then;

/// Create a copy of SyncHomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cachePlatform = null,Object? outputFileMode = null,Object? checkMultiSelectMode = null,Object? checkAllCacheItemList = null,Object? checkTextFieldDragging = null,Object? checkSearch = null,Object? searchValue = null,Object? errMsg = freezed,}) {
  return _then(_self.copyWith(
cachePlatform: null == cachePlatform ? _self.cachePlatform : cachePlatform // ignore: cast_nullable_to_non_nullable
as CachePlatform,outputFileMode: null == outputFileMode ? _self.outputFileMode : outputFileMode // ignore: cast_nullable_to_non_nullable
as OutputFileMode,checkMultiSelectMode: null == checkMultiSelectMode ? _self.checkMultiSelectMode : checkMultiSelectMode // ignore: cast_nullable_to_non_nullable
as bool,checkAllCacheItemList: null == checkAllCacheItemList ? _self.checkAllCacheItemList : checkAllCacheItemList // ignore: cast_nullable_to_non_nullable
as bool,checkTextFieldDragging: null == checkTextFieldDragging ? _self.checkTextFieldDragging : checkTextFieldDragging // ignore: cast_nullable_to_non_nullable
as bool,checkSearch: null == checkSearch ? _self.checkSearch : checkSearch // ignore: cast_nullable_to_non_nullable
as bool,searchValue: null == searchValue ? _self.searchValue : searchValue // ignore: cast_nullable_to_non_nullable
as String,errMsg: freezed == errMsg ? _self.errMsg : errMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncHomeState].
extension SyncHomeStatePatterns on SyncHomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncHomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncHomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncHomeState value)  $default,){
final _that = this;
switch (_that) {
case _SyncHomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncHomeState value)?  $default,){
final _that = this;
switch (_that) {
case _SyncHomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CachePlatform cachePlatform,  OutputFileMode outputFileMode,  bool checkMultiSelectMode,  bool checkAllCacheItemList,  bool checkTextFieldDragging,  bool checkSearch,  String searchValue,  String? errMsg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncHomeState() when $default != null:
return $default(_that.cachePlatform,_that.outputFileMode,_that.checkMultiSelectMode,_that.checkAllCacheItemList,_that.checkTextFieldDragging,_that.checkSearch,_that.searchValue,_that.errMsg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CachePlatform cachePlatform,  OutputFileMode outputFileMode,  bool checkMultiSelectMode,  bool checkAllCacheItemList,  bool checkTextFieldDragging,  bool checkSearch,  String searchValue,  String? errMsg)  $default,) {final _that = this;
switch (_that) {
case _SyncHomeState():
return $default(_that.cachePlatform,_that.outputFileMode,_that.checkMultiSelectMode,_that.checkAllCacheItemList,_that.checkTextFieldDragging,_that.checkSearch,_that.searchValue,_that.errMsg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CachePlatform cachePlatform,  OutputFileMode outputFileMode,  bool checkMultiSelectMode,  bool checkAllCacheItemList,  bool checkTextFieldDragging,  bool checkSearch,  String searchValue,  String? errMsg)?  $default,) {final _that = this;
switch (_that) {
case _SyncHomeState() when $default != null:
return $default(_that.cachePlatform,_that.outputFileMode,_that.checkMultiSelectMode,_that.checkAllCacheItemList,_that.checkTextFieldDragging,_that.checkSearch,_that.searchValue,_that.errMsg);case _:
  return null;

}
}

}

/// @nodoc


class _SyncHomeState extends SyncHomeState {
  const _SyncHomeState({this.cachePlatform = CachePlatform.android, this.outputFileMode = OutputFileMode.all, this.checkMultiSelectMode = false, this.checkAllCacheItemList = false, this.checkTextFieldDragging = false, this.checkSearch = false, this.searchValue = '', this.errMsg}): super._();
  

@override@JsonKey() final  CachePlatform cachePlatform;
//导出模式
@override@JsonKey() final  OutputFileMode outputFileMode;
@override@JsonKey() final  bool checkMultiSelectMode;
// 缓存项是否全选
@override@JsonKey() final  bool checkAllCacheItemList;
//输入框是否拖拽中
@override@JsonKey() final  bool checkTextFieldDragging;
//开启搜索
@override@JsonKey() final  bool checkSearch;
//搜索值
@override@JsonKey() final  String searchValue;
@override final  String? errMsg;

/// Create a copy of SyncHomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncHomeStateCopyWith<_SyncHomeState> get copyWith => __$SyncHomeStateCopyWithImpl<_SyncHomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncHomeState&&(identical(other.cachePlatform, cachePlatform) || other.cachePlatform == cachePlatform)&&(identical(other.outputFileMode, outputFileMode) || other.outputFileMode == outputFileMode)&&(identical(other.checkMultiSelectMode, checkMultiSelectMode) || other.checkMultiSelectMode == checkMultiSelectMode)&&(identical(other.checkAllCacheItemList, checkAllCacheItemList) || other.checkAllCacheItemList == checkAllCacheItemList)&&(identical(other.checkTextFieldDragging, checkTextFieldDragging) || other.checkTextFieldDragging == checkTextFieldDragging)&&(identical(other.checkSearch, checkSearch) || other.checkSearch == checkSearch)&&(identical(other.searchValue, searchValue) || other.searchValue == searchValue)&&(identical(other.errMsg, errMsg) || other.errMsg == errMsg));
}


@override
int get hashCode => Object.hash(runtimeType,cachePlatform,outputFileMode,checkMultiSelectMode,checkAllCacheItemList,checkTextFieldDragging,checkSearch,searchValue,errMsg);

@override
String toString() {
  return 'SyncHomeState(cachePlatform: $cachePlatform, outputFileMode: $outputFileMode, checkMultiSelectMode: $checkMultiSelectMode, checkAllCacheItemList: $checkAllCacheItemList, checkTextFieldDragging: $checkTextFieldDragging, checkSearch: $checkSearch, searchValue: $searchValue, errMsg: $errMsg)';
}


}

/// @nodoc
abstract mixin class _$SyncHomeStateCopyWith<$Res> implements $SyncHomeStateCopyWith<$Res> {
  factory _$SyncHomeStateCopyWith(_SyncHomeState value, $Res Function(_SyncHomeState) _then) = __$SyncHomeStateCopyWithImpl;
@override @useResult
$Res call({
 CachePlatform cachePlatform, OutputFileMode outputFileMode, bool checkMultiSelectMode, bool checkAllCacheItemList, bool checkTextFieldDragging, bool checkSearch, String searchValue, String? errMsg
});




}
/// @nodoc
class __$SyncHomeStateCopyWithImpl<$Res>
    implements _$SyncHomeStateCopyWith<$Res> {
  __$SyncHomeStateCopyWithImpl(this._self, this._then);

  final _SyncHomeState _self;
  final $Res Function(_SyncHomeState) _then;

/// Create a copy of SyncHomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cachePlatform = null,Object? outputFileMode = null,Object? checkMultiSelectMode = null,Object? checkAllCacheItemList = null,Object? checkTextFieldDragging = null,Object? checkSearch = null,Object? searchValue = null,Object? errMsg = freezed,}) {
  return _then(_SyncHomeState(
cachePlatform: null == cachePlatform ? _self.cachePlatform : cachePlatform // ignore: cast_nullable_to_non_nullable
as CachePlatform,outputFileMode: null == outputFileMode ? _self.outputFileMode : outputFileMode // ignore: cast_nullable_to_non_nullable
as OutputFileMode,checkMultiSelectMode: null == checkMultiSelectMode ? _self.checkMultiSelectMode : checkMultiSelectMode // ignore: cast_nullable_to_non_nullable
as bool,checkAllCacheItemList: null == checkAllCacheItemList ? _self.checkAllCacheItemList : checkAllCacheItemList // ignore: cast_nullable_to_non_nullable
as bool,checkTextFieldDragging: null == checkTextFieldDragging ? _self.checkTextFieldDragging : checkTextFieldDragging // ignore: cast_nullable_to_non_nullable
as bool,checkSearch: null == checkSearch ? _self.checkSearch : checkSearch // ignore: cast_nullable_to_non_nullable
as bool,searchValue: null == searchValue ? _self.searchValue : searchValue // ignore: cast_nullable_to_non_nullable
as String,errMsg: freezed == errMsg ? _self.errMsg : errMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
