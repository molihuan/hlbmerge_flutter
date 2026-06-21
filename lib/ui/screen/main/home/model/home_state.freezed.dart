// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

//输入缓存文件夹路径
 String get inputCacheDirPath; List<CacheGroup> get cacheGroupList;// 是否有权限
 bool get hasPermission; String? get errMsg;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.inputCacheDirPath, inputCacheDirPath) || other.inputCacheDirPath == inputCacheDirPath)&&const DeepCollectionEquality().equals(other.cacheGroupList, cacheGroupList)&&(identical(other.hasPermission, hasPermission) || other.hasPermission == hasPermission)&&(identical(other.errMsg, errMsg) || other.errMsg == errMsg));
}


@override
int get hashCode => Object.hash(runtimeType,inputCacheDirPath,const DeepCollectionEquality().hash(cacheGroupList),hasPermission,errMsg);

@override
String toString() {
  return 'HomeState(inputCacheDirPath: $inputCacheDirPath, cacheGroupList: $cacheGroupList, hasPermission: $hasPermission, errMsg: $errMsg)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 String inputCacheDirPath, List<CacheGroup> cacheGroupList, bool hasPermission, String? errMsg
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inputCacheDirPath = null,Object? cacheGroupList = null,Object? hasPermission = null,Object? errMsg = freezed,}) {
  return _then(_self.copyWith(
inputCacheDirPath: null == inputCacheDirPath ? _self.inputCacheDirPath : inputCacheDirPath // ignore: cast_nullable_to_non_nullable
as String,cacheGroupList: null == cacheGroupList ? _self.cacheGroupList : cacheGroupList // ignore: cast_nullable_to_non_nullable
as List<CacheGroup>,hasPermission: null == hasPermission ? _self.hasPermission : hasPermission // ignore: cast_nullable_to_non_nullable
as bool,errMsg: freezed == errMsg ? _self.errMsg : errMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String inputCacheDirPath,  List<CacheGroup> cacheGroupList,  bool hasPermission,  String? errMsg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.inputCacheDirPath,_that.cacheGroupList,_that.hasPermission,_that.errMsg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String inputCacheDirPath,  List<CacheGroup> cacheGroupList,  bool hasPermission,  String? errMsg)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.inputCacheDirPath,_that.cacheGroupList,_that.hasPermission,_that.errMsg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String inputCacheDirPath,  List<CacheGroup> cacheGroupList,  bool hasPermission,  String? errMsg)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.inputCacheDirPath,_that.cacheGroupList,_that.hasPermission,_that.errMsg);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState extends HomeState {
  const _HomeState({this.inputCacheDirPath = "", final  List<CacheGroup> cacheGroupList = const [], this.hasPermission = false, this.errMsg}): _cacheGroupList = cacheGroupList,super._();
  

//输入缓存文件夹路径
@override@JsonKey() final  String inputCacheDirPath;
 final  List<CacheGroup> _cacheGroupList;
@override@JsonKey() List<CacheGroup> get cacheGroupList {
  if (_cacheGroupList is EqualUnmodifiableListView) return _cacheGroupList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cacheGroupList);
}

// 是否有权限
@override@JsonKey() final  bool hasPermission;
@override final  String? errMsg;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.inputCacheDirPath, inputCacheDirPath) || other.inputCacheDirPath == inputCacheDirPath)&&const DeepCollectionEquality().equals(other._cacheGroupList, _cacheGroupList)&&(identical(other.hasPermission, hasPermission) || other.hasPermission == hasPermission)&&(identical(other.errMsg, errMsg) || other.errMsg == errMsg));
}


@override
int get hashCode => Object.hash(runtimeType,inputCacheDirPath,const DeepCollectionEquality().hash(_cacheGroupList),hasPermission,errMsg);

@override
String toString() {
  return 'HomeState(inputCacheDirPath: $inputCacheDirPath, cacheGroupList: $cacheGroupList, hasPermission: $hasPermission, errMsg: $errMsg)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 String inputCacheDirPath, List<CacheGroup> cacheGroupList, bool hasPermission, String? errMsg
});




}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inputCacheDirPath = null,Object? cacheGroupList = null,Object? hasPermission = null,Object? errMsg = freezed,}) {
  return _then(_HomeState(
inputCacheDirPath: null == inputCacheDirPath ? _self.inputCacheDirPath : inputCacheDirPath // ignore: cast_nullable_to_non_nullable
as String,cacheGroupList: null == cacheGroupList ? _self._cacheGroupList : cacheGroupList // ignore: cast_nullable_to_non_nullable
as List<CacheGroup>,hasPermission: null == hasPermission ? _self.hasPermission : hasPermission // ignore: cast_nullable_to_non_nullable
as bool,errMsg: freezed == errMsg ? _self.errMsg : errMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
