import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hlbmerge/dao/sp_data_manager.dart';
import 'package:hlbmerge/models/cache_group.dart';
import 'package:hlbmerge/models/cache_item.dart';
import 'package:hlbmerge/ui/pages/main/home/logic.dart';
import 'package:hlbmerge/ui/pages/main/home/view.dart';

CacheGroup _buildGroup(String title, {int itemCount = 0}) {
  final group = CacheGroup()..title = title;
  group.cacheItemList = List.generate(itemCount, (index) {
    return CacheItem()
      ..title = '$title-$index'
      ..path = '/cache/$title/$index';
  });
  return group;
}

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await SpDataManager.init();
    Get.reset();
  });

  tearDown(() async {
    Get.reset();
  });

  testWidgets('home page renders a draggable scrollbar for cache groups',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: HomePage(),
        ),
      ),
    );

    final logic = Get.find<HomeLogic>();
    logic.state.hasPermission = true;
    logic.state.cacheGroupList =
        List.generate(24, (index) => _buildGroup('group-$index', itemCount: 1));

    await tester.pump();

    expect(find.byType(Scrollbar), findsOneWidget);
  });

  testWidgets('tapping a cache group opens the item dialog without GetX errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: HomePage(),
        ),
      ),
    );

    final logic = Get.find<HomeLogic>();
    final group = _buildGroup('group-0', itemCount: 2);
    group.cacheItemList[0].title = 'episode-0';
    group.cacheItemList[1].title = 'episode-1';
    logic.state.hasPermission = true;
    logic.state.cacheGroupList = [group];

    await tester.pump();

    await tester.tap(find.text('group-0'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('请选择需要合并的缓存项'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    expect(
      logic.state.cacheGroupList.first.cacheItemList.first.checked,
      isTrue,
    );
  });
}
