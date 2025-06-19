import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../core/log_level.dart';
import '../core/log_config.dart';
import '../core/log_formatter.dart';

class LogWriter {
  final LogConfig config;

  LogWriter(this.config);

  Future<String?> _getLogFilePath(DateTime date) async {
    if (kIsWeb) {
      // Web环境不支持文件系统，返回null
      return null;
    }

    try {
      // 尝试使用path_provider
      final pathProvider = await _getPathProvider();
      if (pathProvider == null) return null;

      final dir = await pathProvider.getApplicationSupportDirectory();
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      return '${dir.path}/${config.tag}_$dateStr.log';
    } catch (e) {
      // 如果path_provider不可用，返回null
      return null;
    }
  }

  Future<dynamic> _getPathProvider() async {
    if (kIsWeb) {
      return null;
    }

    try {
      // 使用条件导入
      return await _importPathProvider();
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> _importPathProvider() async {
    // 这里使用延迟导入，避免Web环境错误
    try {
      // 在实际应用中，这里应该使用条件导入
      // 为了简化，我们直接返回null，让调用者处理
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> write(String module, String message, LogLevel level) async {
    final line = LogFormatter.format(
      tag: config.tag,
      level: level,
      module: module,
      message: message,
    );

    if (config.enableConsole) {
      level == LogLevel.error ? debugPrint(line) : print(line);
    }

    if (config.enableFile && config.fileLevels.contains(level)) {
      if (!kIsWeb) {
        // 只在非Web环境尝试文件写入
        await _writeToFile(line);
      }
    }
  }

  Future<void> _writeToFile(String line) async {
    try {
      final path = await _getLogFilePath(DateTime.now());
      if (path != null) {
        final file = File(path);
        await file.writeAsString('$line\n', mode: FileMode.append, flush: true);
        await _cleanOldLogs();
      }
    } catch (e) {
      // 文件写入失败时，只记录到控制台
      print('文件写入失败: $e');
    }
  }

  Future<void> _cleanOldLogs() async {
    if (kIsWeb) {
      return; // Web环境跳过文件清理
    }

    try {
      final pathProvider = await _getPathProvider();
      if (pathProvider == null) return;

      final dir = await pathProvider.getApplicationSupportDirectory();
      final files = dir.listSync();
      final now = DateTime.now();

      for (var f in files) {
        if (f is File && f.path.contains('${config.tag}_')) {
          final name = f.uri.pathSegments.last;
          final match = RegExp(r'(\d{4}-\d{2}-\d{2})').firstMatch(name);
          if (match != null) {
            final date = DateTime.tryParse(match.group(1)!);
            if (date != null &&
                now.difference(date).inDays > config.retainDays) {
              await f.delete();
            }
          }
        }
      }
    } catch (e) {
      // 文件清理失败时，只记录到控制台
      print('文件清理失败: $e');
    }
  }
}
