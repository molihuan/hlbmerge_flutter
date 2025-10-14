class StrUtils {
  /// 判断字符串中是否包含任意空格（包括普通空格、全角空格、制表符、换行、不间断空格等）
  static bool containsAnySpace(String text) {
    return RegExp(r'\s').hasMatch(text);
  }

  // 处理windows文件名中的非法字符
  static String? sanitizeWindowsFileName(final String? fileName) {
    if (fileName == null) {
      return null;
    }
    // 1. 替换非法字符
    final illegalChars = RegExp(r'[<>:"/\\|?*]');
    String sanitized = fileName.replaceAll(illegalChars, '_');

    // 2. 去掉文件名开头和结尾的空格或句点
    sanitized = sanitized.replaceAll(RegExp(r'^[ .]+|[ .]+$'), '_');

    // 3. 检查是否为保留名称（忽略大小写）
    final reservedNames = [
      'CON', 'PRN', 'AUX', 'NUL',
      'COM1','COM2','COM3','COM4','COM5','COM6','COM7','COM8','COM9',
      'LPT1','LPT2','LPT3','LPT4','LPT5','LPT6','LPT7','LPT8','LPT9'
    ];

    String baseName = sanitized;
    String? extension;

    // 分离扩展名
    final dotIndex = sanitized.lastIndexOf('.');
    if (dotIndex != -1) {
      baseName = sanitized.substring(0, dotIndex);
      extension = sanitized.substring(dotIndex);
    }

    if (reservedNames.contains(baseName.toUpperCase())) {
      baseName = '_$baseName';
    }

    return extension != null ? '$baseName$extension' : baseName;
  }

  static String? sanitizeLinuxFileName(String? fileName) {
    if (fileName == null) {
      return null;
    }
    if (fileName.isEmpty) return '_';

    // 1. 替换非法字符 `/`
    String sanitized = fileName.replaceAll('/', '_');

    // 2. 去掉开头和结尾的空格
    sanitized = sanitized.replaceAll(RegExp(r'^[ ]+|[ ]+$'), '_');

    // 3. 如果最终为空，设置为下划线
    if (sanitized.isEmpty) sanitized = '_';

    return sanitized;
  }

  static String? sanitizeAndroidFileName(final String? fileName, {int maxLength = 255}) {
    if (fileName == null) {
      return null;
    }
    if (fileName.isEmpty) return '_';

    // 1. 替换非法字符
    final illegalChars = RegExp(r'[<>:"/\\|?*]');
    String sanitized = fileName.replaceAll(illegalChars, '_');

    // 2. 去掉首尾空格或点
    sanitized = sanitized.replaceAll(RegExp(r'^[ .]+|[ .]+$'), '_');

    // 3. 限制最大长度
    if (sanitized.length > maxLength) {
      sanitized = sanitized.substring(0, maxLength);
    }

    // 4. 空字符串处理
    if (sanitized.isEmpty) sanitized = '_';

    return sanitized;
  }

}