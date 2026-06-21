import 'package:desktop_drop/src/drop_item.dart';
import 'package:hlbmerge/repository/settings_repository.dart';
import 'package:hlbmerge/utils/toast_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../features/export/cache_data_manager.dart';
import '../../../../../utils/file_util.dart';
import '../model/home_state.dart';
import '../model/sync_home_state.dart';
import 'home_provider.dart';

part 'sync_home_provider.g.dart';

@riverpod
class SyncHomeNotifier extends _$SyncHomeNotifier {
  // HomeState get uiState => ref.read(homeProvider);

  HomeNotifier get intent => ref.read(homeProvider.notifier);

  @override
  SyncHomeState build() {
    final mode = SettingsRepository.getOutputFileMode();
    final cachePlatform = SettingsRepository.getCachePlatform();

    return SyncHomeState(outputFileMode: mode, cachePlatform: cachePlatform);
  }

  void changeCheckSearch(bool v) {
    state = state.copyWith(checkSearch: v);
  }

  void changeMultiSelectMode(bool v) {
    state = state.copyWith(checkMultiSelectMode: v);
  }

  void changeOutputFileMode(OutputFileMode v) {
    SettingsRepository.setOutputFileMode(v);
    state = state.copyWith(outputFileMode: v);
  }

  void onInputCacheDirPathDragDone(List<DropItem> dropItemList) {
    if (dropItemList.length != 1) {
      ToastUtil.warning("只能拖入一个路径");
      return;
    }
    DropItem dropItem = dropItemList.first;
    var isDir = FileUtil.isDir(dropItem.path);
    if (!isDir) {
      ToastUtil.warning("请拖入一个目录");
      return;
    }

    intent.changeInputCacheDirPath(dropItem.path);
    intent.refreshCacheData();
  }

  void changeTextFieldDragging(bool v) {
      state = state.copyWith(checkTextFieldDragging: v);
  }

  void changeSearchValue(String v) {
    state = state.copyWith(searchValue: v);
  }

  void changeCachePlatform(CachePlatform? v) {
    if (v == null) {
      return;
    }
    SettingsRepository.setCachePlatform(v);
    state = state.copyWith(cachePlatform: v);
  }



}
