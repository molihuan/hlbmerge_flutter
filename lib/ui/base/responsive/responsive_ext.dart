import 'package:flutter/widgets.dart';

import 'responsive.dart';

extension ResponsiveExt on BuildContext {
  Responsive get responsive => Responsive.fromWidth(MediaQuery.sizeOf(this).width);
}
