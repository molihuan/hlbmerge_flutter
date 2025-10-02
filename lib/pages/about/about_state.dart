import 'package:get/get.dart';

class AboutState {
  AboutState() {
    ///Initialize variables
  }

  final _appVersionName = '1.0.0'.obs;
  set appVersionName(value) => _appVersionName.value = value;
  get appVersionName => _appVersionName.value;
}
