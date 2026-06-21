// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_preset_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncPresetState {

//是否单一输出目录
 bool get checkSingleOutputPath;//导出时添加序号
 bool get checkExportAddIndex;//导出弹幕文件
 bool get checkExportDanmakuFile; String? get errMsg;
/// Create a copy of SyncPresetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncPresetStateCopyWith<SyncPresetState> get copyWith => _$SyncPresetStateCopyWithImpl<SyncPresetState>(this as SyncPresetState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncPresetState&&(identical(other.checkSingleOutputPath, checkSingleOutputPath) || other.checkSingleOutputPath == checkSingleOutputPath)&&(identical(other.checkExportAddIndex, checkExportAddIndex) || other.checkExportAddIndex == checkExportAddIndex)&&(identical(other.checkExportDanmakuFile, checkExportDanmakuFile) || other.checkExportDanmakuFile == checkExportDanmakuFile)&&(identical(other.errMsg, errMsg) || other.errMsg == errMsg));
}


@override
int get hashCode => Object.hash(runtimeType,checkSingleOutputPath,checkExportAddIndex,checkExportDanmakuFile,errMsg);

@override
String toString() {
  return 'SyncPresetState(checkSingleOutputPath: $checkSingleOutputPath, checkExportAddIndex: $checkExportAddIndex, checkExportDanmakuFile: $checkExportDanmakuFile, errMsg: $errMsg)';
}


}

/// @nodoc
abstract mixin class $SyncPresetStateCopyWith<$Res>  {
  factory $SyncPresetStateCopyWith(SyncPresetState value, $Res Function(SyncPresetState) _then) = _$SyncPresetStateCopyWithImpl;
@useResult
$Res call({
 bool checkSingleOutputPath, bool checkExportAddIndex, bool checkExportDanmakuFile, String? errMsg
});




}
/// @nodoc
class _$SyncPresetStateCopyWithImpl<$Res>
    implements $SyncPresetStateCopyWith<$Res> {
  _$SyncPresetStateCopyWithImpl(this._self, this._then);

  final SyncPresetState _self;
  final $Res Function(SyncPresetState) _then;

/// Create a copy of SyncPresetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? checkSingleOutputPath = null,Object? checkExportAddIndex = null,Object? checkExportDanmakuFile = null,Object? errMsg = freezed,}) {
  return _then(_self.copyWith(
checkSingleOutputPath: null == checkSingleOutputPath ? _self.checkSingleOutputPath : checkSingleOutputPath // ignore: cast_nullable_to_non_nullable
as bool,checkExportAddIndex: null == checkExportAddIndex ? _self.checkExportAddIndex : checkExportAddIndex // ignore: cast_nullable_to_non_nullable
as bool,checkExportDanmakuFile: null == checkExportDanmakuFile ? _self.checkExportDanmakuFile : checkExportDanmakuFile // ignore: cast_nullable_to_non_nullable
as bool,errMsg: freezed == errMsg ? _self.errMsg : errMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncPresetState].
extension SyncPresetStatePatterns on SyncPresetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncPresetState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncPresetState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncPresetState value)  $default,){
final _that = this;
switch (_that) {
case _SyncPresetState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncPresetState value)?  $default,){
final _that = this;
switch (_that) {
case _SyncPresetState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool checkSingleOutputPath,  bool checkExportAddIndex,  bool checkExportDanmakuFile,  String? errMsg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncPresetState() when $default != null:
return $default(_that.checkSingleOutputPath,_that.checkExportAddIndex,_that.checkExportDanmakuFile,_that.errMsg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool checkSingleOutputPath,  bool checkExportAddIndex,  bool checkExportDanmakuFile,  String? errMsg)  $default,) {final _that = this;
switch (_that) {
case _SyncPresetState():
return $default(_that.checkSingleOutputPath,_that.checkExportAddIndex,_that.checkExportDanmakuFile,_that.errMsg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool checkSingleOutputPath,  bool checkExportAddIndex,  bool checkExportDanmakuFile,  String? errMsg)?  $default,) {final _that = this;
switch (_that) {
case _SyncPresetState() when $default != null:
return $default(_that.checkSingleOutputPath,_that.checkExportAddIndex,_that.checkExportDanmakuFile,_that.errMsg);case _:
  return null;

}
}

}

/// @nodoc


class _SyncPresetState extends SyncPresetState {
  const _SyncPresetState({this.checkSingleOutputPath = false, this.checkExportAddIndex = false, this.checkExportDanmakuFile = false, this.errMsg}): super._();
  

//是否单一输出目录
@override@JsonKey() final  bool checkSingleOutputPath;
//导出时添加序号
@override@JsonKey() final  bool checkExportAddIndex;
//导出弹幕文件
@override@JsonKey() final  bool checkExportDanmakuFile;
@override final  String? errMsg;

/// Create a copy of SyncPresetState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncPresetStateCopyWith<_SyncPresetState> get copyWith => __$SyncPresetStateCopyWithImpl<_SyncPresetState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncPresetState&&(identical(other.checkSingleOutputPath, checkSingleOutputPath) || other.checkSingleOutputPath == checkSingleOutputPath)&&(identical(other.checkExportAddIndex, checkExportAddIndex) || other.checkExportAddIndex == checkExportAddIndex)&&(identical(other.checkExportDanmakuFile, checkExportDanmakuFile) || other.checkExportDanmakuFile == checkExportDanmakuFile)&&(identical(other.errMsg, errMsg) || other.errMsg == errMsg));
}


@override
int get hashCode => Object.hash(runtimeType,checkSingleOutputPath,checkExportAddIndex,checkExportDanmakuFile,errMsg);

@override
String toString() {
  return 'SyncPresetState(checkSingleOutputPath: $checkSingleOutputPath, checkExportAddIndex: $checkExportAddIndex, checkExportDanmakuFile: $checkExportDanmakuFile, errMsg: $errMsg)';
}


}

/// @nodoc
abstract mixin class _$SyncPresetStateCopyWith<$Res> implements $SyncPresetStateCopyWith<$Res> {
  factory _$SyncPresetStateCopyWith(_SyncPresetState value, $Res Function(_SyncPresetState) _then) = __$SyncPresetStateCopyWithImpl;
@override @useResult
$Res call({
 bool checkSingleOutputPath, bool checkExportAddIndex, bool checkExportDanmakuFile, String? errMsg
});




}
/// @nodoc
class __$SyncPresetStateCopyWithImpl<$Res>
    implements _$SyncPresetStateCopyWith<$Res> {
  __$SyncPresetStateCopyWithImpl(this._self, this._then);

  final _SyncPresetState _self;
  final $Res Function(_SyncPresetState) _then;

/// Create a copy of SyncPresetState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? checkSingleOutputPath = null,Object? checkExportAddIndex = null,Object? checkExportDanmakuFile = null,Object? errMsg = freezed,}) {
  return _then(_SyncPresetState(
checkSingleOutputPath: null == checkSingleOutputPath ? _self.checkSingleOutputPath : checkSingleOutputPath // ignore: cast_nullable_to_non_nullable
as bool,checkExportAddIndex: null == checkExportAddIndex ? _self.checkExportAddIndex : checkExportAddIndex // ignore: cast_nullable_to_non_nullable
as bool,checkExportDanmakuFile: null == checkExportDanmakuFile ? _self.checkExportDanmakuFile : checkExportDanmakuFile // ignore: cast_nullable_to_non_nullable
as bool,errMsg: freezed == errMsg ? _self.errMsg : errMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
