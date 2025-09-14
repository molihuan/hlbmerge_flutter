import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

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

  //判断路径是否为文件夹
  static bool isDir(String path) {
    return FileSystemEntity.isDirectorySync(path);
  }
  //判断路径是否为文件
  static bool isFile(String path) {
    return FileSystemEntity.isFileSync(path);
  }

  // 解密电脑缓存文件2024.03之后的
  static Future<bool>  decryptPcM4sAfter202403(
      String targetPath,
      String outputPath, {
        int bufSize = 256 * 1024 * 1024, // 256MB
      }) async {
    final targetFile = File(targetPath);
    final outputFile = File(outputPath);

    final target = await targetFile.open();
    final output = await outputFile.open(mode: FileMode.write);

    try {
      // 1. 读取前 32 字节
      final headerBytes = await target.read(32);

      // 2. 转成字符串再替换（只会动 ASCII 部分）
      var headerStr = ascii.decode(headerBytes, allowInvalid: true);
      headerStr = headerStr.replaceAll("000000000", "");
      final newHeader = ascii.encode(headerStr);

      // 3. 写入替换后的 header
      await output.writeFrom(newHeader);

      // 4. 分块写剩余的内容
      while (true) {
        final chunk = await target.read(bufSize);
        if (chunk.isEmpty) break;
        await output.writeFrom(chunk);
      }
    } catch (e) {
      print(e);
      return false;
    } finally {
      await target.close();
      await output.close();
    }
    return true;
  }

  /// 获取一个不重复的文件路径
  static Future<String> getAvailableFilePath(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      return filePath;
    }

    final dir = p.dirname(filePath);
    final baseName = p.basenameWithoutExtension(filePath);
    final extension = p.extension(filePath);

    int counter = 0;
    String newPath;

    do {
      newPath = p.join(dir, '$baseName($counter)$extension');
      counter++;
    } while (await File(newPath).exists());

    return newPath;
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
