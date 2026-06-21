import 'package:flutter/material.dart';

import '../../../../base/responsive/responsive_widget.dart';
import 'desktop_home.dart';
import 'mobile_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: const MobileHome(),
      tablet: const DesktopHome(),
    );
  }
}
