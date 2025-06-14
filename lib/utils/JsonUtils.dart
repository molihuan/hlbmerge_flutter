import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:hlbmerge/models/cache_json_info.dart';

class JsonUtils {
  static CacheJsonInfo parseCacheJson(String? filePath) {
    if (filePath == null || !File(filePath).existsSync()) {
      return getUUIDJson();
    }

    try {
      final content = File(filePath).readAsStringSync();
      final Map<String, dynamic> data = json.decode(content);

      String? title;
      String? subTitle;
      String? bvid = _getString(data, 'bvid');
      String? avid = _getString(data, 'avid');
      int? cid;
      String? cover;

      title = _getFirstNonNull([
            () => _getString(data, 'groupTitle'),
            () => _getString(data, 'title'),
            () => _getString(data, 'groupId'),
            () => bvid,
            () => avid,
      ]);

      subTitle = _getFirstNonNull([
            () => data['title'] == title ? null : _getString(data, 'title'),
            () => _getString(data, 'tabName'),
      ]);

      if (data.containsKey('page_data')) {
        final pageData = data['page_data'];
        subTitle ??= _getFirstNonNull([
              () => _cleanSubtitle(_getString(pageData, 'download_subtitle'), title),
              () => _cleanSubtitle(_getString(pageData, 'part'), title),
              () => _getString(pageData, 'page')?.toString(),
              () {
            final cidStr = pageData['cid']?.toString();
            cid = int.tryParse(cidStr ?? '');
            return cidStr;
          }
        ]);
      }

      if (data.containsKey('ep')) {
        final ep = data['ep'];
        subTitle ??= _getFirstNonNull([
              () => _getString(ep, 'index_title'),
              () => _getString(ep, 'index'),
        ]);
      }

      cover = _getString(data, 'coverPath') ?? _getString(data, 'cover');

      title = _cleanString(title) ?? generateShortId();
      subTitle = _cleanString(subTitle) ?? title;

      return CacheJsonInfo(
        title: title,
        subTitle: subTitle,
        bvid: bvid,
        avid: avid,
        cid: cid,
        cover: cover,
      );
    } catch (e) {
      // 可选：记录错误日志
      return getUUIDJson();
    }
  }

  static String? _getString(dynamic data, String key) {
    if (data is Map && data.containsKey(key)) {
      final value = data[key];
      return value is String ? value : value?.toString();
    }
    return null;
  }

  static String? _getFirstNonNull(List<String? Function()> getters) {
    for (var get in getters) {
      final value = get();
      if (value != null && value.trim().isNotEmpty) return value;
    }
    return null;
  }

  static String? _cleanSubtitle(String? input, String? title) {
    if (input == null || input.isEmpty) return null;
    return input.replaceAll(title ?? '', '');
  }

  static String? _cleanString(String? input) {
    return input?.replaceAll(RegExp(r'\s'), '');
  }

  static String generateShortId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final suffix = List.generate(5, (_) => chars[random.nextInt(chars.length)]).join();
    return '$timestamp$suffix';
  }

  static CacheJsonInfo getUUIDJson() {
    final id =  generateShortId();
    return CacheJsonInfo(title: id, subTitle: id);
  }
}
