// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preset_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PresetState {

// 输出目录
 String? get outputDirPath; String? get errMsg;
/// Create a copy of PresetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresetStateCopyWith<PresetState> get copyWith => _$PresetStateCopyWithImpl<PresetState>(this as PresetState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresetState&&(identical(other.outputDirPath, outputDirPath) || other.outputDirPath == outputDirPath)&&(identical(other.errMsg, errMsg) || other.errMsg == errMsg));
}


@override
int get hashCode => Object.hash(runtimeType,outputDirPath,errMsg);

@override
String toString() {
  return 'PresetState(outputDirPath: $outputDirPath, errMsg: $errMsg)';
}


}

/// @nodoc
abstract mixin class $PresetStateCopyWith<$Res>  {
  factory $PresetStateCopyWith(PresetState value, $Res Function(PresetState) _then) = _$PresetStateCopyWithImpl;
@useResult
$Res call({
 String? outputDirPath, String? errMsg
});




}
/// @nodoc
class _$PresetStateCopyWithImpl<$Res>
    implements $PresetStateCopyWith<$Res> {
  _$PresetStateCopyWithImpl(this._self, this._then);

  final PresetState _self;
  final $Res Function(PresetState) _then;

/// Create a copy of PresetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outputDirPath = freezed,Object? errMsg = freezed,}) {
  return _then(_self.copyWith(
outputDirPath: freezed == outputDirPath ? _self.outputDirPath : outputDirPath // ignore: cast_nullable_to_non_nullable
as String?,errMsg: freezed == errMsg ? _self.errMsg : errMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PresetState].
extension PresetStatePatterns on PresetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresetState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresetState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresetState value)  $default,){
final _that = this;
switch (_that) {
case _PresetState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresetState value)?  $default,){
final _that = this;
switch (_that) {
case _PresetState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? outputDirPath,  String? errMsg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresetState() when $default != null:
return $default(_that.outputDirPath,_that.errMsg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? outputDirPath,  String? errMsg)  $default,) {final _that = this;
switch (_that) {
case _PresetState():
return $default(_that.outputDirPath,_that.errMsg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? outputDirPath,  String? errMsg)?  $default,) {final _that = this;
switch (_that) {
case _PresetState() when $default != null:
return $default(_that.outputDirPath,_that.errMsg);case _:
  return null;

}
}

}

/// @nodoc


class _PresetState extends PresetState {
  const _PresetState({this.outputDirPath, this.errMsg}): super._();
  

// 输出目录
@override final  String? outputDirPath;
@override final  String? errMsg;

/// Create a copy of PresetState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresetStateCopyWith<_PresetState> get copyWith => __$PresetStateCopyWithImpl<_PresetState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresetState&&(identical(other.outputDirPath, outputDirPath) || other.outputDirPath == outputDirPath)&&(identical(other.errMsg, errMsg) || other.errMsg == errMsg));
}


@override
int get hashCode => Object.hash(runtimeType,outputDirPath,errMsg);

@override
String toString() {
  return 'PresetState(outputDirPath: $outputDirPath, errMsg: $errMsg)';
}


}

/// @nodoc
abstract mixin class _$PresetStateCopyWith<$Res> implements $PresetStateCopyWith<$Res> {
  factory _$PresetStateCopyWith(_PresetState value, $Res Function(_PresetState) _then) = __$PresetStateCopyWithImpl;
@override @useResult
$Res call({
 String? outputDirPath, String? errMsg
});




}
/// @nodoc
class __$PresetStateCopyWithImpl<$Res>
    implements _$PresetStateCopyWith<$Res> {
  __$PresetStateCopyWithImpl(this._self, this._then);

  final _PresetState _self;
  final $Res Function(_PresetState) _then;

/// Create a copy of PresetState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outputDirPath = freezed,Object? errMsg = freezed,}) {
  return _then(_PresetState(
outputDirPath: freezed == outputDirPath ? _self.outputDirPath : outputDirPath // ignore: cast_nullable_to_non_nullable
as String?,errMsg: freezed == errMsg ? _self.errMsg : errMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
