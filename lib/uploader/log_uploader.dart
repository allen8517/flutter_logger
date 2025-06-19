import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';

class LogUploader {
  Future<File> zipFiles(List<File> files, String zipName) async {
    final encoder = ZipFileEncoder();
    final dir = await getTemporaryDirectory();
    final zipPath = '${dir.path}/$zipName.zip';
    encoder.create(zipPath);
    for (var f in files) encoder.addFile(f);
    encoder.close();
    return File(zipPath);
  }

  Future<void> uploadZip(File zipFile, Uri serverUri) async {
    final req = http.MultipartRequest('POST', serverUri);
    req.files.add(await http.MultipartFile.fromPath('log_file', zipFile.path));
    final res = await req.send();
    if (res.statusCode == 200) {
      print('[LogUploader] Upload success');
    } else {
      print('[LogUploader] Upload failed: \${res.statusCode}');
    }
  }
}
