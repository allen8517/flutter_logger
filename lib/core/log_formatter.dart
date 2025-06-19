import 'log_level.dart';
import 'package:intl/intl.dart';

class LogFormatter {
  static String format({
    required String tag,
    required LogLevel level,
    required String module,
    required String message,
  }) {
    final now = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now());
    final levelStr = level.name.toLowerCase();
    return '[$now] [$tag] [$levelStr] [$module]$message';
  }
}
