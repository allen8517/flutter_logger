# 日志分享功能使用指南

## 概述

Flutter Logger 提供了强大的日志分享功能，可以将日志文件分享到其他应用或服务。

## 基本使用方法

### 1. 分享今天的日志文件

```dart
// 分享今天的日志文件
await logger.shareTodayLogs(title: '今日应用日志');
```

### 2. 分享指定日期的日志文件

```dart
// 分享指定日期的日志文件
final date = DateTime(2024, 6, 19);
await logger.shareLogFile(date, title: '指定日期日志');
```

### 3. 分享所有日志文件

```dart
// 分享所有日志文件
await logger.shareAllLogs(title: '完整应用日志');
```

### 4. 自定义分享

```dart
// 获取所有日志文件
final files = await logger.getLogFiles();

// 分享指定的文件列表
await logger.sharer.shareFiles(files, title: '自定义日志');
```

## 完整示例

```dart
import 'package:flutter_logger/flutter_logger.dart';

class LogShareExample {
  late FlutterLogger logger;
  
  LogShareExample() {
    final config = LogConfig(
      tag: 'my_app',
      enableFile: true,
      enableConsole: true,
      fileLevels: {LogLevel.error, LogLevel.info, LogLevel.warn},
      retainDays: 7,
    );
    logger = FlutterLogger.init(config);
  }
  
  // 分享今天的日志
  Future<void> shareTodayLogs() async {
    try {
      await logger.shareTodayLogs(title: '今日应用日志');
      print('今日日志分享成功');
    } catch (e) {
      logger.error('SHARE', '分享今日日志失败: $e');
    }
  }
  
  // 分享所有日志
  Future<void> shareAllLogs() async {
    try {
      await logger.shareAllLogs(title: '完整应用日志');
      print('所有日志分享成功');
    } catch (e) {
      logger.error('SHARE', '分享所有日志失败: $e');
    }
  }
  
  // 分享指定日期的日志
  Future<void> shareSpecificDate(DateTime date) async {
    try {
      await logger.shareLogFile(date, title: '指定日期日志');
      print('指定日期日志分享成功');
    } catch (e) {
      logger.error('SHARE', '分享指定日期日志失败: $e');
    }
  }
  
  // 获取日志文件信息
  Future<void> getLogFileInfo() async {
    try {
      final files = await logger.getLogFiles();
      print('找到 ${files.length} 个日志文件:');
      
      for (final file in files) {
        final size = await file.length();
        final sizeInKB = (size / 1024).toStringAsFixed(2);
        print('  - ${file.path.split('/').last}: ${sizeInKB} KB');
      }
    } catch (e) {
      logger.error('INFO', '获取日志文件信息失败: $e');
    }
  }
}
```

## 在Flutter应用中使用

### 1. 添加分享按钮

```dart
ElevatedButton.icon(
  onPressed: () async {
    try {
      await logger.shareTodayLogs(title: '应用日志');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('日志分享成功')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('日志分享失败: $e')),
      );
    }
  },
  icon: const Icon(Icons.share),
  label: const Text('分享日志'),
)
```

### 2. 分享菜单

```dart
PopupMenuButton<String>(
  onSelected: (value) async {
    switch (value) {
      case 'today':
        await logger.shareTodayLogs(title: '今日日志');
        break;
      case 'all':
        await logger.shareAllLogs(title: '所有日志');
        break;
      case 'yesterday':
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        await logger.shareLogFile(yesterday, title: '昨日日志');
        break;
    }
  },
  itemBuilder: (context) => [
    const PopupMenuItem(
      value: 'today',
      child: Text('分享今日日志'),
    ),
    const PopupMenuItem(
      value: 'yesterday',
      child: Text('分享昨日日志'),
    ),
    const PopupMenuItem(
      value: 'all',
      child: Text('分享所有日志'),
    ),
  ],
  child: const Icon(Icons.more_vert),
)
```

## 高级用法

### 1. 条件分享

```dart
Future<void> shareLogsIfNeeded() async {
  final files = await logger.getLogFiles();
  
  // 只分享大于1KB的日志文件
  final largeFiles = <File>[];
  for (final file in files) {
    final size = await file.length();
    if (size > 1024) {
      largeFiles.add(file);
    }
  }
  
  if (largeFiles.isNotEmpty) {
    await logger.sharer.shareFiles(largeFiles, title: '大型日志文件');
  }
}
```

### 2. 分享最近N天的日志

```dart
Future<void> shareRecentLogs(int days) async {
  final recentFiles = <File>[];
  
  for (int i = 0; i < days; i++) {
    final date = DateTime.now().subtract(Duration(days: i));
    final file = await logger.getLogFile(date);
    if (file != null) {
      recentFiles.add(file);
    }
  }
  
  if (recentFiles.isNotEmpty) {
    await logger.sharer.shareFiles(recentFiles, title: '最近${days}天日志');
  }
}
```

### 3. 错误处理

```dart
Future<void> safeShareLogs() async {
  try {
    // 检查是否有日志文件
    final files = await logger.getLogFiles();
    if (files.isEmpty) {
      print('没有找到日志文件');
      return;
    }
    
    // 分享日志
    await logger.shareAllLogs(title: '应用日志');
    print('日志分享成功');
    
  } catch (e) {
    // 记录错误
    logger.error('SHARE', '分享日志失败: $e');
    
    // 显示用户友好的错误信息
    print('日志分享失败，请稍后重试');
  }
}
```

## 注意事项

### 1. 权限要求

- 确保应用有文件读写权限
- 在某些平台上可能需要额外的分享权限

### 2. 文件大小

- 大文件可能影响分享性能
- 建议在分享前检查文件大小

### 3. 平台兼容性

- iOS: 支持系统分享菜单
- Android: 支持系统分享功能
- Web: 支持下载功能

### 4. 错误处理

- 始终使用 try-catch 包装分享操作
- 记录分享失败的错误信息
- 提供用户友好的错误提示

## 常见问题

### Q: 分享时没有显示文件？
A: 检查日志文件是否存在，确保 `enableFile` 为 true 且已记录日志。

### Q: 分享失败怎么办？
A: 检查文件权限，确保应用有访问文件的权限。

### Q: 如何分享特定级别的日志？
A: 可以通过配置 `fileLevels` 来控制哪些级别的日志保存到文件。

### Q: 分享的文件格式是什么？
A: 日志文件是纯文本格式，按日期命名：`YYYY-MM-DD.log`。 