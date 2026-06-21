abstract class BaseStorage {
  //初始化
  Future<void> init();

  //保存数据
  void saveValue<T>(String key, T value);

  //加载数据
  T loadValue<T>(String key, {required T defaultValue});

  void removeAll();

  void remove(String key);
}
