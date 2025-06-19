import 'dart:io';
import 'package:share_plus/share_plus.dart';

class LogSharer {
  Future<void> shareFiles(List<File> files, {String? title}) async {
    final xfiles = files.map((f) => XFile(f.path)).toList();
    await Share.shareXFiles(xfiles, text: title ?? '日志文件');
  }
}
