import 'dart:io';

class FileUtil {
  // 获取子目录列表
  static List<String> allDirStr(String path) {
    return FileUtil.allDir(path).map((e) => e.path).toList();
  }

  // 获取子目录列表
  static List<Directory> allDir(String path) {
    final dir = Directory(path);
    if (!dir.existsSync()) return [];

    return dir.listSync().whereType<Directory>().map((e) => e).toList();
  }

  // 获取文件列表
  static List<String> allFileStr(String path) {
    return FileUtil.allFile(path).map((e) => e.path).toList();
  }

  // 获取文件列表
  static List<File> allFile(String path) {
    final dir = Directory(path);
    if (!dir.existsSync()) return [];

    return dir.listSync().whereType<File>().map((e) => e).toList();
  }
}
