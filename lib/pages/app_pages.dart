
import 'package:get/get_navigation/src/routes/get_route.dart';

import 'about/about_binding.dart';
import 'about/about_view.dart';
import 'main/binding.dart';
import 'main/view.dart';
//页面路由
class AppRoutes {
  static const MainPage = '/MainPage';
  static const AboutPage = '/AboutPage';
}

class AppPages {
  static const INITIAL = AppRoutes.MainPage;

  static final routes = [
    GetPage(
      name: AppRoutes.MainPage,
      page: () => MainPage(),
      bindings: [
        MainBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.AboutPage,
      page: () => AboutPage(),
      bindings: [
        AboutBinding(),
      ],
    ),
  ];
}