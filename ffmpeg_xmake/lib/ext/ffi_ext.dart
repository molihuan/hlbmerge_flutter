import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';

extension StringListToNativeExt on List<String> {
  /// List<String> -> char**
  ffi.Pointer<ffi.Pointer<Utf8>> toNativeUtf8Array() {
    final ptr = calloc<ffi.Pointer<Utf8>>(length);

    for (var i = 0; i < length; i++) {
      ptr[i] = this[i].toNativeUtf8(allocator: calloc);
    }

    return ptr;
  }

  /// with
  R withNativeUtf8Array<R>(
    R Function(ffi.Pointer<ffi.Pointer<Utf8>> ptr) action,
  ) {
    final ptr = toNativeUtf8Array();

    try {
      return action(ptr);
    } finally {
      ptr.freeArray(length);
    }
  }
}

extension NativeArrayExt on ffi.Pointer<ffi.Pointer<ffi.NativeType>> {
  /// 释放数组
  void freeArray(int count) {
    if (isNullPtr()) {
      return;
    }

    for (var i = 0; i < count; i++) {
      if (this[i].isNullPtr()) {
        continue;
      }
      calloc.free(this[i]);
    }

    calloc.free(this);
  }
}

extension NativePointerExt on ffi.Pointer {
  //判断指针是否为空
  bool isNullPtr() {
    return this == ffi.nullptr || address == 0;
  }
}
