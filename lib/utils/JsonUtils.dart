import 'dart:io';
import 'dart:convert';
import 'dart:math';

class JsonUtils {

  /// 尝试修复 JSON
  static dynamic tryFixJson(String input) {
    String fixed = _fixJson(input);

    try {
      return json.decode(fixed);
    } catch (_) {
      fixed = _balanceBrackets(fixed);
      return json.decode(fixed);
    }
  }

  static String _fixJson(String input) {
    String out = input;

    // 去掉多余的逗号
    out = out.replaceAll(RegExp(r',\s*}'), '}');
    out = out.replaceAll(RegExp(r',\s*]'), ']');
    out = out.replaceAll(RegExp(r'^,'), '');
    out = out.replaceAll(RegExp(r',\s*$'), '');

    // 去掉非法控制字符
    out = out.replaceAll(RegExp(r'[\x00-\x1F]'), '');

    return out.trim();
  }

  /// 平衡括号：既能补齐，也能删除多余的
  static String _balanceBrackets(String input) {
    int openCurly = RegExp(r'{').allMatches(input).length;
    int closeCurly = RegExp(r'}').allMatches(input).length;
    int openSquare = RegExp(r'\[').allMatches(input).length;
    int closeSquare = RegExp(r'\]').allMatches(input).length;

    String fixed = input;

    // 如果 { 少，就补 }
    if (openCurly > closeCurly) {
      fixed += '}' * (openCurly - closeCurly);
    }
    // 如果 } 多，就从结尾删掉
    if (closeCurly > openCurly) {
      fixed = fixed.substring(0, fixed.length - (closeCurly - openCurly));
    }

    // 同理处理 []
    if (openSquare > closeSquare) {
      fixed += ']' * (openSquare - closeSquare);
    }
    if (closeSquare > openSquare) {
      fixed = fixed.substring(0, fixed.length - (closeSquare - openSquare));
    }

    return fixed;
  }
}
