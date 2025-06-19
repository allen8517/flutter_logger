# Flutter Logger 使用指南

## 概述

Flutter Logger 是一个模块化的日志库，支持文件输出、压缩、上传和分享功能。本指南将详细介绍如何使用这个库。

## 快速开始

### 1. 添加依赖

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  flutter_logger:
    path: ../  # 本地开发时使用
```

### 2. 基本使用

```dart
import 'package:flutter_logger/flutter_logger.dart';

void main() {
  // 初始化日志器
  final config = LogConfig(
    tag: 'my_app',
    enableFile: true,
    enableConsole: true,
    fileLevels: {LogLevel.error, LogLevel.info},
    retainDays: 7,
  );
  
  final logger = FlutterLogger.init(config);
  
  // 记录日志
  logger.info('APP', '应用启动');
  logger.error('ERROR', '发生错误');
}
```

## 配置选项

### LogConfig 参数说明

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `tag` | String | 'lava' | 日志标签，用于标识日志来源 |
| `enableFile` | bool | true | 是否启用文件输出 |
| `enableConsole` | bool | true | 是否启用控制台输出 |
| `fileLevels` | Set<LogLevel> | {error, debug} | 指定哪些级别的日志保存到文件 |
| `retainDays` | int | 7 | 日志文件保留天数 |

### LogLevel 枚举

- `LogLevel.info`: 信息级别，记录一般信息
- `LogLevel.debug`: 调试级别，记录调试信息
- `LogLevel.warn`: 警告级别，记录警告信息
- `LogLevel.error`: 错误级别，记录错误信息

## 使用场景

### 1. 基本日志记录

```dart
class MyApp {
  late FlutterLogger logger;
  
  void initLogger() {
    final config = LogConfig(
      tag: 'my_app',
      enableFile: true,
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.info, LogLevel.warn},
      retainDays: 7,
    );
    
    logger = FlutterLogger.init(config);
  }
  
  void logUserAction() {
    logger.info('USER', '用户点击了登录按钮');
    logger.debug('USER', '用户ID: 12345');
  }
  
  void logNetworkRequest() {
    logger.info('NETWORK', '开始API请求');
    logger.debug('NETWORK', '请求URL: https://api.example.com/data');
    logger.info('NETWORK', 'API请求完成');
  }
  
  void logError(Exception error) {
    logger.error('ERROR', '捕获到异常: $error');
  }
}
```

### 2. 不同配置的日志器

```dart
// 只记录错误到文件
final errorLogger = FlutterLogger.init(LogConfig(
  tag: 'error_only',
  fileLevels: {LogLevel.error},
  retainDays: 30,
));

// 只记录调试信息到文件
final debugLogger = FlutterLogger.init(LogConfig(
  tag: 'debug_only',
  fileLevels: {LogLevel.debug},
  enableConsole: false,
  retainDays: 1,
));

// 记录所有级别到文件
final fullLogger = FlutterLogger.init(LogConfig(
  tag: 'full_log',
  fileLevels: {LogLevel.info, LogLevel.debug, LogLevel.warn, LogLevel.error},
  retainDays: 7,
));
```

### 3. 业务场景示例

#### 电商应用

```dart
class ECommerceLogger {
  late FlutterLogger logger;
  
  ECommerceLogger() {
    final config = LogConfig(
      tag: 'ecommerce',
      fileLevels: {LogLevel.error, LogLevel.info, LogLevel.warn},
      retainDays: 30,
    );
    logger = FlutterLogger.init(config);
  }
  
  void logOrderProcess(String orderId) {
    logger.info('ORDER', '开始处理订单: $orderId');
    logger.debug('ORDER', '订单详情: 商品A x2, 商品B x1');
    logger.info('ORDER', '订单验证通过');
    logger.warn('ORDER', '库存不足，需要补货');
    logger.info('ORDER', '订单处理完成');
  }
  
  void logPaymentProcess(String orderId, double amount) {
    logger.info('PAYMENT', '开始支付处理: $orderId');
    logger.debug('PAYMENT', '支付金额: ¥$amount');
    logger.info('PAYMENT', '支付成功');
  }
  
  void logInventoryCheck() {
    logger.info('INVENTORY', '开始库存检查');
    logger.debug('INVENTORY', '商品A库存: 5件');
    logger.debug('INVENTORY', '商品B库存: 0件');
    logger.error('INVENTORY', '商品B库存不足，需要紧急补货');
  }
}
```

#### 社交应用

```dart
class SocialAppLogger {
  late FlutterLogger logger;
  
  SocialAppLogger() {
    final config = LogConfig(
      tag: 'social_app',
      fileLevels: {LogLevel.error, LogLevel.info, LogLevel.warn},
      retainDays: 14,
    );
    logger = FlutterLogger.init(config);
  }
  
  void logUserLogin(String userId) {
    logger.info('AUTH', '用户登录: $userId');
    logger.debug('AUTH', '登录时间: ${DateTime.now()}');
  }
  
  void logPostCreation(String userId, String postId) {
    logger.info('POST', '用户 $userId 创建了帖子: $postId');
    logger.debug('POST', '帖子内容长度: 150字符');
  }
  
  void logMessageSend(String fromUserId, String toUserId) {
    logger.info('MESSAGE', '用户 $fromUserId 向 $toUserId 发送消息');
    logger.debug('MESSAGE', '消息发送时间: ${DateTime.now()}');
  }
}
```

## 高级功能

### 1. 日志分享

```dart
// 分享日志文件
try {
  await logger.sharer.share();
  print('日志分享成功');
} catch (e) {
  logger.error('SHARE', '分享日志失败: $e');
}
```

### 2. 日志上传

```dart
// 上传日志到服务器
try {
  await logger.uploader.upload();
  print('日志上传成功');
} catch (e) {
  logger.error('UPLOAD', '上传日志失败: $e');
}
```

## 最佳实践

### 1. 日志级别使用

- **Info**: 记录重要的业务事件
- **Debug**: 记录详细的调试信息
- **Warn**: 记录可能的问题或异常情况
- **Error**: 记录错误和异常

### 2. 模块命名

使用有意义的模块名称：

```dart
// 好的命名
logger.info('USER_AUTH', '用户登录成功');
logger.info('ORDER_PROCESS', '订单创建成功');
logger.info('PAYMENT_GATEWAY', '支付处理完成');

// 避免的命名
logger.info('A', '用户登录成功');
logger.info('TEST', '订单创建成功');
```

### 3. 消息内容

- 使用清晰、描述性的消息
- 包含必要的上下文信息
- 避免敏感信息的记录

```dart
// 好的消息
logger.info('USER', '用户登录成功: user123');
logger.error('DATABASE', '数据库连接失败: 连接超时');

// 避免的消息
logger.info('USER', 'ok');
logger.error('DB', 'error');
```

### 4. 性能考虑

- 避免在频繁调用的代码中使用调试日志
- 合理配置文件级别，避免过多文件写入
- 定期清理旧的日志文件

### 5. 错误处理

```dart
void processData() {
  try {
    // 业务逻辑
    logger.info('PROCESS', '数据处理开始');
    
    // 可能出错的代码
    final result = riskyOperation();
    
    logger.info('PROCESS', '数据处理完成');
  } catch (e) {
    logger.error('PROCESS', '数据处理失败: $e');
    // 错误处理逻辑
  }
}
```

## 调试技巧

### 1. 临时启用调试日志

```dart
// 开发环境
final config = LogConfig(
  tag: 'dev_app',
  fileLevels: {LogLevel.error, LogLevel.debug, LogLevel.info, LogLevel.warn},
  retainDays: 1,
);

// 生产环境
final config = LogConfig(
  tag: 'prod_app',
  fileLevels: {LogLevel.error, LogLevel.warn},
  retainDays: 7,
);
```

### 2. 条件日志记录

```dart
void logDebugInfo(String message) {
  if (kDebugMode) {
    logger.debug('DEBUG', message);
  }
}
```

## 常见问题

### 1. 日志文件位置

日志文件通常保存在应用的文档目录下，具体路径取决于平台：
- iOS: `/Documents/logs/`
- Android: `/data/data/package_name/files/logs/`

### 2. 日志文件格式

日志文件按日期命名，格式为：`YYYY-MM-DD.log`

### 3. 日志文件大小

单个日志文件的大小限制取决于设备存储空间，建议定期清理旧文件。

### 4. 权限问题

确保应用有适当的文件读写权限，特别是在 Android 平台上。

## 总结

Flutter Logger 提供了强大而灵活的日志功能，通过合理配置和使用，可以帮助开发者更好地监控和调试应用。记住要根据实际需求选择合适的配置，并遵循最佳实践来获得最佳的日志记录效果。 