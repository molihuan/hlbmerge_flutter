import 'settings_repository.dart';

class AppRepository {
  AppRepository._();

  static Future<void> init() async {
    // 初始化设置仓库
    await SettingsRepository.init();
  }
}
