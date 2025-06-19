# Flutter Logger

一个功能强大的 Flutter 日志库，支持文件输出、压缩、上传和分享功能。

## ✨ 功能特性

- **多级别日志记录** - info、debug、warn、error
- **文件输出** - 自动保存日志到本地文件
- **控制台输出** - 实时显示日志信息
- **日志分享** - 支持分享日志文件
- **日志上传** - 支持上传到服务器
- **跨平台支持** - iOS、Android、Web
- **自动清理** - 自动删除过期日志文件

## 📦 安装

```yaml
dependencies:
  flutter_logger:
    path: ../flutter_logger
```

## 🚀 快速开始

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
  logger.info('APP', '应用启动成功');
  logger.error('ERROR', '发生错误');
}
```

## 📖 详细使用

### 日志级别

```dart
logger.info('MODULE', '信息日志');
logger.debug('MODULE', '调试日志');
logger.warn('MODULE', '警告日志');
logger.error('MODULE', '错误日志');
```

### 日志分享

```dart
// 分享今天的日志
await logger.shareTodayLogs(title: '今日日志');

// 分享所有日志
await logger.shareAllLogs(title: '完整日志');
```

### Web环境配置

```dart
// Web环境必须关闭文件输出
final config = LogConfig(
  tag: 'web_app',
  enableFile: false,  // 重要：Web中必须关闭
  enableConsole: true,
  fileLevels: {LogLevel.error, LogLevel.info},
  retainDays: 1,
);
```

## 📁 项目结构

```
flutter_logger/
├── lib/
│   ├── flutter_logger.dart      # 主库文件
│   ├── core/                    # 核心功能
│   ├── writer/                  # 日志写入
│   ├── uploader/                # 日志上传
│   └── sharer/                  # 日志分享
└── example/                     # 示例项目
```

## 🎯 使用场景

- 应用开发和调试
- 生产环境错误监控
- 用户行为分析
- 性能监控和优化

## 📋 示例项目

查看 `example/` 目录获取完整示例：

```bash
cd example
flutter pub get
flutter run
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## �� 许可证

MIT License
