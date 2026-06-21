import 'breakpoints.dart';

class Responsive {
  final DeviceType type;

  const Responsive._(this.type);

  factory Responsive.fromWidth(double width) {
    return Responsive._(Breakpoints.fromWidth(width));
  }

  bool get isMobile => type == DeviceType.mobile;
  bool get isTablet => type == DeviceType.tablet;
  bool get isDesktop => type == DeviceType.desktop;

  T call<T>({required T mobile, T? tablet, T? desktop}) {
    switch (type) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }
}
