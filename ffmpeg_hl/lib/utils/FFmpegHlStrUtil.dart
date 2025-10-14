class FFmpegHlStrUtil {
  /// 判断字符串中是否包含任意空格（包括普通空格、全角空格、制表符、换行、不间断空格等）
  static bool containsAnySpace(String text) {
    return RegExp(r'\s').hasMatch(text);
  }
}