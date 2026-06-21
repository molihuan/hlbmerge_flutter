import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Log {
  Log._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
    level: kReleaseMode ? Level.off : Level.all,
  );

  static void d(dynamic msg) => _logger.d(msg);

  static void i(dynamic msg) => _logger.i(msg);

  static void w(dynamic msg) => _logger.w(msg);

  static void e(dynamic msg, [Object? err, StackTrace? st]) =>
      _logger.e(msg, error: err, stackTrace: st);
}
