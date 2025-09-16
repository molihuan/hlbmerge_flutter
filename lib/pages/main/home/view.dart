import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hlbmerge/utils/FileUtil.dart';
import 'package:hlbmerge/utils/PlatformUtils.dart';

import '../../../dao/cache_data_manager.dart';
import 'logic.dart';
import 'state.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;

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
                    border: OutlineInputBorder(),
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
                              logic.parseCacheData();
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
        controller: TextEditingController(text: "你好"),
        onChanged: (value) {},
        decoration: InputDecoration(
            labelText: '搜索',
            border: OutlineInputBorder(),
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
            blurRadius: 1,   // 模糊程度
            offset: const Offset(0, 1.5), // x,y 偏移
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          state.isMultiSelectMode
              ? const SizedBox.shrink()
              : const Text("缓存",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
          state.isMultiSelectMode
              ? _buildSelectAllBtn()
              : const SizedBox.shrink(),
          state.isMultiSelectMode ? searchTextField : const SizedBox.shrink(),
          const SizedBox(width: 5),
          _buildEditBtn(),
        ],
      ),
    );
  }

  // 缓存列表内容
  Widget _buildBody(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: state.cacheGroupList.length,
      itemExtent: 100,
      itemBuilder: (context, index) {
        var item = state.cacheGroupList[index];

        return InkWell(
          onTap: () {
            if (state.isMultiSelectMode) {
              logic.changeGroupListChecked(index, !item.checked);
            } else {
              showCacheItemListDialog(context, index);
            }
          },
          onLongPress: () {
            logic.changeMultiSelectMode(!state.isMultiSelectMode);
            logic.changeGroupListChecked(index, true);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  return state.isMultiSelectMode
                      ? Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Checkbox(
                              value: item.checked,
                              onChanged: (v) {
                                var checked = v ?? false;
                                logic.changeGroupListChecked(index, checked);
                              }),
                        )
                      : const SizedBox.shrink();
                }),
                Container(
                  width: 160,
                  height: 100,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: _buildCoverImage(item.coverPath, item.coverUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Align(
                          child: Text(item.title ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            '路径:${item.path}',
                            style: const TextStyle(color: Colors.grey),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
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
  void showCacheItemListDialog(BuildContext context, int cacheGroupIndex) {
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
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(20),
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
                            itemExtent: 100,
                            itemBuilder: (context, index) {
                              var item = cacheItemList[index];

                              return InkWell(
                                onTap: () {
                                  logic.changeCacheItemListChecked(
                                      cacheGroupIndex, index, !item.checked);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: Checkbox(
                                            value: item.checked,
                                            onChanged: (v) {
                                              var checked = v ?? false;
                                              logic.changeCacheItemListChecked(
                                                  cacheGroupIndex,
                                                  index,
                                                  checked);
                                            }),
                                      ),
                                      Container(
                                        width: 160,
                                        height: 100,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: _buildCoverImage(
                                                item.coverPath, item.coverUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Align(
                                                child: Text(item.title ?? "",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                            ),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Text(
                                                  '路径:${item.path}',
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                          const Divider(thickness: 0.4),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  Get.snackbar("", "已添加任务,请前往进度页面查看");
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
      return const AssetImage("assets/icos/app_logo.png");
    }
  }
}
