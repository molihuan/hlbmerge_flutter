import 'package:flutter/material.dart';

import 'breakpoints.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final type = Breakpoints.fromWidth(width);

    return switch (type) {
      DeviceType.desktop => desktop ?? tablet ?? mobile,
      DeviceType.tablet => tablet ?? mobile,
      DeviceType.mobile => mobile,
    };
  }
}
