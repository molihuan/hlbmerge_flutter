import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: ListView.builder(
      //   itemCount: 1,
      //   itemBuilder: (context, index) {
      //     final item = loadedItems[index];
      //
      //     return CheckboxListTile(
      //       title: Text(item.name),
      //       value: true,
      //       onChanged: (bool? selected) {},
      //     );
      //   },
      // ),
    );
  }
}
