import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../dao/cache_data_manager.dart';
import '../../../dao/sp_data_manager.dart';
import '../../../models/cache_group.dart';
import '../../../models/cache_item.dart';

class HomeState {
  HomeState() {
    ///Initialize variables
    inputCacheDirPath = SpDataManager.getInputCacheDirPath() ?? '';
    cachePlatform = SpDataManager.getCachePlatform() ?? CachePlatform.android;
  }

  //输入缓存文件夹路径
  final _inputCacheDirPath = ''.obs;

  String get inputCacheDirPath => _inputCacheDirPath.value;

  set inputCacheDirPath(String value) => _inputCacheDirPath.value = value;

  //缓存平台数据类型
  final Rx<CachePlatform> _cachePlatform = CachePlatform.android.obs;

  CachePlatform get cachePlatform => _cachePlatform.value;

  set cachePlatform(CachePlatform value) => _cachePlatform.value = value;

  final RxList<CacheGroup> _cacheGroupList = <CacheGroup>[].obs;

  // getter 返回普通 List（不可直接修改 RxList 内部）
  List<CacheGroup> get cacheGroupList => _cacheGroupList.toList();

  // setter 用 assignAll 替换整个 RxList
  set cacheGroupList(List<CacheGroup> value) =>
      _cacheGroupList.assignAll(value);

  void changeGroupListCheckedAndRefresh(int index, bool value) {
    changeGroupListChecked(index, value);
    refreshGroupList();
  }

  void changeCacheItemListCheckedAndRefresh(
      int cacheGroupIndex, int index, bool value) {
    changeCacheItemListChecked(cacheGroupIndex, index, value);
    refreshGroupList();
  }

  void changeGroupListChecked(int index, bool value) {
    _cacheGroupList[index].checked = value;
  }

  void changeCacheItemListChecked(int cacheGroupIndex, int index, bool value) {
    _cacheGroupList[cacheGroupIndex].cacheItemList[index].checked = value;
  }

  void refreshGroupList() {
    _cacheGroupList.refresh();
  }

  //缓存组是否为多选模式
  final _isMultiSelectMode = false.obs;

  bool get isMultiSelectMode => _isMultiSelectMode.value;

  set isMultiSelectMode(bool value) => _isMultiSelectMode.value = value;

  // 缓存组是否全选
  final _isAllGroupListChecked = false.obs;

  bool get isAllGroupListChecked => _isAllGroupListChecked.value;

  set isAllGroupListChecked(bool value) => _isAllGroupListChecked.value = value;

  //缓存项是否全选
  final _isAllCacheItemListChecked = false.obs;

  bool get isAllCacheItemListChecked => _isAllCacheItemListChecked.value;

  set isAllCacheItemListChecked(bool value) =>
      _isAllCacheItemListChecked.value = value;

  //输入框是否拖拽中
  final _isTextFieldDragging = false.obs;

  bool get isTextFieldDragging => _isTextFieldDragging.value;

  set isTextFieldDragging(bool value) => _isTextFieldDragging.value = value;

  //是否有权限
  final _hasPermission = false.obs;
  bool get hasPermission => _hasPermission.value;
  set hasPermission(bool value) => _hasPermission.value = value;

  //Android解析权限
  final _androidParseCachePermission = AndroidParseCachePermission.readWrite.obs;
  AndroidParseCachePermission get androidParseCachePermission => _androidParseCachePermission.value;
  set androidParseCachePermission(AndroidParseCachePermission value) => _androidParseCachePermission.value = value;
}
/// 安卓解析缓存权限
enum AndroidParseCachePermission{
  //读写权限
  readWrite,
  //document uri权限
  documentUri,
  //shizuku
  shizuku,
}