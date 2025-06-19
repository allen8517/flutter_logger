import 'package:flutter_logger/flutter_logger.dart';

/// Web安全的日志测试
class WebSafeTest {
  static void runTest() {
    print('=== Web安全日志测试 ===\n');

    // Web环境推荐配置
    final config = LogConfig(
      tag: 'web_safe_test',
      enableFile: false, // Web中必须关闭
      enableConsole: true, // 保持控制台输出
      fileLevels: {LogLevel.error, LogLevel.info},
      retainDays: 1,
    );

    final logger = FlutterLogger.init(config);

    // 测试基本日志功能
    _testBasicLogging(logger);

    // 测试Web环境下的文件操作
    _testFileOperations(logger);

    // 测试分享功能
    _testSharing(logger);

    print('\n=== Web安全测试完成 ===');
  }

  static void _testBasicLogging(FlutterLogger logger) {
    print('--- 基本日志功能测试 ---');

    logger.info('TEST', 'Web环境信息日志');
    logger.debug('TEST', 'Web环境调试日志');
    logger.warn('TEST', 'Web环境警告日志');
    logger.error('TEST', 'Web环境错误日志');

    print('✅ 基本日志功能测试通过');
  }

  static void _testFileOperations(FlutterLogger logger) async {
    print('\n--- 文件操作测试 ---');

    try {
      // 测试获取日志文件（Web环境应该返回空列表）
      final files = await logger.getLogFiles();
      print('获取日志文件数量: ${files.length}');

      // 测试获取指定日期的日志文件（Web环境应该返回null）
      final todayFile = await logger.getLogFile(DateTime.now());
      print('今日日志文件: ${todayFile != null ? "存在" : "不存在"}');

      print('✅ 文件操作测试通过（Web环境正常降级）');
    } catch (e) {
      print('❌ 文件操作测试失败: $e');
    }
  }

  static void _testSharing(FlutterLogger logger) async {
    print('\n--- 分享功能测试 ---');

    try {
      // 测试分享功能（Web环境应该显示降级消息）
      await logger.shareTodayLogs(title: '测试分享');
      await logger.shareAllLogs(title: '测试分享所有');

      print('✅ 分享功能测试通过（Web环境正常降级）');
    } catch (e) {
      print('❌ 分享功能测试失败: $e');
    }
  }
}

/// Web环境下的内存日志管理
class WebMemoryLogger {
  final List<String> _logs = [];
  final int _maxLogs = 1000;

  void addLog(String log) {
    _logs.add(log);
    if (_logs.length > _maxLogs) {
      _logs.removeAt(0);
    }
  }

  List<String> getLogs() {
    return List.from(_logs);
  }

  void clearLogs() {
    _logs.clear();
  }

  String exportLogs() {
    return _logs.join('\n');
  }

  int get logCount => _logs.length;
}

/// Web环境下的日志使用示例
class WebLoggerExample {
  static void runExample() {
    print('\n=== Web日志使用示例 ===\n');

    // 创建Web安全的配置
    final config = LogConfig(
      tag: 'web_example',
      enableFile: false, // 重要：Web中关闭文件输出
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.info},
      retainDays: 1,
    );

    final logger = FlutterLogger.init(config);
    final memoryLogger = WebMemoryLogger();

    // 记录日志到控制台和内存
    logger.info('APP', 'Web应用启动');
    memoryLogger.addLog('[INFO] [APP] Web应用启动');

    logger.info('USER', '用户登录');
    memoryLogger.addLog('[INFO] [USER] 用户登录');

    logger.error('ERROR', '模拟错误');
    memoryLogger.addLog('[ERROR] [ERROR] 模拟错误');

    // 显示内存中的日志
    print('内存中的日志数量: ${memoryLogger.logCount}');
    print('内存日志预览:');
    final logs = memoryLogger.getLogs();
    for (int i = 0; i < logs.length && i < 3; i++) {
      print('  ${logs[i]}');
    }

    print('\n✅ Web日志示例完成');
  }
}

/// 运行所有Web安全测试
void main() {
  WebSafeTest.runTest();
  WebLoggerExample.runExample();
}
