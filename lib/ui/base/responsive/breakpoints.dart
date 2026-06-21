enum DeviceType { mobile, tablet, desktop }

class Breakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;

  static DeviceType fromWidth(double width) {
    if (width >= desktop) return DeviceType.desktop;
    if (width >= tablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}
