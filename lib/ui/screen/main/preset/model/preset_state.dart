import 'package:freezed_annotation/freezed_annotation.dart';

part 'preset_state.freezed.dart';

@freezed
abstract class PresetState with _$PresetState {
  const PresetState._();

  const factory PresetState({
    // 输出目录
    String? outputDirPath,
    String? errMsg,
  }) = _PresetState;
}
