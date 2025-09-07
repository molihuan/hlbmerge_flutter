import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class ProgressPage extends StatelessWidget {
  ProgressPage({Key? key}) : super(key: key);

  final ProgressLogic logic = Get.put(ProgressLogic());
  final ProgressState state = Get.find<ProgressLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('ProgressPage'),),
    );
  }
}
