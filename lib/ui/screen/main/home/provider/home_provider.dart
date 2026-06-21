import 'package:file_picker_ohos/file_picker_ohos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hlbmerge/features/export/base_export_file_server.dart';
import 'package:hlbmerge/features/export/merge/impl/android_merge_server.dart';
import 'package:hlbmerge/features/export/merge/impl/windows_merge_server.dart';
import 'package:hlbmerge/log/log.dart';
import 'package:hlbmerge/ui/screen/main/home/model/sync_home_state.dart';
import 'package:hlbmerge/utils/toast_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';

import '../../../../../features/export/copy/impl/android_copy_file_server.dart';
import '../../../../../features/export/copy/impl/windows_copy_file_server.dart';
import '../../../../../features/export/cache_data_manager.dart';
import '../../../../../features/export/merge/model/cache_group.dart';
import '../../../../../features/export/merge/model/cache_item.dart';

import '../../../../../generate/pigeon/flutter_native_api.g.dart';
import '../../../../../repository/settings_repository.dart';
import '../../../../../utils/platform_util.dart';
import '../../../../../utils/str_util.dart';
import '../model/home_state.dart';
import 'sync_home_provider.dart';

part 'home_provider.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier with WidgetsBindingObserver {
  // 同步UiState
  SyncHomeState get syncUiState => ref.read(syncHomeProvider);

  SyncHomeNotifier get syncIntent => ref.read(syncHomeProvider.notifier);

  HomeState get uiState => state.requireValue;
  late final nativeApis = NativeApis();
  late final _cacheDataManager = CacheDataManager();

  late String _androidInputCachePackageName;

  String get inputCacheDirPath => SettingsRepository.getInputCacheDirPath();

  @override
  FutureOr<HomeState> build() async {

    final cacheGroupList = _finalParseCacheData(inputCacheDirPath);

    late final bool hasPermission;
    await runPlatformAsync(
      onAndroid: () async{
        _androidInputCachePackageName =
            SettingsRepository.getAndroidInputCachePackageName();
        hasPermission = await hasReadWritePermission();
      },
      orElse: () {
        hasPermission = true;
      },
    );

    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
    });

    return HomeState(
      hasPermission: hasPermission,
      cacheGroupList: cacheGroupList,
      inputCacheDirPath: inputCacheDirPath,
    );
  }

  BaseExportFileServer get exportFileServer {
    //判断缓存平台类型
    switch (syncUiState.cachePlatform) {
      case CachePlatform.win:
      case CachePlatform.mac:
      // 判断导出类型
        switch (syncUiState.outputFileMode) {
          case OutputFileMode.audio:
          case OutputFileMode.video:
            return WindowsCopyFileServer();
          case OutputFileMode.all:
            return WindowsMergeServer();
        }
        break;
      case CachePlatform.android:
      // 判断导出类型
        switch (syncUiState.outputFileMode) {
          case OutputFileMode.audio:
          case OutputFileMode.video:
            return AndroidCopyFileServer();
          case OutputFileMode.all:
            return AndroidMergeServer();
        }
        break;
    }
  }

  /// 导出
  void exportFileByCacheGroup(List<CacheGroup> cacheGroupList,
      OutputFileMode outputFileMode,) async {

    //错误item和错误信息列表
    final errorItemList = <Tuple2<CacheItem, String>>[];

    final cancelToast = ToastUtil.showLoading("正在导出...");
    for (final cacheGroup in cacheGroupList) {
      if (cacheGroup.checked) {
        final result = await exportFileServer.exportFileByCacheGroup(
          cacheGroup,
          outputFileMode,
        );
        errorItemList.addAll(result);
      }
    }
    cancelToast();

    if (errorItemList.isNotEmpty) {
      ToastUtil.error("失败数量:${errorItemList.length}");
      return;
    }
    ToastUtil.success("导出成功");
  }

  void exportFileByCacheItem(List<CacheItem> cacheItemList,
      OutputFileMode outputFileMode,
      String? groupTitle,) async {

    //错误item和错误信息列表
    final errorItemList = <Tuple2<CacheItem, String>>[];

    final cancelToast = ToastUtil.showLoading("正在导出...");
    for (final item in cacheItemList) {
      if (item.checked) {
        final result = await exportFileServer.exportFileByCacheItem(
          item,
          outputFileMode,
          groupTitle,
        );
        if (!result.item1) {
          errorItemList.add(Tuple2(item, result.item2 ?? "未知错误"));
        }
      }
    }
    cancelToast();

    if (errorItemList.isNotEmpty) {
      ToastUtil.error("失败数量:${errorItemList.length}");
      return;
    }
    ToastUtil.success("导出成功");
  }

  /// 刷新缓存数据
  void refreshCacheData() async {
    final inputCacheDirPath = uiState.inputCacheDirPath;

    bool preResult = await runPlatformAsync(
      orElse: () {
        if (inputCacheDirPath.isEmpty) {
          //清空列表
          state = AsyncData(uiState.copyWith(cacheGroupList: []));
          ToastUtil.warning("请选择解析缓存视频位置");
          return false;
        }
        state = AsyncData(uiState.copyWith(hasPermission: true));
        return true;
      },
      onAndroid: () async {
        //判断是否有读写权限
        final result = await hasReadWritePermission();
        //print("安卓权限判断结果:${result}");

        if (!result) {
          state = AsyncData(uiState.copyWith(hasPermission: false));
          ToastUtil.error("权限不足");
          return false;
        }

        if (inputCacheDirPath.isEmpty) {
          state = AsyncData(
            uiState.copyWith(cacheGroupList: [], hasPermission: true),
          );
          ToastUtil.warning("请先设置'缓存视频解析位置'");
          return false;
        }

        final cancelToast = ToastUtil.showLoading("正在读取缓存数据...");
        //拷贝缓存数据结构
        final copyResult = await nativeApis.copyCacheStructureFile();
        cancelToast();

        if (!copyResult.data) {
          //拷贝失败
          ToastUtil.error("err:${copyResult.msg}");
          return false;
        }

        return true;
      },
    );

    if (!preResult) {
      return;
    }

    // 开始解析
    List<CacheGroup> cacheGroupList = _finalParseCacheData(inputCacheDirPath);
    state = AsyncData(
      uiState.copyWith(cacheGroupList: cacheGroupList, hasPermission: true),
    );
    if (cacheGroupList.isEmpty) {
      ToastUtil.warning("没有找到缓存数据,请查看教程");
      return;
    }
    ToastUtil.success("解析完成");
  }

  // 解析缓存数据得到缓存组
  List<CacheGroup> _finalParseCacheData(String cacheDirPath) {
    if (cacheDirPath.isEmpty) {
      return [];
    }
    _cacheDataManager.setCachePlatform(syncUiState.cachePlatform);
    List<CacheGroup>? cacheGroupList;
    try {
      cacheGroupList = _cacheDataManager.loadCacheData(cacheDirPath);
    } catch (e) {
      print(e);
    }

    if (cacheGroupList == null) {
      return [];
    }
    // print(cacheGroupList);
    return cacheGroupList;
  }

  //搜索过滤
  void searchCacheGroupList(String keyword) {
    final cacheGroupList = _finalParseCacheData(inputCacheDirPath);
    final filterList = cacheGroupList.where((it){
      return it.title?.contains(keyword) == true;
    }).toList();

    state = AsyncData(uiState.copyWith(cacheGroupList: filterList));
  }

  // 清空搜索
  void clearSearch() {
    syncIntent.changeSearchValue("");
    final cacheGroupList = _finalParseCacheData(inputCacheDirPath);
    state = AsyncData(uiState.copyWith(cacheGroupList: cacheGroupList));
  }

  // 改变缓存组选择状态
  void changeGroupListChecked(CacheGroup item, bool value) {
    final newCacheGroupList = uiState.cacheGroupList.map((e) {
      if (e == item) {
        final newItem = item.copyWith(checked: value);
        return newItem;
      }
      return e;
    }).toList();

    state = AsyncData(uiState.copyWith(cacheGroupList: newCacheGroupList));
  }

  // 改变所有缓存组选择状态
  void changeAllGroupListChecked(bool value) {
    final newCacheGroupList = uiState.cacheGroupList.map((e) {
      return e.copyWith(checked: value);
    }).toList();

    state = AsyncData(uiState.copyWith(cacheGroupList: newCacheGroupList));
  }

  void changeAllCacheItemListChecked(int cacheGroupIndex, bool v) {
    final cacheGroup = uiState.cacheGroupList[cacheGroupIndex];

    final newCacheItemList = cacheGroup.cacheItemList.map((e) {
      return e.copyWith(checked: v);
    }).toList();

    final newCacheGroupList = uiState.cacheGroupList.map((e) {
      if (e == cacheGroup) {
        final newCacheGroup = cacheGroup.copyWith(
          cacheItemList: newCacheItemList,
        );
        return newCacheGroup;
      }
      return e;
    }).toList();

    state = AsyncData(uiState.copyWith(cacheGroupList: newCacheGroupList));
  }

  void changeCacheItemListChecked(int cacheGroupIndex, int index, bool v) {
    final cacheGroup = uiState.cacheGroupList[cacheGroupIndex];
    final newCacheItemList = cacheGroup.cacheItemList.map((e) {
      if (e == cacheGroup.cacheItemList[index]) {
        final newCacheItem = e.copyWith(checked: v);
        return newCacheItem;
      }
      return e;
    }).toList();
    final newCacheGroupList = uiState.cacheGroupList.map((e) {
      if (e == cacheGroup) {
        final newCacheGroup = cacheGroup.copyWith(
          cacheItemList: newCacheItemList,
        );
        return newCacheGroup;
      }
      return e;
    }).toList();
    state = AsyncData(uiState.copyWith(cacheGroupList: newCacheGroupList));
  }

  void changeInputCacheDirPath(String v) {
    SettingsRepository.setInputCacheDirPath(v);
    state = AsyncData(uiState.copyWith(inputCacheDirPath: v));
  }

  /// 判断读写权限
  Future<bool> hasReadWritePermission() async {
    final permissionResult = await nativeApis.hasReadWritePermission();
    return permissionResult.data;
  }

  ///申请读写权限
  Future<void> grantReadWritePermission() async {
    runPlatform(
      orElse: () {},
      onAndroid: () async {
        var result = await nativeApis.goNativePage("", null);
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.resumed) {
      runPlatformAsync(
        onAndroid: () async {
          // 如果权限变更需要刷新权限
          final oldPermissionStatus = uiState.hasPermission;
          final newPermissionStatus = await hasReadWritePermission();
          if (oldPermissionStatus != newPermissionStatus) {
            state = AsyncData(
              uiState.copyWith(hasPermission: newPermissionStatus),
            );
          }
          //是否需要刷新列表数据
          bool needRefresh = false;

          // 如果缓存位置变更需要刷新缓存数据
          String newInputPath = SettingsRepository.getInputCacheDirPath();
          final oldInputPath = uiState.inputCacheDirPath;

          if (newInputPath.isNotEmpty && newInputPath != oldInputPath) {
            changeInputCacheDirPath(newInputPath);
            needRefresh = true;
          }

          // 如果缓存包名变更也需要刷新缓存数据
          String newInputCachePackageName =
          SettingsRepository.getAndroidInputCachePackageName();
          if (newInputCachePackageName != _androidInputCachePackageName) {
            needRefresh = true;
          }

          if (needRefresh) {
            refreshCacheData();
          }
        },
        orElse: () {},
      );
    }
  }

  void pickInputCacheDirPath() async {
    String? dirPath = await FilePicker.platform.getDirectoryPath();

    if (dirPath == null) {
      ToastUtil.warning("您未选择路径");
      return;
    }

    Log.e(dirPath);
    //判断路径中是否有空格
    if (StrUtil.containsAnySpace(dirPath)) {
      ToastUtil.warning("路径中不能包含空格,请重新选择");
      return;
    }
    changeInputCacheDirPath(dirPath);
    refreshCacheData();
  }

}
