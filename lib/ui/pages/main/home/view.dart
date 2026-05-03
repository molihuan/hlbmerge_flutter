import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hlbmerge/utils/FileUtils.dart';
import 'package:hlbmerge/utils/PlatformUtils.dart';


import '../../../../dao/cache_data_manager.dart';
import '../../../../models/cache_group.dart';
import 'home_selection_utils.dart';
import 'logic.dart';
import 'state.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;

  // item屏幕配置
  final _ItemScreenCfg _itemScreenCfg =
      runPlatformFuncClassRecord(onDefault: () {
    return (
      itemHeight: 110,
      checkboxMargin: 10,
      titleFontSize: 16,
      pathFontSize: 12,
      itemPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5)
    );
  }, onMobile: () {
    return (
      itemHeight: 85,
      checkboxMargin: 0,
      titleFontSize: 14,
      pathFontSize: 12,
      itemPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3)
    );
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        return Column(
          children: [
            // topbar
            _buildTopBar(context),
            // body
            _buildBody(context),
            _buildBottomBar(),
          ],
        );
      }),
    );
  }

  Widget _buildBottomBar() {
    return runPlatformFuncClass<Widget>(onDefault: () {
      return const SizedBox.shrink();
    }, onMobile: () {
      return state.isMultiSelectMode
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [..._buildHandleBtnList()],
            )
          : const SizedBox.shrink();
    });
  }

  //topbar
  Widget _buildTopBar(BuildContext context) {
    return runPlatformFuncClass<Widget>(onDefault: () {
      return _buildPcTopBar(context);
    }, onMobile: () {
      return _buildPhoneTopBar(context);
    }, onWeb: () {
      return const SizedBox.shrink();
    });
  }

  //全选按钮
  Widget _buildSelectAllBtn() {
    // 全选按钮
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {
          logic.changeAllGroupListChecked(!state.isAllGroupListChecked);
        },
        child: state.isAllGroupListChecked
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Icon(Icons.check_box), Text("取消全选")],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Icon(Icons.check_box_outline_blank), Text("全选")],
              ),
      ),
    );
  }

  //编辑按钮
  Widget _buildEditBtn() {
    //编辑按钮
    return Container(
      decoration: BoxDecoration(
        color: state.isMultiSelectMode
            ? Colors.red.withOpacity(0.7)
            : Colors.transparent,
        shape: BoxShape.circle, // 圆形
      ),
      child: IconButton(
        icon: Icon(
          Icons.edit,
          color: state.isMultiSelectMode ? Colors.white : Colors.black,
        ),
        onPressed: () {
          logic.changeMultiSelectMode(!state.isMultiSelectMode);
        },
      ),
    );
  }

  //PC顶部栏
  Widget _buildPcTopBar(BuildContext context) {
    List<Widget> optionWidgets;
    if (state.isMultiSelectMode) {
      optionWidgets = [..._buildHandleBtnList(), _buildSelectAllBtn()];
    } else {
      optionWidgets = [];
    }

    //缓存类型视图
    Widget cacheTypeWidget = runPlatformFunc(onDefault: () {
      return Row(children: [
        const Text(
          "缓存类型:",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1), // 边框颜色和宽度
            borderRadius: BorderRadius.circular(5), // 圆角
          ),
          child: DropdownButton<CachePlatform>(
            value: state.cachePlatform,
            items: CachePlatform.values.map((platform) {
              return DropdownMenuItem<CachePlatform>(
                value: platform,
                alignment: AlignmentDirectional.center,
                child: Text(platform.title),
              );
            }).toList(),
            onChanged: (CachePlatform? value) {
              if (value != null) {
                state.cachePlatform = value;
              }
            },
            underline: const SizedBox(),
            // 去掉默认下划线
            alignment: AlignmentDirectional.center,
            focusColor: Colors.transparent,
          ),
        ),
      ]);
    }, onAndroid: () {
      return const SizedBox.shrink();
    });

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          cacheTypeWidget,
          const Text(
            "路径:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
              child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: DropTarget(
              onDragDone: (detail) {
                logic.onInputCacheDirPathDragDone(detail.files);
              },
              onDragEntered: (detail) {
                logic.changeTextFieldDragging(true);
              },
              onDragExited: (detail) {
                logic.changeTextFieldDragging(false);
              },
              child: TextField(
                controller:
                    TextEditingController(text: state.inputCacheDirPath),
                onChanged: (value) {
                  state.inputCacheDirPath = value;
                },
                decoration: InputDecoration(
                    labelText: '请输入缓存文件夹路径(支持拖拽),如果加载数据失败请查看设置中的教程',
                    border: const OutlineInputBorder(),
                    hintText: '请输入缓存文件夹路径(支持拖拽)',
                    enabledBorder: OutlineInputBorder(
                      borderSide: state.isTextFieldDragging
                          ? const BorderSide(color: Colors.blue, width: 2)
                          : const BorderSide(
                              color: Colors.grey,
                            ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blue, width: 2), // 聚焦状态边框颜色
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              logic.pickInputCacheDirPath();
                            },
                            child: const Text("选择")),
                        const SizedBox(width: 5),
                        FilledButton(
                            onPressed: () {
                              logic.finalParseCacheData();
                            },
                            child: const Text("加载数据")),
                        const SizedBox(width: 5),
                      ],
                    )),
              ),
            ),
          )),
          Row(
            children: [...optionWidgets, _buildEditBtn()],
          ),
        ],
      ),
    );
  }

  //手机顶部栏
  Widget _buildPhoneTopBar(BuildContext context) {
    if (state.isMultiSelectMode) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1.5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: _buildSelectionSummaryChip(context)),
                IconButton(
                  tooltip: '清空已选',
                  onPressed: state.selectionSnapshot.hasSelection
                      ? () {
                          logic.clearSelections();
                        }
                      : null,
                  icon: const Icon(Icons.playlist_remove),
                ),
                IconButton(
                  tooltip: state.isAllGroupListChecked ? '取消全选结果' : '全选结果',
                  onPressed: () {
                    logic.changeAllGroupListChecked(!state.isAllGroupListChecked);
                  },
                  icon: Icon(state.isAllGroupListChecked
                      ? Icons.check_box
                      : Icons.check_box_outline_blank),
                ),
                _buildEditBtn(),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: logic.searchTextController,
              onChanged: logic.updateSearchKeyword,
              decoration: InputDecoration(
                labelText: '搜索',
                border: const OutlineInputBorder(),
                hintText: '支持标题、路径、视频子项模糊搜索',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: state.searchKeyword.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          logic.clearSearchKeyword();
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // 阴影颜色
            spreadRadius: 1, // 阴影扩散
            blurRadius: 1, // 模糊程度
            offset: const Offset(0, 1.5), // x,y 偏移
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("缓存",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Row(children: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
              ),
              onPressed: () {
                // 刷新
                logic.refreshCacheData();
              },
            ),
            _buildEditBtn()
          ],),
        ],
      ),
    );
  }

  // 缓存列表内容
  Widget _buildBody(BuildContext context) {
    Widget content;
    if (state.hasPermission) {
      final visibleCacheGroupList = state.visibleCacheGroupList;
      if (visibleCacheGroupList.isEmpty) {
        content = Center(
          child: Text(
            state.searchKeyword.isEmpty ? '暂无缓存数据' : '没有匹配的视频',
            style: const TextStyle(color: Colors.grey),
          ),
        );
      } else {
        content = Scrollbar(
          controller: logic.groupListScrollController,
          thumbVisibility: true,
          trackVisibility: true,
          interactive: true,
          thickness: 6,
          radius: const Radius.circular(999),
          child: ListView.builder(
            controller: logic.groupListScrollController,
            itemCount: visibleCacheGroupList.length,
            itemBuilder: (context, index) {
              var item = visibleCacheGroupList[index];
              final bool isSelected =
                  state.isMultiSelectMode &&
                  HomeSelectionUtils.hasVisibleSelection(item);
              final String? selectionLabel = _buildSelectionLabel(item);

              return InkWell(
                onTap: () {
                  if (state.isMultiSelectMode) {
                    logic.changeGroupSelection(item, !item.checked);
                  } else {
                    _showCacheItemListDialog(context, item);
                  }
                },
                onLongPress: () {
                  logic.changeMultiSelectMode(true);
                  logic.changeGroupSelection(item, true);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.45)
                          : Colors.transparent,
                    ),
                    color: isSelected
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.08)
                        : Colors.transparent,
                  ),
                  child: Container(
                    height: _itemScreenCfg.itemHeight,
                    padding: _itemScreenCfg.itemPadding,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() {
                          return state.isMultiSelectMode
                              ? Container(
                                  margin: EdgeInsets.only(
                                      right: _itemScreenCfg.checkboxMargin),
                                  child: Checkbox(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      value: item.checked,
                                      onChanged: (v) {
                                        var checked = v ?? false;
                                        logic.changeGroupSelection(item, checked);
                                      }),
                                )
                              : const SizedBox.shrink();
                        }),
                        SizedBox(
                          height: _itemScreenCfg.itemHeight,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: _buildCoverImage(
                                      item.coverPath, item.coverUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: _itemScreenCfg.itemHeight,
                            margin: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          item.title ?? "无标题",
                                          style: TextStyle(
                                            fontSize:
                                                _itemScreenCfg.titleFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                    if (selectionLabel != null)
                                      _buildSelectionBadge(context,
                                          label: selectionLabel),
                                    if (state.isMultiSelectMode && isSelected)
                                      IconButton(
                                        tooltip: '取消此组选择',
                                        onPressed: () {
                                          logic.clearGroupSelection(item);
                                        },
                                        icon: const Icon(Icons.close, size: 18),
                                        constraints: const BoxConstraints(
                                            minWidth: 32, minHeight: 32),
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                  ],
                                )),
                                SizedBox(
                                  height: _itemScreenCfg.itemHeight * 0.3,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text("路径:",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize:
                                                    _itemScreenCfg.pathFontSize)),
                                        SelectableText(
                                          '${item.path}',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize:
                                                  _itemScreenCfg.pathFontSize),
                                          maxLines: 1,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    } else {
      // 权限申请页面的逻辑不变
      content = Container(
        alignment: Alignment.center,
        child: ElevatedButton(
            onPressed: () {
              logic.grantReadWritePermission();
            },
            child: const Text("授权")),
      );
    }

    return Expanded(child: content);
  }

  // 操作按钮
  List<Widget> _buildHandleBtnList() {
    return [
      TextButton(
          onPressed: () {
            logic.exportFileByCacheGroup(FileFormat.mp3);
          },
          child: const Text("提取音频")),
      TextButton(
          onPressed: () {
            logic.exportFileByCacheGroup(FileFormat.mp4);
          },
          child: const Text("提取视频")),
      TextButton(
          onPressed: () {
            logic.mergeAudioVideoByCacheGroup();
          },
          child: const Text("合并音视频"))
    ];
  }

  //缓存项列表弹窗
  void _showCacheItemListDialog(BuildContext context, CacheGroup cacheGroup) {
    var itemHeight = _itemScreenCfg.itemHeight - 15;
    var titleFontSize = _itemScreenCfg.titleFontSize - 1;
    var pathFontSize = _itemScreenCfg.pathFontSize - 1;
    final dialogScrollController = ScrollController();
    showDialog(
      context: context,
      barrierDismissible: true, // 点击空白关闭
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero, // 取消默认边距
          backgroundColor: Colors.transparent, // 背景透明
          child: Container(
            width: double.infinity,
            height: double.infinity, // 全屏
            color: Colors.black.withOpacity(0.5), // 蒙层效果
            child: StatefulBuilder(builder: (context, setState) {
              final cacheItemList = cacheGroup.cacheItemList;
              final isAllCacheItemChecked = cacheItemList.isNotEmpty &&
                  cacheItemList.every((item) => item.checked);
              return Stack(
                children: [
                  // 居中内容
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "请选择需要合并的缓存项",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                              child: Scrollbar(
                            controller: dialogScrollController,
                            thumbVisibility: true,
                            trackVisibility: true,
                            interactive: true,
                            thickness: 6,
                            radius: const Radius.circular(999),
                            child: ListView.builder(
                              controller: dialogScrollController,
                              itemCount: cacheItemList.length,
                              itemExtent: itemHeight,
                              itemBuilder: (context, index) {
                                var item = cacheItemList[index];

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      logic.changeCacheItemSelection(
                                          cacheGroup, index, !item.checked);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            _itemScreenCfg.itemPadding.vertical -
                                                2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: _itemScreenCfg
                                                  .checkboxMargin),
                                          child: Checkbox(
                                              value: item.checked,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              onChanged: (v) {
                                                var checked = v ?? false;
                                                setState(() {
                                                  logic.changeCacheItemSelection(
                                                      cacheGroup,
                                                      index,
                                                      checked);
                                                });
                                              }),
                                        ),
                                        SizedBox(
                                          height: itemHeight,
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                image: DecorationImage(
                                                  image: _buildCoverImage(
                                                      item.coverPath,
                                                      item.coverUrl),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: itemHeight,
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    item.title ?? "",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: titleFontSize,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )),
                                                SizedBox(
                                                  height: itemHeight * 0.3,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        Text("路径:",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  pathFontSize,
                                                              color:
                                                                  Colors.grey,
                                                            )),
                                                        SelectableText(
                                                          item.path ?? "",
                                                          style: TextStyle(
                                                            fontSize:
                                                                pathFontSize,
                                                            color: Colors.grey,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: const Divider(thickness: 0.4)),
                          //全选按钮
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    right: 10, left: 15, bottom: 15),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      logic.changeAllCacheItemListChecked(
                                          cacheGroup, !isAllCacheItemChecked);
                                    });
                                  },
                                  child: isAllCacheItemChecked
                                      ? const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.check_box),
                                            Text("取消全选")
                                          ],
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.check_box_outline_blank),
                                            Text("全选")
                                          ],
                                        ),
                                ),
                              )
                            ],
                          ),

                          Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  logic.exportFileByCacheItem(
                                      state.cacheGroupList.indexOf(cacheGroup),
                                      FileFormat.mp3);
                                },
                                child: const Text("提取音频"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  logic.exportFileByCacheItem(
                                      state.cacheGroupList.indexOf(cacheGroup),
                                      FileFormat.mp4);
                                },
                                child: const Text("提取视频"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  logic.mergeAudioVideoByCacheItem(
                                      state.cacheGroupList.indexOf(cacheGroup));
                                  Get.snackbar("提示", "已添加任务,请前往进度页面查看");
                                },
                                child: const Text("合并音视频"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  //取消全选
                                  logic.changeAllCacheItemListChecked(
                                      cacheGroup, false);
                                  Navigator.of(context).pop();
                                },
                                child: const Text("关闭"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    ).whenComplete(dialogScrollController.dispose);
  }

  Widget _buildSelectionSummaryChip(BuildContext context) {
    final snapshot = state.selectionSnapshot;
    final resultCount = state.visibleCacheGroupList.length;
    final totalCount = state.cacheGroupList.length;
    final summaryText = snapshot.selectedItemCount > 0
        ? '已选 ${snapshot.selectedDisplayCount} 组 · ${snapshot.selectedItemCount} 项'
        : '已选 ${snapshot.selectedDisplayCount} 组';

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildSelectionBadge(context, label: summaryText),
        _buildSelectionBadge(context,
            label: '筛选结果 $resultCount/$totalCount', highlighted: false),
      ],
    );
  }

  Widget _buildSelectionBadge(BuildContext context,
      {required String label, bool highlighted = true}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: highlighted
            ? colorScheme.primary.withOpacity(0.12)
            : colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: highlighted ? colorScheme.primary : Colors.grey.shade700,
        ),
      ),
    );
  }

  String? _buildSelectionLabel(CacheGroup group) {
    final int selectedItemCount =
        HomeSelectionUtils.selectedItemCountForGroup(group);
    if (group.checked && selectedItemCount > 0) {
      return '已选 · $selectedItemCount 项';
    }
    if (group.checked) {
      return '已选';
    }
    if (selectedItemCount > 0) {
      return '已选 $selectedItemCount 项';
    }
    return null;
  }

  //封面图片
  ImageProvider _buildCoverImage(
      final String? coverPath, final String? coverUrl) {
    if (coverPath != null) {
      return FileImage(File(coverPath));
    } else if (coverUrl != null) {
      return NetworkImage(coverUrl);
    } else {
      return const AssetImage("assets/icons/app_logo.png");
    }
  }
}

///item屏幕配置
typedef _ItemScreenCfg = ({
  double itemHeight,
  double checkboxMargin,
  double titleFontSize,
  double pathFontSize,
  EdgeInsetsGeometry itemPadding,
});
