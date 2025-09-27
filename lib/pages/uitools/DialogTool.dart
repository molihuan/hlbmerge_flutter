import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogTool{
  static void showLoading([String? message]) {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Container(
            // 设置装饰器，实现圆角、背景色和边框
            decoration: BoxDecoration(
              color: Colors.white, // 对话框背景色
              borderRadius: BorderRadius.circular(12), // 圆角大小
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            // 使用 UnconstrainedBox 让内容决定弹窗大小
            child: UnconstrainedBox(
              child: ConstrainedBox(
                // 限制弹窗的最大宽度
                constraints: const BoxConstraints(maxWidth: 280),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // 让 Row 的宽度包裹内容
                  children: [
                    // 加载组件
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                    // 如果有消息，则显示
                    if (message != null && message.isNotEmpty) ...[
                      const SizedBox(width: 20),
                      // 使用 Flexible 避免文字过长时溢出
                      Flexible(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.black87, // 文本颜色
                            fontSize: 16,
                            decoration: TextDecoration.none, // 移除默认文本装饰
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}