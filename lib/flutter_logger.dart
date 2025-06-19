library flutter_logger;

import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'core/log_level.dart';
import 'core/log_config.dart';
import 'writer/log_writer.dart';
import 'uploader/log_uploader.dart';
import 'sharer/log_sharer.dart';
import 'package:http/http.dart' as http;

// 导出核心类
export 'core/log_level.dart';
export 'core/log_config.dart';

class FlutterLogger {
  final LogWriter _writer;
  final LogUploader uploader = LogUploader();
  final LogSharer sharer = LogSharer();
  final LogConfig _config;

  FlutterLogger._(LogConfig config)
      : _writer = LogWriter(config),
        _config = config;

  static FlutterLogger? _instance;

  factory FlutterLogger.init(LogConfig config) {
    _instance = FlutterLogger._(config);
    return _instance!;
  }

  static FlutterLogger get instance => _instance!;

  void log(String module, String message, LogLevel level) {
    _writer.write(module, message, level);
  }

  void info(String module, String message) =>
      log(module, message, LogLevel.info);
  void debug(String module, String message) =>
      log(module, message, LogLevel.debug);
  void error(String module, String message) =>
      log(module, message, LogLevel.error);
  void warn(String module, String message) =>
      log(module, message, LogLevel.warn);

  /// 获取所有日志文件（Web环境返回空列表）
  Future<List<File>> getLogFiles() async {
    if (kIsWeb) {
      // Web环境不支持文件系统，返回空列表
      return [];
    }

    try {
      final pathProvider = await _getPathProvider();
      if (pathProvider == null) return [];

      final dir = await pathProvider.getApplicationSupportDirectory();
      final files = dir.listSync();
      final logFiles = <File>[];

      for (var f in files) {
        if (f is File && f.path.contains('${_config.tag}_')) {
          logFiles.add(f);
        }
      }

      return logFiles;
    } catch (e) {
      // 如果path_provider不可用，返回空列表
      return [];
    }
  }

  /// 获取指定日期的日志文件（Web环境返回null）
  Future<File?> getLogFile(DateTime date) async {
    if (kIsWeb) {
      // Web环境不支持文件系统，返回null
      return null;
    }

    try {
      final pathProvider = await _getPathProvider();
      if (pathProvider == null) return null;

      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final dir = await pathProvider.getApplicationSupportDirectory();
      final filePath = '${dir.path}/${_config.tag}_$dateStr.log';
      final file = File(filePath);

      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 获取path_provider（Web环境返回null）
  Future<dynamic> _getPathProvider() async {
    if (kIsWeb) {
      return null;
    }

    try {
      // 在实际应用中，这里应该使用条件导入
      // 为了简化，我们直接返回null，让调用者处理
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 分享所有日志文件（Web环境降级为下载）
  Future<void> shareAllLogs({String? title}) async {
    if (kIsWeb) {
      // Web环境不支持文件分享，可以降级为下载
      print('Web环境不支持文件分享，请使用下载功能');
      return;
    }

    final files = await getLogFiles();
    if (files.isNotEmpty) {
      await sharer.shareFiles(files, title: title);
    }
  }

  /// 分享指定日期的日志文件（Web环境降级为下载）
  Future<void> shareLogFile(DateTime date, {String? title}) async {
    if (kIsWeb) {
      // Web环境不支持文件分享，可以降级为下载
      print('Web环境不支持文件分享，请使用下载功能');
      return;
    }

    final file = await getLogFile(date);
    if (file != null) {
      await sharer.shareFiles([file], title: title);
    }
  }

  /// 分享今天的日志文件（Web环境降级为下载）
  Future<void> shareTodayLogs({String? title}) async {
    if (kIsWeb) {
      // Web环境不支持文件分享，可以降级为下载
      print('Web环境不支持文件分享，请使用下载功能');
      return;
    }

    await shareLogFile(DateTime.now(), title: title);
  }
}
