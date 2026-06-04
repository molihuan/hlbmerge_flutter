import '../../../../models/cache_group.dart';
import '../../../../models/cache_item.dart';

class HomeSelectionSnapshot {
  const HomeSelectionSnapshot({
    required this.selectedGroupCount,
    required this.selectedItemCount,
    required this.selectedDisplayCount,
  });

  final int selectedGroupCount;
  final int selectedItemCount;
  final int selectedDisplayCount;

  bool get hasSelection =>
      selectedGroupCount > 0 ||
      selectedItemCount > 0 ||
      selectedDisplayCount > 0;
}

class HomeSelectionUtils {
  static List<CacheGroup> filterCacheGroups(
      Iterable<CacheGroup> groups, String keyword) {
    final normalizedKeyword = _normalize(keyword);
    if (normalizedKeyword.isEmpty) {
      return groups.toList(growable: false);
    }

    return groups
        .where((group) => _matchesGroup(group, normalizedKeyword))
        .toList(growable: false);
  }

  static HomeSelectionSnapshot buildSelectionSnapshot(
      Iterable<CacheGroup> groups) {
    int selectedGroupCount = 0;
    int selectedItemCount = 0;
    int selectedDisplayCount = 0;

    for (final group in groups) {
      if (group.checked) {
        selectedGroupCount++;
      }

      selectedItemCount += selectedItemCountForGroup(group);

      if (hasVisibleSelection(group)) {
        selectedDisplayCount++;
      }
    }

    return HomeSelectionSnapshot(
      selectedGroupCount: selectedGroupCount,
      selectedItemCount: selectedItemCount,
      selectedDisplayCount: selectedDisplayCount,
    );
  }

  static bool hasVisibleSelection(CacheGroup group) {
    return group.checked || selectedItemCountForGroup(group) > 0;
  }

  static int selectedItemCountForGroup(CacheGroup group) {
    return group.cacheItemList.where((item) => item.checked).length;
  }

  static void clearGroupSelection(CacheGroup group) {
    group.checked = false;
    for (final item in group.cacheItemList) {
      item.checked = false;
    }
  }

  static void clearSelections(Iterable<CacheGroup> groups) {
    for (final group in groups) {
      clearGroupSelection(group);
    }
  }

  static bool _matchesGroup(CacheGroup group, String normalizedKeyword) {
    if (_matchesAnyField(normalizedKeyword, [
      group.title,
      group.subTitle,
      group.path,
      group.groupId,
    ])) {
      return true;
    }

    for (final item in group.cacheItemList) {
      if (_matchesCacheItem(item, normalizedKeyword)) {
        return true;
      }
    }

    return false;
  }

  static bool _matchesCacheItem(CacheItem item, String normalizedKeyword) {
    return _matchesAnyField(normalizedKeyword, [
      item.title,
      item.subTitle,
      item.path,
      item.parentPath,
      item.groupTitle,
      item.bvId,
      item.avId,
      item.cId,
    ]);
  }

  static bool _matchesAnyField(
      String normalizedKeyword, Iterable<String?> fields) {
    for (final field in fields) {
      final normalizedField = _normalize(field);
      if (normalizedField.isEmpty) {
        continue;
      }

      if (normalizedField.contains(normalizedKeyword) ||
          _isSubsequence(normalizedKeyword, normalizedField)) {
        return true;
      }
    }
    return false;
  }

  static String _normalize(String? value) {
    if (value == null) {
      return '';
    }

    return value.toLowerCase().replaceAll(RegExp(r'\s+'), '');
  }

  static bool _isSubsequence(String needle, String haystack) {
    if (needle.isEmpty) {
      return true;
    }

    var haystackIndex = 0;
    for (final rune in needle.runes) {
      var matched = false;
      while (haystackIndex < haystack.length) {
        if (haystack.codeUnitAt(haystackIndex) == rune) {
          matched = true;
          haystackIndex++;
          break;
        }
        haystackIndex++;
      }

      if (!matched) {
        return false;
      }
    }

    return true;
  }
}
