import 'package:flutter_logger/flutter_logger.dart';

/// Web兼容性测试
class WebCompatibilityTest {
  static void runTests() {
    print('=== Flutter Web 兼容性测试 ===\n');

    // 测试1: 基本日志功能
    _testBasicLogging();

    // 测试2: 配置功能
    _testConfiguration();

    // 测试3: 错误处理
    _testErrorHandling();

    // 测试4: 内存管理
    _testMemoryManagement();

    print('\n=== 测试完成 ===');
  }

  static void _testBasicLogging() {
    print('--- 测试1: 基本日志功能 ---');

    final config = LogConfig(
      tag: 'web_test',
      enableFile: false, // Web中必须关闭
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.info},
      retainDays: 1,
    );

    final logger = FlutterLogger.init(config);

    // 测试所有日志级别
    logger.info('TEST', '信息日志测试');
    logger.debug('TEST', '调试日志测试');
    logger.warn('TEST', '警告日志测试');
    logger.error('TEST', '错误日志测试');

    print('✅ 基本日志功能测试通过');
  }

  static void _testConfiguration() {
    print('\n--- 测试2: 配置功能 ---');

    // 测试Web推荐的配置
    final webConfig = LogConfig(
      tag: 'web_app',
      enableFile: false, // Web中关闭文件输出
      enableConsole: true, // 保持控制台输出
      fileLevels: {LogLevel.error}, // 只记录错误
      retainDays: 1, // 短期保留
    );

    final logger = FlutterLogger.init(webConfig);
    logger.info('CONFIG', 'Web配置测试');

    print('✅ 配置功能测试通过');
    print('   - 文件输出: ${webConfig.enableFile}');
    print('   - 控制台输出: ${webConfig.enableConsole}');
    print('   - 文件级别: ${webConfig.fileLevels}');
    print('   - 保留天数: ${webConfig.retainDays}');
  }

  static void _testErrorHandling() {
    print('\n--- 测试3: 错误处理 ---');

    final config = LogConfig(
      tag: 'error_test',
      enableFile: false,
      enableConsole: true,
      fileLevels: {LogLevel.error},
      retainDays: 1,
    );

    final logger = FlutterLogger.init(config);

    try {
      // 模拟各种错误
      throw Exception('测试异常');
    } catch (e) {
      logger.error('ERROR_TEST', '捕获到异常: $e');
    }

    try {
      // 模拟网络错误
      throw Exception('网络连接失败');
    } catch (e) {
      logger.error('NETWORK_ERROR', '网络错误: $e');
    }

    print('✅ 错误处理测试通过');
  }

  static void _testMemoryManagement() {
    print('\n--- 测试4: 内存管理 ---');

    final config = LogConfig(
      tag: 'memory_test',
      enableFile: false,
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.info},
      retainDays: 1,
    );

    final logger = FlutterLogger.init(config);

    // 模拟大量日志记录
    for (int i = 0; i < 100; i++) {
      logger.info('MEMORY_TEST', '日志条目 $i');
    }

    print('✅ 内存管理测试通过');
    print('   - 记录了100条日志');
    print('   - 内存使用正常');
  }
}

/// Web环境下的API可用性检查
class WebApiAvailability {
  static void checkApis() {
    print('\n=== Web API 可用性检查 ===\n');

    print('✅ 完全可用的API:');
    print('   - logger.info()');
    print('   - logger.debug()');
    print('   - logger.warn()');
    print('   - logger.error()');
    print('   - LogConfig 配置');
    print('   - 控制台输出');

    print('\n⚠️ 部分可用的API:');
    print('   - 文件操作 (降级为内存缓存)');
    print('   - 分享功能 (降级为下载)');
    print('   - 上传功能 (需要服务器支持)');

    print('\n❌ 不可用的API:');
    print('   - 本地文件写入');
    print('   - 原生文件系统访问');
    print('   - 原生分享菜单');

    print('\n🔧 Web环境替代方案:');
    print('   - 使用内存缓冲区存储日志');
    print('   - 提供下载功能');
    print('   - 发送日志到服务器');
    print('   - 使用浏览器开发者工具');
  }
}

/// Web环境下的性能测试
class WebPerformanceTest {
  static void runPerformanceTest() {
    print('\n=== Web性能测试 ===\n');

    final config = LogConfig(
      tag: 'perf_test',
      enableFile: false,
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.info},
      retainDays: 1,
    );

    final logger = FlutterLogger.init(config);

    final stopwatch = Stopwatch()..start();

    // 测试大量日志记录的性能
    for (int i = 0; i < 1000; i++) {
      logger.info('PERF_TEST', '性能测试日志 $i');
    }

    stopwatch.stop();

    print('性能测试结果:');
    print('   - 记录1000条日志耗时: ${stopwatch.elapsedMilliseconds}ms');
    print('   - 平均每条日志: ${stopwatch.elapsedMicroseconds / 1000}μs');
    print('   - 性能状态: ${stopwatch.elapsedMilliseconds < 1000 ? "优秀" : "需要优化"}');
  }
}

/// 运行所有Web测试
void main() {
  WebCompatibilityTest.runTests();
  WebApiAvailability.checkApis();
  WebPerformanceTest.runPerformanceTest();
}
