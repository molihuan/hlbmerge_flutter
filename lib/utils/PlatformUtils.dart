import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// 跨平台方法，可选回调，返回值支持泛型
T runPlatformFunc<T>({
  T Function()? onAndroid,
  T Function()? onIOS,
  T Function()? onWindows,
  T Function()? onMacOS,
  T Function()? onLinux,
  T Function()? onWeb,
  required T Function() onDefault, // 通用方法，必须提供
}) {
  if (kIsWeb) {
    return (onWeb ?? onDefault)();
  } else if (Platform.isAndroid) {
    return (onAndroid ?? onDefault)();
  } else if (Platform.isIOS) {
    return (onIOS ?? onDefault)();
  } else if (Platform.isWindows) {
    return (onWindows ?? onDefault)();
  } else if (Platform.isMacOS) {
    return (onMacOS ?? onDefault)();
  } else if (Platform.isLinux) {
    return (onLinux ?? onDefault)();
  } else {
    return onDefault();
  }
}

T runPlatformFuncClass<T>({
  T Function()? onMobile,
  T Function()? onDesktop,
  T Function()? onWeb,
  required T Function() onDefault, // 必须提供通用方法
}) {
  if (kIsWeb) {
    return (onWeb ?? onDefault)();
  } else if (Platform.isAndroid || Platform.isIOS) {
    return (onMobile ?? onDefault)();
  } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    return (onDesktop ?? onDefault)();
  } else {
    return onDefault();
  }
}

T runPlatformFuncClassRecord<T extends Record>({
  T Function()? onMobile,
  T Function()? onDesktop,
  T Function()? onWeb,
  required T Function() onDefault,
}) {
  if (kIsWeb) {
    return (onWeb ?? onDefault)();
  } else if (Platform.isAndroid || Platform.isIOS) {
    return (onMobile ?? onDefault)();
  } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    return (onDesktop ?? onDefault)();
  } else {
    return onDefault();
  }
}


Future<T> runPlatformFuncFuture<T>({
  FutureOr<T> Function()? onAndroid,
  FutureOr<T> Function()? onIOS,
  FutureOr<T> Function()? onWindows,
  FutureOr<T> Function()? onMacOS,
  FutureOr<T> Function()? onLinux,
  FutureOr<T> Function()? onWeb,
  required FutureOr<T> Function() onDefault, // 必须提供
}) async {
  FutureOr<T> Function()? func;

  if (kIsWeb) {
    func = onWeb ?? onDefault;
  } else if (Platform.isAndroid) {
    func = onAndroid ?? onDefault;
  } else if (Platform.isIOS) {
    func = onIOS ?? onDefault;
  } else if (Platform.isWindows) {
    func = onWindows ?? onDefault;
  } else if (Platform.isMacOS) {
    func = onMacOS ?? onDefault;
  } else if (Platform.isLinux) {
    func = onLinux ?? onDefault;
  } else {
    func = onDefault;
  }

  // 统一转成 Future
  return await Future.sync(func);
}
