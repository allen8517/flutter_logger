# Flutter Logger 示例

这是一个完整的 Flutter Logger 使用示例，展示了如何使用该日志库的各种功能。

## 功能特性

这个示例应用展示了以下功能：

### 1. 日志级别
- **信息 (Info)**: 记录一般信息
- **调试 (Debug)**: 记录调试信息
- **警告 (Warning)**: 记录警告信息
- **错误 (Error)**: 记录错误信息

### 2. 日志功能
- **文件输出**: 日志会保存到本地文件
- **控制台输出**: 日志会显示在控制台
- **日志分享**: 可以分享日志文件
- **日志上传**: 可以上传日志到服务器

### 3. 配置选项
- **标签 (Tag)**: 设置日志标签
- **文件级别**: 指定哪些级别的日志保存到文件
- **保留天数**: 设置日志文件保留时间

## 运行示例

1. 确保你在 `example` 目录下
2. 运行以下命令：

```bash
flutter pub get
flutter run
```

## 使用说明

### 初始化日志器

```dart
final config = LogConfig(
  tag: 'example_app',
  enableFile: true,
  enableConsole: true,
  fileLevels: {LogLevel.error, LogLevel.debug, LogLevel.info, LogLevel.warn},
  retainDays: 7,
);

logger = FlutterLogger.init(config);
```

### 记录不同级别的日志

```dart
// 信息日志
logger.info('MODULE', '这是一条信息日志');

// 调试日志
logger.debug('MODULE', '这是一条调试日志');

// 警告日志
logger.warn('MODULE', '这是一条警告日志');

// 错误日志
logger.error('MODULE', '这是一条错误日志');
```

### 分享和上传日志

```dart
// 分享日志
await logger.sharer.share();

// 上传日志
await logger.uploader.upload();
```

## 界面说明

示例应用包含以下界面元素：

1. **日志级别按钮**: 测试不同级别的日志记录
2. **功能测试按钮**: 测试网络请求、分享和上传功能
3. **日志消息显示**: 实时显示最近的日志消息

## 配置说明

### LogConfig 参数

- `tag`: 日志标签，用于标识日志来源
- `enableFile`: 是否启用文件输出
- `enableConsole`: 是否启用控制台输出
- `fileLevels`: 指定哪些级别的日志保存到文件
- `retainDays`: 日志文件保留天数

### LogLevel 枚举

- `LogLevel.info`: 信息级别
- `LogLevel.debug`: 调试级别
- `LogLevel.warn`: 警告级别
- `LogLevel.error`: 错误级别

## 注意事项

1. 确保应用有适当的文件读写权限
2. 分享功能需要设备支持分享功能
3. 上传功能需要配置正确的服务器地址
4. 日志文件会自动按日期分割和管理 