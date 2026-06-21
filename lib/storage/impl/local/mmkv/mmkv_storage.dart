import 'package:flutter/cupertino.dart';
import 'package:mmkv/mmkv.dart';

import '../../local_storage.dart';

class MMKVStorage extends LocalStorage {
  late final _mmkv = MMKV.defaultMMKV();

  @override
  Future<void> init() async {
    final rootDir = await MMKV.initialize(rootDir: getDataStoragePath());
    debugPrint('MMKV for flutter with rootDir = $rootDir');
  }

  @override
  T loadValue<T>(String key, {required T defaultValue}) {
    // 默认值不支持可空类型
    dynamic result;
    if (T == String) {
      result = _mmkv.decodeString(key);
    } else if (T == int) {
      result = _mmkv.decodeInt(key, defaultValue: defaultValue as int);
    } else if (T == double) {
      result = _mmkv.decodeDouble(key, defaultValue: defaultValue as double);
    } else if (T == bool) {
      result = _mmkv.decodeBool(key, defaultValue: defaultValue as bool);
    } else if (T == MMBuffer) {
      result = _mmkv.decodeBytes(key);
    } else {
      throw Exception('Unsupported type: $T');
    }

    return (result ?? defaultValue) as T;
  }

  @override
  void saveValue<T>(String key, T value) {
    if (value == null) {
      _mmkv.removeValue(key);
      return;
    }

    if (value is String) {
      _mmkv.encodeString(key, value);
    } else if (value is int) {
      _mmkv.encodeInt(key, value);
    } else if (value is double) {
      _mmkv.encodeDouble(key, value);
    } else if (value is bool) {
      _mmkv.encodeBool(key, value);
    } else if (value is MMBuffer) {
      _mmkv.encodeBytes(key, value);
    } else {
      throw Exception('Unsupported type: ${value.runtimeType}');
    }
  }

  @override
  void removeAll() {
    _mmkv.clearAll();
  }

  @override
  void remove(String key) {
    _mmkv.removeValue(key);
  }
}
