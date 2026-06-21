import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../features/export/cache_data_manager.dart';



part 'sync_home_state.freezed.dart';

@freezed
abstract class SyncHomeState with _$SyncHomeState {
  const SyncHomeState._();

  const factory SyncHomeState({
    @Default(CachePlatform.android) CachePlatform cachePlatform,
    //导出模式
    @Default(OutputFileMode.all) OutputFileMode outputFileMode,
    @Default(false) bool checkMultiSelectMode,
    // 缓存项是否全选
    @Default(false) bool checkAllCacheItemList,
    //输入框是否拖拽中
    @Default(false) bool checkTextFieldDragging,
    //开启搜索
    @Default(false) bool checkSearch,
    //搜索值
    @Default('') String searchValue,
    String? errMsg,
  }) = _SyncHomeState;
}
