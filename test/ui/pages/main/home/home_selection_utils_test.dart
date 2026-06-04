import 'package:flutter_test/flutter_test.dart';
import 'package:hlbmerge/models/cache_group.dart';
import 'package:hlbmerge/models/cache_item.dart';
import 'package:hlbmerge/ui/pages/main/home/home_selection_utils.dart';

CacheGroup _buildGroup(
  String title, {
  String? path,
  bool checked = false,
  List<CacheItem>? items,
}) {
  final group = CacheGroup()
    ..title = title
    ..path = path
    ..checked = checked;
  group.cacheItemList = items ?? <CacheItem>[];
  return group;
}

CacheItem _buildItem(
  String title, {
  String? path,
  bool checked = false,
}) {
  return CacheItem()
    ..title = title
    ..path = path
    ..checked = checked;
}

void main() {
  test('fuzzy search matches group title and nested cache item metadata', () {
    final groups = [
      _buildGroup(
        '动画收藏',
        path: '/cache/anime',
        items: [_buildItem('第01话')],
      ),
      _buildGroup(
        '课程合集',
        path: '/cache/course',
        items: [_buildItem('Flutter Widget 进阶')],
      ),
    ];

    final titleMatches = HomeSelectionUtils.filterCacheGroups(groups, '动画');
    final itemMatches = HomeSelectionUtils.filterCacheGroups(groups, 'widgt');

    expect(titleMatches.map((group) => group.title), ['动画收藏']);
    expect(itemMatches.map((group) => group.title), ['课程合集']);
  });

  test('selection snapshot includes direct and nested selections', () {
    final selectedGroup = _buildGroup('已选分组', checked: true);
    final nestedSelectedGroup = _buildGroup(
      '子项已选分组',
      items: [
        _buildItem('片段1', checked: true),
        _buildItem('片段2'),
      ],
    );

    final snapshot = HomeSelectionUtils.buildSelectionSnapshot([
      selectedGroup,
      nestedSelectedGroup,
    ]);

    expect(snapshot.selectedGroupCount, 1);
    expect(snapshot.selectedItemCount, 1);
    expect(snapshot.selectedDisplayCount, 2);
  });

  test('clear group selection removes both direct and nested checks', () {
    final group = _buildGroup(
      '待清空',
      checked: true,
      items: [
        _buildItem('片段1', checked: true),
        _buildItem('片段2', checked: true),
      ],
    );

    HomeSelectionUtils.clearGroupSelection(group);

    expect(group.checked, isFalse);
    expect(group.cacheItemList.every((item) => !item.checked), isTrue);
    expect(HomeSelectionUtils.hasVisibleSelection(group), isFalse);
  });
}
