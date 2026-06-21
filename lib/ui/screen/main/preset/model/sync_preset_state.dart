import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_preset_state.freezed.dart';

@freezed
abstract class SyncPresetState with _$SyncPresetState {
  const SyncPresetState._();

  const factory SyncPresetState({
    //是否单一输出目录
    @Default(false) bool checkSingleOutputPath,
    //导出时添加序号
    @Default(false) bool checkExportAddIndex,
    //导出弹幕文件
    @Default(false) bool checkExportDanmakuFile,
    String? errMsg,
  }) = _SyncPresetState;
}
