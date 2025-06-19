import 'package:flutter_logger/flutter_logger.dart';

/// 简单的 Flutter Logger 使用示例
class SimpleExample {
  static void runExample() {
    // 1. 初始化日志器
    final config = LogConfig(
      tag: 'simple_example',
      enableFile: true,
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.info},
      retainDays: 3,
    );

    final logger = FlutterLogger.init(config);

    // 2. 记录不同级别的日志
    logger.info('APP', '应用启动');
    logger.debug('USER', '用户登录: user123');
    logger.warn('NETWORK', '网络连接较慢');
    logger.error('DATABASE', '数据库连接失败');

    // 3. 模拟业务逻辑
    _simulateUserAction(logger);
    _simulateNetworkCall(logger);
    _simulateErrorHandling(logger);
  }

  static void _simulateUserAction(FlutterLogger logger) {
    logger.info('USER_ACTION', '用户点击了按钮');
    logger.debug('USER_ACTION', '按钮ID: submit_button');
  }

  static void _simulateNetworkCall(FlutterLogger logger) {
    logger.info('NETWORK', '开始API请求');
    logger.debug('NETWORK', '请求URL: https://api.example.com/data');

    // 模拟网络延迟
    Future.delayed(const Duration(seconds: 1), () {
      logger.info('NETWORK', 'API请求完成');
      logger.debug('NETWORK', '响应状态码: 200');
    });
  }

  static void _simulateErrorHandling(FlutterLogger logger) {
    try {
      // 模拟一个错误
      throw Exception('模拟的异常');
    } catch (e) {
      logger.error('ERROR_HANDLING', '捕获到异常: $e');
      logger.info('ERROR_HANDLING', '错误已处理');
    }
  }
}

/// 高级使用示例
class AdvancedExample {
  static void runAdvancedExample() {
    // 配置只记录错误和警告到文件
    final config = LogConfig(
      tag: 'advanced_example',
      enableFile: true,
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.warn},
      retainDays: 7,
    );

    final logger = FlutterLogger.init(config);

    // 记录详细的业务日志
    _logBusinessProcess(logger);
    _logPerformanceMetrics(logger);
    _logSecurityEvents(logger);
  }

  static void _logBusinessProcess(FlutterLogger logger) {
    logger.info('BUSINESS', '开始处理订单');
    logger.debug('BUSINESS', '订单ID: ORD-2024-001');
    logger.debug('BUSINESS', '用户ID: USR-12345');
    logger.info('BUSINESS', '订单处理完成');
  }

  static void _logPerformanceMetrics(FlutterLogger logger) {
    logger.debug('PERFORMANCE', '页面加载时间: 1.2秒');
    logger.debug('PERFORMANCE', '内存使用: 45MB');
    logger.warn('PERFORMANCE', '内存使用率较高: 85%');
  }

  static void _logSecurityEvents(FlutterLogger logger) {
    logger.info('SECURITY', '用户认证成功');
    logger.warn('SECURITY', '检测到异常登录尝试');
    logger.error('SECURITY', '权限验证失败');
  }
}
