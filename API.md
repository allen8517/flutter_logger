# Flutter Logger API 文档

## 概述

Flutter Logger 提供了完整的日志记录和管理功能。本文档详细介绍了所有可用的API。

## 核心类

### FlutterLogger

主要的日志器类，提供日志记录和管理功能。

#### 构造函数

```dart
factory FlutterLogger.init(LogConfig config)
```

创建一个新的日志器实例。

**参数：**
- `config` (LogConfig): 日志配置对象

**返回值：**
- `FlutterLogger`: 日志器实例

**示例：**
```dart
final config = LogConfig(
  tag: 'my_app',
  enableFile: true,
  enableConsole: true,
  fileLevels: {LogLevel.error, LogLevel.info},
  retainDays: 7,
);

final logger = FlutterLogger.init(config);
```

#### 静态属性

```dart
static FlutterLogger get instance
```

获取单例实例（需要先调用 `init` 方法）。

#### 日志记录方法

##### info()

```dart
void info(String module, String message)
```

记录信息级别的日志。

**参数：**
- `module` (String): 模块名称
- `message` (String): 日志消息

**示例：**
```dart
logger.info('USER', '用户登录成功');
```

##### debug()

```dart
void debug(String module, String message)
```

记录调试级别的日志。

**参数：**
- `module` (String): 模块名称
- `message` (String): 日志消息

**示例：**
```dart
logger.debug('API', '请求参数: $params');
```

##### warn()

```dart
void warn(String module, String message)
```

记录警告级别的日志。

**参数：**
- `module` (String): 模块名称
- `message` (String): 日志消息

**示例：**
```dart
logger.warn('NETWORK', '网络连接较慢');
```

##### error()

```dart
void error(String module, String message)
```

记录错误级别的日志。

**参数：**
- `module` (String): 模块名称
- `message` (String): 日志消息

**示例：**
```dart
logger.error('DATABASE', '数据库连接失败: $e');
```

##### log()

```dart
void log(String module, String message, LogLevel level)
```

记录指定级别的日志。

**参数：**
- `module` (String): 模块名称
- `message` (String): 日志消息
- `level` (LogLevel): 日志级别

**示例：**
```dart
logger.log('CUSTOM', '自定义消息', LogLevel.info);
```

#### 文件操作方法

##### getLogFiles()

```dart
Future<List<File>> getLogFiles()
```

获取所有日志文件。

**返回值：**
- `Future<List<File>>`: 日志文件列表

**注意：** Web环境返回空列表。

**示例：**
```dart
final files = await logger.getLogFiles();
print('找到 ${files.length} 个日志文件');
```

##### getLogFile()

```dart
Future<File?> getLogFile(DateTime date)
```

获取指定日期的日志文件。

**参数：**
- `date` (DateTime): 日期

**返回值：**
- `Future<File?>`: 日志文件，如果不存在则返回null

**注意：** Web环境返回null。

**示例：**
```dart
final todayFile = await logger.getLogFile(DateTime.now());
if (todayFile != null) {
  print('今日日志文件存在');
}
```

#### 分享方法

##### shareTodayLogs()

```dart
Future<void> shareTodayLogs({String? title})
```

分享今天的日志文件。

**参数：**
- `title` (String?, 可选): 分享标题

**注意：** Web环境显示降级消息。

**示例：**
```dart
await logger.shareTodayLogs(title: '今日应用日志');
```

##### shareAllLogs()

```dart
Future<void> shareAllLogs({String? title})
```

分享所有日志文件。

**参数：**
- `title` (String?, 可选): 分享标题

**注意：** Web环境显示降级消息。

**示例：**
```dart
await logger.shareAllLogs(title: '完整应用日志');
```

##### shareLogFile()

```dart
Future<void> shareLogFile(DateTime date, {String? title})
```

分享指定日期的日志文件。

**参数：**
- `date` (DateTime): 日期
- `title` (String?, 可选): 分享标题

**注意：** Web环境显示降级消息。

**示例：**
```dart
final date = DateTime(2024, 6, 19);
await logger.shareLogFile(date, title: '指定日期日志');
```

#### 上传器

```dart
LogUploader uploader
```

日志上传器实例。

**示例：**
```dart
await logger.uploader.upload();
```

#### 分享器

```dart
LogSharer sharer
```

日志分享器实例。

**示例：**
```dart
final files = await logger.getLogFiles();
await logger.sharer.shareFiles(files, title: '日志文件');
```

### LogConfig

日志配置类，用于配置日志器的行为。

#### 构造函数

```dart
const LogConfig({
  this.tag = 'lava',
  this.enableFile = true,
  this.enableConsole = true,
  this.fileLevels = const {LogLevel.error, LogLevel.debug},
  this.retainDays = 7,
})
```

**参数：**
- `tag` (String): 日志标签，默认值 'lava'
- `enableFile` (bool): 是否启用文件输出，默认值 true
- `enableConsole` (bool): 是否启用控制台输出，默认值 true
- `fileLevels` (Set<LogLevel>): 文件级别集合，默认值 {error, debug}
- `retainDays` (int): 保留天数，默认值 7

**示例：**
```dart
final config = LogConfig(
  tag: 'my_app',
  enableFile: true,
  enableConsole: true,
  fileLevels: {LogLevel.error, LogLevel.info, LogLevel.warn},
  retainDays: 7,
);
```

#### 属性

| 属性 | 类型 | 说明 |
|------|------|------|
| `tag` | String | 日志标签 |
| `enableFile` | bool | 是否启用文件输出 |
| `enableConsole` | bool | 是否启用控制台输出 |
| `fileLevels` | Set<LogLevel> | 文件级别集合 |
| `retainDays` | int | 保留天数 |

### LogLevel

日志级别枚举。

#### 枚举值

```dart
enum LogLevel { info, debug, error, warn }
```

- `LogLevel.info`: 信息级别
- `LogLevel.debug`: 调试级别
- `LogLevel.error`: 错误级别
- `LogLevel.warn`: 警告级别

**示例：**
```dart
logger.log('MODULE', '消息', LogLevel.info);
```

## 配置示例

### 移动端配置

```dart
final mobileConfig = LogConfig(
  tag: 'mobile_app',
  enableFile: true,      // 启用文件输出
  enableConsole: true,   // 启用控制台输出
  fileLevels: {LogLevel.error, LogLevel.info, LogLevel.warn}, // 文件级别
  retainDays: 7,         // 保留7天
);
```

### Web端配置

```dart
final webConfig = LogConfig(
  tag: 'web_app',
  enableFile: false,     // Web中必须关闭
  enableConsole: true,   // 保持控制台输出
  fileLevels: {LogLevel.error, LogLevel.info}, // 文件级别
  retainDays: 1,         // 保留1天
);
```

### 开发环境配置

```dart
final devConfig = LogConfig(
  tag: 'dev_app',
  enableFile: true,
  enableConsole: true,
  fileLevels: {LogLevel.error, LogLevel.debug, LogLevel.info, LogLevel.warn}, // 所有级别
  retainDays: 1,         // 短期保留
);
```

### 生产环境配置

```dart
final prodConfig = LogConfig(
  tag: 'prod_app',
  enableFile: true,
  enableConsole: false,  // 生产环境关闭控制台输出
  fileLevels: {LogLevel.error, LogLevel.warn}, // 只记录错误和警告
  retainDays: 30,        // 长期保留
);
```

## 错误处理

### 常见错误

#### MissingPluginException

在Web环境中使用文件功能时可能出现：

```
MissingPluginException(No implementation found for method getApplicationSupportDirectory on channel plugins.flutter.io/path_provider)
```

**解决方案：**
```dart
// Web环境配置
final config = LogConfig(
  enableFile: false,  // 必须关闭
  enableConsole: true,
);
```

#### 文件操作错误

```dart
try {
  await logger.shareTodayLogs();
} catch (e) {
  logger.error('SHARE', '分享失败: $e');
}
```

## 最佳实践

### 模块命名

```dart
// 好的命名
logger.info('USER_AUTH', '用户认证成功');
logger.info('ORDER_PROCESS', '订单处理完成');
logger.info('PAYMENT_GATEWAY', '支付网关响应');

// 避免的命名
logger.info('A', '用户认证成功');
logger.info('TEST', '订单处理完成');
```

### 错误处理

```dart
try {
  // 业务逻辑
  final result = await apiCall();
  logger.info('API', 'API调用成功');
} catch (e) {
  logger.error('API', 'API调用失败: $e');
  // 错误处理逻辑
}
```

### 性能优化

```dart
// 条件日志记录
void logDebugInfo(String message) {
  if (kDebugMode) {
    logger.debug('DEBUG', message);
  }
}

// 避免频繁日志记录
void processData() {
  logger.info('PROCESS', '开始处理数据');
  // 处理逻辑
  logger.info('PROCESS', '数据处理完成');
}
```

## 平台兼容性

### iOS/Android

- ✅ 文件输出
- ✅ 控制台输出
- ✅ 日志分享
- ✅ 日志上传
- ✅ 文件操作

### Web

- ❌ 文件输出
- ✅ 控制台输出
- ⚠️ 日志分享（降级为下载）
- ⚠️ 日志上传（需要服务器支持）
- ❌ 文件操作

## 版本兼容性

- Flutter SDK: >=1.17.0
- Dart SDK: >=3.4.3
- 支持的平台: iOS, Android, Web 