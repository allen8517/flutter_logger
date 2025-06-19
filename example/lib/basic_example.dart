/// 基本的日志使用示例
/// 这个文件展示了如何使用 Flutter Logger 的核心功能

// 模拟日志级别枚举
enum LogLevel { info, debug, error, warn }

// 模拟日志配置类
class LogConfig {
  final String tag;
  final bool enableFile;
  final bool enableConsole;
  final Set<LogLevel> fileLevels;
  final int retainDays;

  const LogConfig({
    this.tag = 'app',
    this.enableFile = true,
    this.enableConsole = true,
    this.fileLevels = const {LogLevel.error, LogLevel.debug},
    this.retainDays = 7,
  });
}

// 模拟日志器类
class FlutterLogger {
  final LogConfig _config;

  FlutterLogger._(this._config);

  factory FlutterLogger.init(LogConfig config) {
    return FlutterLogger._(config);
  }

  void info(String module, String message) {
    _log(module, message, LogLevel.info);
  }

  void debug(String module, String message) {
    _log(module, message, LogLevel.debug);
  }

  void warn(String module, String message) {
    _log(module, message, LogLevel.warn);
  }

  void error(String module, String message) {
    _log(module, message, LogLevel.error);
  }

  void _log(String module, String message, LogLevel level) {
    final timestamp = DateTime.now().toString();
    final logMessage = '[$timestamp] [$level] [$module] $message';

    // 控制台输出
    if (_config.enableConsole) {
      print(logMessage);
    }

    // 文件输出（模拟）
    if (_config.enableFile && _config.fileLevels.contains(level)) {
      // 这里应该写入文件，这里只是模拟
      print('📁 文件日志: $logMessage');
    }
  }
}

/// 使用示例
class BasicExample {
  static void runExample() {
    print('=== Flutter Logger 基本使用示例 ===\n');

    // 1. 创建日志配置
    final config = LogConfig(
      tag: 'basic_example',
      enableFile: true,
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.info},
      retainDays: 3,
    );

    // 2. 初始化日志器
    final logger = FlutterLogger.init(config);

    // 3. 记录不同级别的日志
    print('--- 记录不同级别的日志 ---');
    logger.info('APP', '应用启动成功');
    logger.debug('USER', '用户登录: user123');
    logger.warn('NETWORK', '网络连接较慢');
    logger.error('DATABASE', '数据库连接失败');

    print('\n--- 模拟业务场景 ---');
    _simulateUserLogin(logger);
    _simulateNetworkRequest(logger);
    _simulateErrorHandling(logger);

    print('\n=== 示例完成 ===');
  }

  static void _simulateUserLogin(FlutterLogger logger) {
    logger.info('AUTH', '开始用户认证');
    logger.debug('AUTH', '用户名: admin');
    logger.info('AUTH', '用户认证成功');
  }

  static void _simulateNetworkRequest(FlutterLogger logger) {
    logger.info('API', '开始API请求');
    logger.debug('API', '请求URL: https://api.example.com/data');
    logger.info('API', 'API请求完成');
  }

  static void _simulateErrorHandling(FlutterLogger logger) {
    try {
      throw Exception('模拟的异常');
    } catch (e) {
      logger.error('ERROR', '捕获到异常: $e');
      logger.info('ERROR', '错误已处理');
    }
  }
}

/// 高级配置示例
class AdvancedConfigExample {
  static void runAdvancedExample() {
    print('\n=== 高级配置示例 ===\n');

    // 只记录错误和警告到文件
    final errorConfig = LogConfig(
      tag: 'error_only',
      enableFile: true,
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.warn},
      retainDays: 7,
    );

    final errorLogger = FlutterLogger.init(errorConfig);

    print('--- 错误专用日志器 ---');
    errorLogger.info('INFO', '这条信息不会保存到文件');
    errorLogger.warn('WARN', '这条警告会保存到文件');
    errorLogger.error('ERROR', '这条错误会保存到文件');

    // 只记录调试信息到文件
    final debugConfig = LogConfig(
      tag: 'debug_only',
      enableFile: true,
      enableConsole: false, // 不显示在控制台
      fileLevels: {LogLevel.debug},
      retainDays: 1,
    );

    final debugLogger = FlutterLogger.init(debugConfig);

    print('\n--- 调试专用日志器 ---');
    debugLogger.info('INFO', '这条信息不会显示也不会保存');
    debugLogger.debug('DEBUG', '这条调试信息会保存到文件');
    debugLogger.warn('WARN', '这条警告不会保存到文件');
  }
}

/// 业务场景示例
class BusinessExample {
  static void runBusinessExample() {
    print('\n=== 业务场景示例 ===\n');

    final config = LogConfig(
      tag: 'business_app',
      enableFile: true,
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.info, LogLevel.warn},
      retainDays: 30,
    );

    final logger = FlutterLogger.init(config);

    // 模拟电商应用场景
    _simulateOrderProcess(logger);
    _simulatePaymentProcess(logger);
    _simulateInventoryCheck(logger);
  }

  static void _simulateOrderProcess(FlutterLogger logger) {
    logger.info('ORDER', '开始处理订单 ORD-2024-001');
    logger.debug('ORDER', '订单详情: 商品A x2, 商品B x1');
    logger.info('ORDER', '订单验证通过');
    logger.warn('ORDER', '库存不足，需要补货');
    logger.info('ORDER', '订单处理完成');
  }

  static void _simulatePaymentProcess(FlutterLogger logger) {
    logger.info('PAYMENT', '开始支付处理');
    logger.debug('PAYMENT', '支付金额: ¥299.00');
    logger.info('PAYMENT', '支付成功');
  }

  static void _simulateInventoryCheck(FlutterLogger logger) {
    logger.info('INVENTORY', '开始库存检查');
    logger.debug('INVENTORY', '商品A库存: 5件');
    logger.debug('INVENTORY', '商品B库存: 0件');
    logger.error('INVENTORY', '商品B库存不足，需要紧急补货');
  }
}
