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

  //当前exe所在文件夹
  static Directory getCurrExeDir() {
    String exePath = Platform.resolvedExecutable;
    Directory exeDir = File(exePath).parent;
    //print('程序所在目录: $exeDir');
    return exeDir;
  }

}

//文件格式枚举
enum FileFormat {
  //mp4
  mp4("mp4"),
  //mp3
  mp3("mp3");
  // 属性
  final String extension;

  // 构造函数
  const FileFormat(this.extension);
}
