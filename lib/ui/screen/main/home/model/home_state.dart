import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../features/export/merge/model/cache_group.dart';



part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState({
    //输入缓存文件夹路径
    @Default("") String inputCacheDirPath,
    @Default([]) List<CacheGroup> cacheGroupList,
    // 是否有权限
    @Default(false) bool hasPermission,
    String? errMsg,
  }) = _HomeState;
}
