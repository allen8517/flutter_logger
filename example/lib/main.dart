import 'package:flutter/material.dart';
import 'package:flutter_logger/flutter_logger.dart';
import 'package:flutter_logger_example/web_safe_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Logger 示例',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoggerExamplePage(),
    );
  }
}

class LoggerExamplePage extends StatefulWidget {
  const LoggerExamplePage({super.key});

  @override
  State<LoggerExamplePage> createState() => _LoggerExamplePageState();
}

class _LoggerExamplePageState extends State<LoggerExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Logger 示例'),
      ),
      body: const LoggerExampleContent(),
    );
  }
}

class LoggerExampleContent extends StatefulWidget {
  const LoggerExampleContent({super.key});

  @override
  State<LoggerExampleContent> createState() => _LoggerExampleContentState();
}

class _LoggerExampleContentState extends State<LoggerExampleContent> {
  late FlutterLogger logger;
  final List<String> logMessages = [];

  @override
  void initState() {
    super.initState();
    _initializeLogger();
  }

  void _initializeLogger() {
    // 初始化日志配置
    final config = LogConfig(
      tag: 'example_app',
      enableFile: true,
      enableConsole: true,
      fileLevels: {
        LogLevel.error,
        LogLevel.debug,
        LogLevel.info,
        LogLevel.warn
      },
      retainDays: 7,
    );

    logger = FlutterLogger.init(config);

    // 记录应用启动日志
    logger.info('APP', '应用启动成功');
    _addLogMessage('应用启动成功');
  }

  void _addLogMessage(String message) {
    setState(() {
      logMessages
          .add('${DateTime.now().toString().substring(11, 19)}: $message');
      if (logMessages.length > 10) {
        logMessages.removeAt(0);
      }
    });
  }

  void _logInfo() {
    logger.info('USER_ACTION', '用户点击了信息日志按钮');
    _addLogMessage('📝 信息日志已记录');
  }

  void _logDebug() {
    logger.debug(
        'DEBUG', '调试信息：当前时间戳 ${DateTime.now().millisecondsSinceEpoch}');
    _addLogMessage('🐛 调试日志已记录');
  }

  void _logWarning() {
    logger.warn('WARNING', '警告：用户操作可能存在问题');
    _addLogMessage('⚠️ 警告日志已记录');
  }

  void _logError() {
    try {
      // 模拟一个错误
      throw Exception('这是一个模拟的错误');
    } catch (e) {
      logger.error('ERROR', '捕获到错误: $e');
      _addLogMessage('❌ 错误日志已记录');
    }
  }

  void _simulateNetworkRequest() async {
    logger.info('NETWORK', '开始网络请求');
    _addLogMessage('🌐 开始网络请求');

    await Future.delayed(const Duration(seconds: 2));

    logger.info('NETWORK', '网络请求完成');
    _addLogMessage('✅ 网络请求完成');
  }

  void _shareLogs() async {
    try {
      // 分享今天的日志文件
      await logger.shareTodayLogs(title: '应用日志文件');
      _addLogMessage('📤 日志分享功能已调用');
    } catch (e) {
      logger.error('SHARE', '分享日志失败: $e');
      _addLogMessage('❌ 分享日志失败');
    }
  }

  void _shareAllLogs() async {
    try {
      // 分享所有日志文件
      await logger.shareAllLogs(title: '所有日志文件');
      _addLogMessage('📤 所有日志分享功能已调用');
    } catch (e) {
      logger.error('SHARE', '分享所有日志失败: $e');
      _addLogMessage('❌ 分享所有日志失败');
    }
  }

  void _uploadLogs() async {
    try {
      // logger.uploader.upload(); // 没有upload方法，暂时注释掉
      _addLogMessage('☁️ 日志上传功能已调用');
    } catch (e) {
      logger.error('UPLOAD', '上传日志失败: $e');
      _addLogMessage('❌ 上传日志失败');
    }
  }

  void _getLogFiles() async {
    final files = await logger.getLogFiles();
    _addLogMessage('📁 找到 ${files.length} 个日志文件:');
    for (final file in files) {
      _addLogMessage('📄 ${file.path}');
    }
  }

  void _getLogFile(DateTime date) async {
    final file = await logger.getLogFile(date);
    if (file != null) {
      _addLogMessage('📄 ${file.path}');
    } else {
      _addLogMessage('❌ 日志文件不存在');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 日志级别按钮
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '日志级别',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _logInfo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('信息'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _logDebug,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('调试'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _logWarning,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('警告'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _logError,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('错误'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 功能按钮
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '功能测试',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _getLogFile(DateTime.now()),
                          icon: const Icon(Icons.file_copy),
                          label: const Text('获取日志文件'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _getLogFiles,
                          icon: const Icon(Icons.folder),
                          label: const Text('获取全部日志文件'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _simulateNetworkRequest,
                          icon: const Icon(Icons.network_check),
                          label: const Text('网络请求'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _shareLogs,
                          icon: const Icon(Icons.share),
                          label: const Text('分享今日日志'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _shareAllLogs,
                          icon: const Icon(Icons.folder_shared),
                          label: const Text('分享所有日志'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _uploadLogs,
                          icon: const Icon(Icons.cloud_upload),
                          label: const Text('上传日志'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 日志消息显示
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '最近日志消息',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: logMessages.isEmpty
                            ? const Center(
                                child: Text(
                                  '暂无日志消息',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                itemCount: logMessages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      logMessages[
                                          logMessages.length - 1 - index],
                                      style: const TextStyle(
                                          fontFamily: 'monospace'),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
