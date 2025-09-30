import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogTool{
  static bool _isShowLoading = false;

  /// 显示加载弹窗
  static void showLoading({String message = "加载中..."}) {

    var context = Get.context;
    if (context == null){
      return;
    }

    if (_isShowLoading) {
      hideLoading();
    }
    _isShowLoading = true;

    showDialog(
      context: context,
      barrierDismissible: false, // 点击背景不关闭
      builder: (context) {
        return PopScope(
          // 禁止物理返回键关闭
          canPop:  false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 关闭加载弹窗
  static void hideLoading() {
    var context = Get.context;
    if (context == null){
      return;
    }
    if (_isShowLoading) {
      Navigator.of(context, rootNavigator: true).pop(); // 关闭 Dialog
      _isShowLoading = false;
    }
  }

}