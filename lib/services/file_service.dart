import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  FileService();

  Future<String> getTempFilePath(String fileName) async {
    final Directory documentsDirectory = await getTemporaryDirectory();
    return '${documentsDirectory.path}/$fileName';
  }

  Future<File> saveFile({
    required String inputFilePath,
    required String outputFilePath,
  }) async {
    final ByteData assetByteData = await rootBundle.load(inputFilePath);

    final List<int> byteList = assetByteData.buffer
        .asUint8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes);

    final String fullOutputFilePath =
        join((await getApplicationDocumentsDirectory()).path, outputFilePath);
    final File fileFuture = await File(fullOutputFilePath)
        .writeAsBytes(byteList, mode: FileMode.writeOnly, flush: false);

    return fileFuture;
  }
}
