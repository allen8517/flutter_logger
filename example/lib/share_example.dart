import 'dart:io';

import 'package:flutter_logger/flutter_logger.dart';

/// 日志分享功能示例
class ShareExample {
  static void runExample() async {
    print('=== 日志分享功能示例 ===\n');

    // 初始化日志器
    final config = LogConfig(
      tag: 'share_example',
      enableFile: true,
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.info, LogLevel.warn},
      retainDays: 7,
    );

    final logger = FlutterLogger.init(config);

    // 记录一些日志
    logger.info('APP', '应用启动');
    logger.info('USER', '用户登录');
    logger.warn('NETWORK', '网络连接较慢');
    logger.error('DATABASE', '数据库连接失败');

    // 等待一下，确保日志写入文件
    await Future.delayed(const Duration(seconds: 1));

    // 演示分享方法
    await _demonstrateShareMethods(logger);
  }

  static Future<void> _demonstrateShareMethods(FlutterLogger logger) async {
    print('--- 分享方法演示 ---');

    try {
      // 1. 分享今天的日志文件
      print('1. 分享今天的日志文件');
      await logger.shareTodayLogs(title: '今日应用日志');
      print('✅ 今日日志分享成功');

      // 2. 分享所有日志文件
      print('\n2. 分享所有日志文件');
      await logger.shareAllLogs(title: '完整应用日志');
      print('✅ 所有日志分享成功');

      // 3. 获取日志文件列表
      print('\n3. 获取日志文件列表');
      final files = await logger.getLogFiles();
      print('📁 找到 ${files.length} 个日志文件:');
      for (final file in files) {
        print('   - ${file.path.split('/').last}');
      }
    } catch (e) {
      print('❌ 分享过程中出现错误: $e');
    }
  }
}

/// 高级分享示例
class AdvancedShareExample {
  static void runAdvancedExample() async {
    print('\n=== 高级分享示例 ===\n');

    final config = LogConfig(
      tag: 'advanced_share',
      enableFile: true,
      enableConsole: true,
      fileLevels: {
        LogLevel.error,
        LogLevel.info,
        LogLevel.warn,
        LogLevel.debug
      },
      retainDays: 30,
    );

    final logger = FlutterLogger.init(config);

    // 模拟多天的日志记录
    await _simulateMultiDayLogs(logger);

    // 演示高级分享功能
    await _demonstrateAdvancedSharing(logger);
  }

  static Future<void> _simulateMultiDayLogs(FlutterLogger logger) async {
    print('--- 模拟多天日志记录 ---');

    // 模拟过去几天的日志
    for (int i = 0; i < 3; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      print('记录 ${date.toString().substring(0, 10)} 的日志...');

      logger.info('DAILY', '每日系统检查开始');
      logger.debug('DAILY', '检查时间: ${date.toString()}');
      logger.info('DAILY', '每日系统检查完成');

      if (i == 0) {
        logger.warn('DAILY', '发现系统警告');
      }

      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  static Future<void> _demonstrateAdvancedSharing(FlutterLogger logger) async {
    print('\n--- 高级分享功能演示 ---');

    try {
      // 1. 分享最近3天的日志
      print('1. 分享最近3天的日志');
      final recentFiles = <File>[];
      for (int i = 0; i < 3; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        final file = await logger.getLogFile(date);
        if (file != null) {
          recentFiles.add(file);
        }
      }

      if (recentFiles.isNotEmpty) {
        await logger.sharer.shareFiles(recentFiles, title: '最近3天日志');
        print('✅ 最近3天日志分享成功');
      }

      // 2. 检查日志文件大小
      print('\n2. 检查日志文件大小');
      final allFiles = await logger.getLogFiles();
      for (final file in allFiles) {
        final size = await file.length();
        final sizeInKB = (size / 1024).toStringAsFixed(2);
        print('   ${file.path.split('/').last}: ${sizeInKB} KB');
      }

      // 3. 分享特定大小的日志文件
      print('\n3. 分享大于1KB的日志文件');
      final largeFiles = <File>[];
      for (final file in allFiles) {
        final size = await file.length();
        if (size > 1024) {
          // 大于1KB
          largeFiles.add(file);
        }
      }

      if (largeFiles.isNotEmpty) {
        await logger.sharer.shareFiles(largeFiles, title: '大型日志文件');
        print('✅ 大型日志文件分享成功');
      }
    } catch (e) {
      print('❌ 高级分享过程中出现错误: $e');
    }
  }
}

/// 分享功能使用指南
class ShareGuide {
  static void printGuide() {
    print('\n=== 日志分享使用指南 ===\n');

    print('📤 基本分享方法:');
    print('1. shareTodayLogs() - 分享今天的日志文件');
    print('2. shareLogFile(date) - 分享指定日期的日志文件');
    print('3. shareAllLogs() - 分享所有日志文件');
    print('4. sharer.shareFiles(files) - 分享指定的文件列表');

    print('\n📁 文件获取方法:');
    print('1. getLogFiles() - 获取所有日志文件');
    print('2. getLogFile(date) - 获取指定日期的日志文件');

    print('\n⚙️ 配置选项:');
    print('- title: 设置分享时的标题');
    print('- 文件格式: YYYY-MM-DD.log');
    print('- 文件位置: 应用支持目录');

    print('\n🔧 使用示例:');
    print('''
// 分享今天的日志
await logger.shareTodayLogs(title: '今日日志');

// 分享指定日期
final date = DateTime(2024, 6, 19);
await logger.shareLogFile(date, title: '指定日期日志');

// 分享所有日志
await logger.shareAllLogs(title: '完整日志');

// 自定义分享
final files = await logger.getLogFiles();
await logger.sharer.shareFiles(files, title: '自定义日志');
    ''');
  }
}
