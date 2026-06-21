import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastUtil {
  ToastUtil._();

  //默认时间
  static const int defaultMilliseconds = 1500;

  static void success(String msg, {int milliseconds = defaultMilliseconds}) {
    show(msg, type: ToastificationType.success, milliseconds: milliseconds);
  }

  static void error(String msg, {int milliseconds = defaultMilliseconds}) {
    show(msg, type: ToastificationType.error, milliseconds: milliseconds);
  }

  static void info(String msg, {int milliseconds = defaultMilliseconds}) {
    show(msg, type: ToastificationType.info, milliseconds: milliseconds);
  }

  static void warning(String msg, {int milliseconds = defaultMilliseconds}) {
    show(msg, type: ToastificationType.warning, milliseconds: milliseconds);
  }

  //永久显示
  static ToastificationItem showAlways(
    Widget title, {
    ToastificationType? type,
    AlignmentGeometry? alignment = Alignment.center,
  }) {
    return toastification.show(
      title: title,
      autoCloseDuration: null,
      type: type,
      alignment: alignment,
    );
  }

  static void dismissAll() {
    toastification.dismissAll();
  }

  static ToastificationItem show(
    String msg, {
    int? milliseconds = defaultMilliseconds,
    ToastificationType? type,
    AlignmentGeometry? alignment = Alignment.center,
  }) {
    return toastification.show(
      title: Text(msg),
      autoCloseDuration: milliseconds == null
          ? null
          : Duration(milliseconds: milliseconds),
      type: type,
      alignment: alignment,
    );
  }

  static Function() showLoading(String msg) {
    return BotToast.showCustomLoading(
      toastBuilder: (cancel) {
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 15),
                Text(msg),
              ],
            ),
          ),
        );
      },
    );
  }
}
