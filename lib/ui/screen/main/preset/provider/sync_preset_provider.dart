import 'package:hlbmerge/repository/settings_repository.dart';
import 'package:hlbmerge/utils/app_util.dart';
import 'package:hlbmerge/utils/toast_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../features/export/merge/ffmpeg_server.dart';
import '../model/sync_preset_state.dart';
import 'preset_provider.dart';

part 'sync_preset_provider.g.dart';

@riverpod
class SyncPresetNotifier extends _$SyncPresetNotifier {
  @override
  SyncPresetState build() {
    bool checkSingleOutputPath =
        SettingsRepository.getSingleOutputPathChecked();
    bool checkExportAddIndex = SettingsRepository.getExportFileAddIndex();
    bool checkExportDanmakuFile =
        SettingsRepository.getExportDanmakuFileChecked();

    final bean = SyncPresetState(
      checkSingleOutputPath: checkSingleOutputPath,
      checkExportAddIndex: checkExportAddIndex,
      checkExportDanmakuFile: checkExportDanmakuFile,
    );
    return bean;
  }

  void showFfmpegVersion() {
    final version = FFmpegServer.ffmpegVersion() ?? "err";
    ToastUtil.info(version);
  }

  void changeSingleOutputPathChecked(bool v) {
    SettingsRepository.setSingleOutputPathChecked(v);
    state = state.copyWith(checkSingleOutputPath: v);
  }

  void changeExportFileAddIndexChecked(bool v) {
    SettingsRepository.setExportFileAddIndex(v);
    state = state.copyWith(checkExportAddIndex: v);
  }

  void changeExportDanmakuFileChecked(bool v) {
    SettingsRepository.setExportDanmakuFileChecked(v);
    state = state.copyWith(checkExportDanmakuFile: v);
  }


}
