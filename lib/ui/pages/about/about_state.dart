import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:hlbmerge/dao/app_info.dart';

class AboutState {
  AboutState() {
    ///Initialize variables
  }
  //版本名称
  final _appVersionName = '1.0.0'.obs;
  set appVersionName(value) => _appVersionName.value = value;
  get appVersionName => _appVersionName.value;

  //更新数据
   final Rx<AppUpdateData?> _appUpdateData = (null as AppUpdateData?).obs;
   set appUpdateData(AppUpdateData? value) => _appUpdateData.value = value;
  AppUpdateData? get appUpdateData => _appUpdateData.value;
}
