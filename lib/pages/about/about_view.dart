import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'about_logic.dart';
import 'about_state.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AboutLogic logic = Get.put(AboutLogic());
    final AboutState state = Get.find<AboutLogic>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('关于&教程'),
      ),
      body: Container(
        child: ListView(children: [
          //软件版本
          Obx((){
            return ListTile(
              title: const Text('软件版本'),
              trailing: Text(state.appVersionName),
            );
          }),
          //开源地址跳转
          ListTile(
            title: const Text('开源地址'),
            subtitle: Text(logic.openSourceUrl),
            onTap: (){
              logic.goOpenSourceUrl();
            },
          ),
          ListTile(
            title: const Text('教程'),
            onTap: (){
              logic.goTutorialUrl();
            },
          ),


        ],),
      ),
    );
  }
}
