# Flutter Web 环境使用指南

## 问题解决

### MissingPluginException 错误

如果您遇到以下错误：
```
MissingPluginException(No implementation found for method getApplicationSupportDirectory on channel plugins.flutter.io/path_provider)
```

这是因为 `path_provider` 插件在 Web 环境中不支持本地文件系统访问。

## 解决方案

### 1. Web环境配置

在 Web 环境中，必须使用以下配置：

```dart
final config = LogConfig(
  tag: 'web_app',
  enableFile: false,  // 重要：Web中必须关闭
  enableConsole: true, // 保持控制台输出
  fileLevels: {LogLevel.error, LogLevel.info},
  retainDays: 1,
);
```

### 2. 基本使用

```dart
import 'package:flutter_logger/flutter_logger.dart';

void main() {
  // Web环境配置
  final config = LogConfig(
    tag: 'web_app',
    enableFile: false,  // 关闭文件输出
    enableConsole: true, // 保持控制台输出
    fileLevels: {LogLevel.error, LogLevel.info},
    retainDays: 1,
  );
  
  final logger = FlutterLogger.init(config);
  
  // 记录日志（只输出到控制台）
  logger.info('APP', 'Web应用启动');
  logger.error('ERROR', '发生错误');
}
```

### 3. Web环境下的功能限制

#### ✅ 完全支持的功能

- 基本日志记录（info, debug, warn, error）
- 控制台输出
- 日志配置

#### ⚠️ 部分支持的功能

- 文件操作：返回空列表或null
- 分享功能：显示降级消息
- 上传功能：需要服务器支持

#### ❌ 不支持的功能

- 本地文件写入
- 原生文件系统访问
- 原生分享菜单

### 4. Web环境替代方案

#### 内存日志管理

```dart
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
  
  String exportLogs() {
    return _logs.join('\n');
  }
}
```

#### 下载功能

```dart
// 在Web环境中提供下载功能替代分享
void downloadLogs() {
  final logs = memoryLogger.exportLogs();
  // 使用 dart:html 创建下载
  // 这里需要在实际Web环境中实现
}
```

#### 服务器上传

```dart
// 发送日志到服务器
Future<void> uploadLogsToServer() async {
  final logs = memoryLogger.exportLogs();
  // 发送到服务器
  // await http.post('/api/logs', body: logs);
}
```

### 5. 完整的Web示例

```dart
import 'package:flutter_logger/flutter_logger.dart';

class WebLoggerManager {
  late FlutterLogger logger;
  final WebMemoryLogger memoryLogger = WebMemoryLogger();
  
  WebLoggerManager() {
    final config = LogConfig(
      tag: 'web_app',
      enableFile: false,  // Web中关闭文件输出
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.info},
      retainDays: 1,
    );
    logger = FlutterLogger.init(config);
  }
  
  void log(String module, String message, LogLevel level) {
    // 记录到控制台
    logger.log(module, message, level);
    
    // 同时记录到内存
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] [$level] [$module] $message';
    memoryLogger.addLog(logEntry);
  }
  
  void info(String module, String message) {
    log(module, message, LogLevel.info);
  }
  
  void error(String module, String message) {
    log(module, message, LogLevel.error);
  }
  
  List<String> getLogs() {
    return memoryLogger.getLogs();
  }
  
  void clearLogs() {
    memoryLogger.clearLogs();
  }
  
  String exportLogs() {
    return memoryLogger.exportLogs();
  }
}
```

### 6. 运行Web安全测试

```bash
cd example
dart run lib/web_safe_test.dart
```

### 7. 最佳实践

#### ✅ 推荐做法

1. **关闭文件输出**：`enableFile: false`
2. **使用内存缓冲区**：管理日志内存
3. **提供下载功能**：替代分享功能
4. **定期清理内存**：避免内存泄漏
5. **错误处理**：优雅处理Web限制

#### ❌ 避免做法

1. **不要启用文件输出**：`enableFile: true`
2. **不要依赖文件操作**：`getLogFiles()`, `getLogFile()`
3. **不要依赖原生分享**：`shareTodayLogs()`
4. **不要存储过多日志**：限制内存使用

### 8. 调试技巧

#### 检查环境

```dart
import 'package:flutter/foundation.dart';

if (kIsWeb) {
  print('当前运行在Web环境');
  // 使用Web配置
} else {
  print('当前运行在移动环境');
  // 使用移动配置
}
```

#### 错误处理

```dart
try {
  await logger.shareTodayLogs();
} catch (e) {
  if (kIsWeb) {
    print('Web环境不支持分享，请使用下载功能');
  } else {
    print('分享失败: $e');
  }
}
```

### 9. 性能考虑

#### 内存管理

- 限制日志缓冲区大小（建议1000条）
- 定期清理旧日志
- 监控内存使用情况

#### 控制台输出

- 避免在频繁调用的代码中使用调试日志
- 使用条件日志记录

```dart
void logDebugInfo(String message) {
  if (kDebugMode) {
    logger.debug('DEBUG', message);
  }
}
```

### 10. 总结

在 Flutter Web 环境中使用 Flutter Logger：

1. **必须关闭文件输出**：`enableFile: false`
2. **使用内存缓冲区**：替代文件存储
3. **提供下载功能**：替代分享功能
4. **优雅降级**：处理不支持的功能
5. **性能优化**：管理内存使用

这样可以在 Web 环境中获得良好的日志记录体验，同时避免 `MissingPluginException` 错误。 