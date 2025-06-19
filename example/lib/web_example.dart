import 'package:flutter_logger/flutter_logger.dart';

/// Flutter Web 日志使用示例
class WebLoggerExample {
  static void runExample() {
    print('=== Flutter Web 日志示例 ===\n');

    // Web环境下的配置
    final config = LogConfig(
      tag: 'web_app',
      enableFile: false, // Web中关闭文件输出
      enableConsole: true, // 保持控制台输出
      fileLevels: {LogLevel.error, LogLevel.info},
      retainDays: 7,
    );

    final logger = FlutterLogger.init(config);

    // 基本日志记录（Web中完全支持）
    _logBasicInfo(logger);
    _logUserActions(logger);
    _logNetworkRequests(logger);
    _logErrors(logger);

    // Web特有的日志记录
    _logWebSpecificInfo(logger);
  }

  static void _logBasicInfo(FlutterLogger logger) {
    print('--- 基本日志记录 ---');
    logger.info('APP', 'Web应用启动');
    logger.info('USER', '用户访问页面');
    logger.debug('DEBUG', '当前URL: ${Uri.base}');
  }

  static void _logUserActions(FlutterLogger logger) {
    print('--- 用户操作日志 ---');
    logger.info('USER_ACTION', '用户点击按钮');
    logger.debug('USER_ACTION', '按钮ID: submit_button');
    logger.info('USER_ACTION', '表单提交');
  }

  static void _logNetworkRequests(FlutterLogger logger) {
    print('--- 网络请求日志 ---');
    logger.info('API', '开始API请求');
    logger.debug('API', '请求URL: https://api.example.com/data');
    logger.info('API', 'API请求完成');
  }

  static void _logErrors(FlutterLogger logger) {
    print('--- 错误日志 ---');
    try {
      // 模拟错误
      throw Exception('Web环境中的模拟错误');
    } catch (e) {
      logger.error('ERROR', '捕获到错误: $e');
      logger.info('ERROR', '错误已处理');
    }
  }

  static void _logWebSpecificInfo(FlutterLogger logger) {
    print('--- Web特有信息 ---');
    logger.info('WEB', '浏览器信息: ${_getBrowserInfo()}');
    logger.info('WEB', '屏幕分辨率: ${_getScreenInfo()}');
    logger.debug('WEB', '用户代理: ${_getUserAgent()}');
  }

  static String _getBrowserInfo() {
    // 这里可以添加获取浏览器信息的逻辑
    return 'Chrome/120.0.0.0';
  }

  static String _getScreenInfo() {
    // 这里可以添加获取屏幕信息的逻辑
    return '1920x1080';
  }

  static String _getUserAgent() {
    // 这里可以添加获取用户代理的逻辑
    return 'Mozilla/5.0...';
  }
}

/// Web环境下的日志管理
class WebLogManager {
  late FlutterLogger logger;
  final List<String> _logBuffer = [];
  static const int _maxBufferSize = 1000;

  WebLogManager() {
    final config = LogConfig(
      tag: 'web_manager',
      enableFile: false,
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.info, LogLevel.warn},
      retainDays: 1,
    );
    logger = FlutterLogger.init(config);
  }

  /// 记录日志并缓存
  void log(String module, String message, LogLevel level) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] [$level] [$module] $message';

    // 添加到缓冲区
    _logBuffer.add(logEntry);

    // 限制缓冲区大小
    if (_logBuffer.length > _maxBufferSize) {
      _logBuffer.removeAt(0);
    }

    // 记录到控制台
    logger.log(module, message, level);
  }

  /// 获取缓存的日志
  List<String> getLogBuffer() {
    return List.from(_logBuffer);
  }

  /// 清空日志缓存
  void clearLogBuffer() {
    _logBuffer.clear();
    logger.info('BUFFER', '日志缓存已清空');
  }

  /// 导出日志为文本
  String exportLogs() {
    return _logBuffer.join('\n');
  }

  /// 下载日志文件（Web环境下的分享替代方案）
  void downloadLogs() {
    final logs = exportLogs();
    final blob = _createBlob(logs);
    _downloadBlob(
        blob, 'web_logs_${DateTime.now().millisecondsSinceEpoch}.txt');
  }

  /// 创建Blob对象（模拟）
  dynamic _createBlob(String content) {
    // 在实际Web环境中，这里会使用dart:html的Blob
    print('创建Blob对象，内容长度: ${content.length}');
    return content;
  }

  /// 下载Blob（模拟）
  void _downloadBlob(dynamic blob, String filename) {
    // 在实际Web环境中，这里会触发下载
    print('下载文件: $filename');
    print('文件内容预览: ${blob.toString().substring(0, 100)}...');
  }
}

/// Web环境下的错误监控
class WebErrorMonitor {
  late FlutterLogger logger;

  WebErrorMonitor() {
    final config = LogConfig(
      tag: 'web_error_monitor',
      enableFile: false,
      enableConsole: true,
      fileLevels: {LogLevel.error},
      retainDays: 1,
    );
    logger = FlutterLogger.init(config);
  }

  /// 监控JavaScript错误
  void monitorJsErrors() {
    logger.info('MONITOR', '开始监控JavaScript错误');

    // 在实际Web环境中，这里会添加JavaScript错误监听器
    // window.onError.listen((error) {
    //   logger.error('JS_ERROR', 'JavaScript错误: $error');
    // });

    logger.info('MONITOR', 'JavaScript错误监控已启动');
  }

  /// 监控网络错误
  void monitorNetworkErrors() {
    logger.info('MONITOR', '开始监控网络错误');

    // 在实际Web环境中，这里会监控网络请求
    logger.info('MONITOR', '网络错误监控已启动');
  }

  /// 监控性能问题
  void monitorPerformance() {
    logger.info('MONITOR', '开始监控性能问题');

    // 在实际Web环境中，这里会监控页面性能
    logger.info('MONITOR', '性能监控已启动');
  }
}

/// Web环境下的日志使用建议
class WebLoggingBestPractices {
  static void printBestPractices() {
    print('\n=== Web环境日志最佳实践 ===\n');

    print('✅ 推荐做法:');
    print('1. 关闭文件输出 (enableFile: false)');
    print('2. 保持控制台输出 (enableConsole: true)');
    print('3. 使用日志缓冲区管理内存');
    print('4. 定期清理日志缓存');
    print('5. 提供下载功能替代分享');

    print('\n❌ 避免做法:');
    print('1. 不要尝试写入本地文件');
    print('2. 不要依赖原生分享功能');
    print('3. 不要存储过多日志在内存中');
    print('4. 不要记录敏感信息');

    print('\n🔧 替代方案:');
    print('1. 使用日志缓冲区');
    print('2. 提供下载功能');
    print('3. 发送日志到服务器');
    print('4. 使用浏览器开发者工具');
  }
}
