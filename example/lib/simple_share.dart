import 'package:flutter_logger/flutter_logger.dart';

/// 简单的日志分享示例
class SimpleShareExample {
  static void runExample() async {
    print('=== 简单日志分享示例 ===\n');

    // 初始化日志器
    final config = LogConfig(
      tag: 'simple_share',
      enableFile: true,
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.info},
      retainDays: 7,
    );

    final logger = FlutterLogger.init(config);

    // 记录一些日志
    logger.info('APP', '应用启动');
    logger.info('USER', '用户登录');
    logger.error('ERROR', '发生错误');

    // 等待日志写入
    await Future.delayed(const Duration(seconds: 1));

    // 分享日志
    await _shareLogs(logger);
  }

  static Future<void> _shareLogs(FlutterLogger logger) async {
    print('--- 分享日志 ---');

    try {
      // 分享今天的日志
      await logger.shareTodayLogs(title: '应用日志');
      print('✅ 日志分享成功');

      // 获取文件信息
      final files = await logger.getLogFiles();
      print('📁 找到 ${files.length} 个日志文件');
    } catch (e) {
      print('❌ 分享失败: $e');
    }
  }
}
