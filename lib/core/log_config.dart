import 'log_level.dart';

class LogConfig {
  final String tag;
  final bool enableFile;
  final bool enableConsole;
  final Set<LogLevel> fileLevels;
  final int retainDays;

  const LogConfig({
    this.tag = 'lava',
    this.enableFile = true,
    this.enableConsole = true,
    this.fileLevels = const {LogLevel.error, LogLevel.debug},
    this.retainDays = 7,
  });
}
