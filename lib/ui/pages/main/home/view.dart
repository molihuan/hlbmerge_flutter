import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hlbmerge/utils/FileUtils.dart';
import 'package:hlbmerge/utils/PlatformUtils.dart';


import '../../../../dao/cache_data_manager.dart';
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
    var searchTextField = Expanded(
        child: Container(
      child: TextField(
        controller: TextEditingController(text: "还没做"),
        onChanged: (value) {},
        decoration: InputDecoration(
            labelText: '搜索',
            border: const OutlineInputBorder(),
            hintText: '请输入搜索内容',
            enabledBorder: OutlineInputBorder(
              borderSide: state.isTextFieldDragging
                  ? const BorderSide(color: Colors.blue, width: 2)
                  : const BorderSide(
                      color: Colors.grey,
                    ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2), // 聚焦状态边框颜色
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            suffixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
              ],
            )),
      ),
    ));

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
          state.isMultiSelectMode
              ? const SizedBox.shrink()
              : const Text("缓存",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          state.isMultiSelectMode
              ? _buildSelectAllBtn()
              : const SizedBox.shrink(),
          state.isMultiSelectMode ? searchTextField : const SizedBox.shrink(),
          const SizedBox(width: 5),
          Row(children: [
            state.isMultiSelectMode ? const SizedBox.shrink() : IconButton(
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
      content = ListView.builder(
        // itemCount 和 itemBuilder 保持我们之前优化好的版本
        itemCount: state.cacheGroupList.length,
        itemBuilder: (context, index) {
          var item = state.cacheGroupList[index];

          return InkWell(
            onTap: () {
              if (state.isMultiSelectMode) {
                logic.changeGroupListChecked(index, !item.checked);
              } else {
                _showCacheItemListDialog(context, index);
              }
            },
            onLongPress: () {
              logic.changeMultiSelectMode(!state.isMultiSelectMode);
              logic.changeGroupListChecked(index, true);
            },
            child: Container(
              height: _itemScreenCfg.itemHeight,
              padding: _itemScreenCfg.itemPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. 复选框部分 (保持不变)
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
                                  logic.changeGroupListChecked(index, checked);
                                }),
                          )
                        : const SizedBox.shrink();
                  }),
                  // 2. 图片部分 (保持不变)
                  SizedBox(
                    height: _itemScreenCfg.itemHeight,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image:
                                _buildCoverImage(item.coverPath, item.coverUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 3. 文字信息部分 (已解决溢出问题)
                  Expanded(
                    child: Container(
                      height: _itemScreenCfg.itemHeight,
                      margin: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item.title ?? "无标题",
                              style: TextStyle(
                                fontSize: _itemScreenCfg.titleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                            ),
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
                                        fontSize: _itemScreenCfg.pathFontSize),
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
          );
        },
      );
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
  void _showCacheItemListDialog(BuildContext context, int cacheGroupIndex) {
    var itemHeight = _itemScreenCfg.itemHeight - 15;
    var titleFontSize = _itemScreenCfg.titleFontSize - 1;
    var pathFontSize = _itemScreenCfg.pathFontSize - 1;
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
            child: Obx(() {
              var cacheItemList =
                  state.cacheGroupList[cacheGroupIndex].cacheItemList;
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
                              child: ListView.builder(
                            itemCount: cacheItemList.length,
                            itemExtent: itemHeight,
                            itemBuilder: (context, index) {
                              var item = cacheItemList[index];

                              return InkWell(
                                onTap: () {
                                  logic.changeCacheItemListChecked(
                                      cacheGroupIndex, index, !item.checked);
                                },
                                child: Container(
                                  padding:  EdgeInsets.symmetric(vertical: _itemScreenCfg.itemPadding.vertical - 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right:
                                                _itemScreenCfg.checkboxMargin),
                                        child: Checkbox(
                                            value: item.checked,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            onChanged: (v) {
                                              var checked = v ?? false;
                                              logic.changeCacheItemListChecked(
                                                  cacheGroupIndex,
                                                  index,
                                                  checked);
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
                                      //文字
                                      Expanded(
                                        child: Container(
                                          height: itemHeight, // 整个内容区域的固定高度
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // 标题文本区域
                                              Expanded(
                                                  child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  item.title ?? "",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: titleFontSize,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )),
                                              // 路径文本区域
                                              SizedBox(
                                                height: itemHeight * 0.3,
                                                // 例如，给路径文本分配 30% 的 itemHeight
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      Text("路径:",
                                                          style: TextStyle(
                                                            fontSize:
                                                                pathFontSize,
                                                            color: Colors.grey,
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
                                    logic.changeAllCacheItemListChecked(
                                        cacheGroupIndex,
                                        !state.isAllCacheItemListChecked);
                                  },
                                  child: state.isAllCacheItemListChecked
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
                                      cacheGroupIndex, FileFormat.mp3);
                                },
                                child: const Text("提取音频"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  logic.exportFileByCacheItem(
                                      cacheGroupIndex, FileFormat.mp4);
                                },
                                child: const Text("提取视频"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  logic.mergeAudioVideoByCacheItem(
                                      cacheGroupIndex);
                                  Get.snackbar("提示", "已添加任务,请前往进度页面查看");
                                },
                                child: const Text("合并音视频"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  //取消全选
                                  logic.changeAllCacheItemListChecked(
                                      cacheGroupIndex, false);
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
    );
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
