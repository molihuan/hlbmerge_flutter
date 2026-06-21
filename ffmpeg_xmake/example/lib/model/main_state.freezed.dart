// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MainState {

 String? get inputAudio; String? get inputVideo; List<String> get inputVideos; String? get outputFile;
/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainStateCopyWith<MainState> get copyWith => _$MainStateCopyWithImpl<MainState>(this as MainState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainState&&(identical(other.inputAudio, inputAudio) || other.inputAudio == inputAudio)&&(identical(other.inputVideo, inputVideo) || other.inputVideo == inputVideo)&&const DeepCollectionEquality().equals(other.inputVideos, inputVideos)&&(identical(other.outputFile, outputFile) || other.outputFile == outputFile));
}


@override
int get hashCode => Object.hash(runtimeType,inputAudio,inputVideo,const DeepCollectionEquality().hash(inputVideos),outputFile);

@override
String toString() {
  return 'MainState(inputAudio: $inputAudio, inputVideo: $inputVideo, inputVideos: $inputVideos, outputFile: $outputFile)';
}


}

/// @nodoc
abstract mixin class $MainStateCopyWith<$Res>  {
  factory $MainStateCopyWith(MainState value, $Res Function(MainState) _then) = _$MainStateCopyWithImpl;
@useResult
$Res call({
 String? inputAudio, String? inputVideo, List<String> inputVideos, String? outputFile
});




}
/// @nodoc
class _$MainStateCopyWithImpl<$Res>
    implements $MainStateCopyWith<$Res> {
  _$MainStateCopyWithImpl(this._self, this._then);

  final MainState _self;
  final $Res Function(MainState) _then;

/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inputAudio = freezed,Object? inputVideo = freezed,Object? inputVideos = null,Object? outputFile = freezed,}) {
  return _then(_self.copyWith(
inputAudio: freezed == inputAudio ? _self.inputAudio : inputAudio // ignore: cast_nullable_to_non_nullable
as String?,inputVideo: freezed == inputVideo ? _self.inputVideo : inputVideo // ignore: cast_nullable_to_non_nullable
as String?,inputVideos: null == inputVideos ? _self.inputVideos : inputVideos // ignore: cast_nullable_to_non_nullable
as List<String>,outputFile: freezed == outputFile ? _self.outputFile : outputFile // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MainState].
extension MainStatePatterns on MainState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MainState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MainState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MainState value)  $default,){
final _that = this;
switch (_that) {
case _MainState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MainState value)?  $default,){
final _that = this;
switch (_that) {
case _MainState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? inputAudio,  String? inputVideo,  List<String> inputVideos,  String? outputFile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MainState() when $default != null:
return $default(_that.inputAudio,_that.inputVideo,_that.inputVideos,_that.outputFile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? inputAudio,  String? inputVideo,  List<String> inputVideos,  String? outputFile)  $default,) {final _that = this;
switch (_that) {
case _MainState():
return $default(_that.inputAudio,_that.inputVideo,_that.inputVideos,_that.outputFile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? inputAudio,  String? inputVideo,  List<String> inputVideos,  String? outputFile)?  $default,) {final _that = this;
switch (_that) {
case _MainState() when $default != null:
return $default(_that.inputAudio,_that.inputVideo,_that.inputVideos,_that.outputFile);case _:
  return null;

}
}

}

/// @nodoc


class _MainState extends MainState {
  const _MainState({this.inputAudio, this.inputVideo, final  List<String> inputVideos = const [], this.outputFile}): _inputVideos = inputVideos,super._();
  

@override final  String? inputAudio;
@override final  String? inputVideo;
 final  List<String> _inputVideos;
@override@JsonKey() List<String> get inputVideos {
  if (_inputVideos is EqualUnmodifiableListView) return _inputVideos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inputVideos);
}

@override final  String? outputFile;

/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainStateCopyWith<_MainState> get copyWith => __$MainStateCopyWithImpl<_MainState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainState&&(identical(other.inputAudio, inputAudio) || other.inputAudio == inputAudio)&&(identical(other.inputVideo, inputVideo) || other.inputVideo == inputVideo)&&const DeepCollectionEquality().equals(other._inputVideos, _inputVideos)&&(identical(other.outputFile, outputFile) || other.outputFile == outputFile));
}


@override
int get hashCode => Object.hash(runtimeType,inputAudio,inputVideo,const DeepCollectionEquality().hash(_inputVideos),outputFile);

@override
String toString() {
  return 'MainState(inputAudio: $inputAudio, inputVideo: $inputVideo, inputVideos: $inputVideos, outputFile: $outputFile)';
}


}

/// @nodoc
abstract mixin class _$MainStateCopyWith<$Res> implements $MainStateCopyWith<$Res> {
  factory _$MainStateCopyWith(_MainState value, $Res Function(_MainState) _then) = __$MainStateCopyWithImpl;
@override @useResult
$Res call({
 String? inputAudio, String? inputVideo, List<String> inputVideos, String? outputFile
});




}
/// @nodoc
class __$MainStateCopyWithImpl<$Res>
    implements _$MainStateCopyWith<$Res> {
  __$MainStateCopyWithImpl(this._self, this._then);

  final _MainState _self;
  final $Res Function(_MainState) _then;

/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inputAudio = freezed,Object? inputVideo = freezed,Object? inputVideos = null,Object? outputFile = freezed,}) {
  return _then(_MainState(
inputAudio: freezed == inputAudio ? _self.inputAudio : inputAudio // ignore: cast_nullable_to_non_nullable
as String?,inputVideo: freezed == inputVideo ? _self.inputVideo : inputVideo // ignore: cast_nullable_to_non_nullable
as String?,inputVideos: null == inputVideos ? _self._inputVideos : inputVideos // ignore: cast_nullable_to_non_nullable
as List<String>,outputFile: freezed == outputFile ? _self.outputFile : outputFile // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
