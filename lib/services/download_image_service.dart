import 'package:neon3/services/logger.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';

class DownloadImageService {
  DownloadImageService();
  Future<String> downloadImage({required String downloadUrl}) async {
    try {
      var file = await urlToFile(downloadUrl);
      return file.path;
    } catch (e) {
      Logger.logError('download_image', e.toString());
    }
    return '';
  }

  Future<File> urlToFile(String imageUrl) async {
    final String tempPath = (await getTemporaryDirectory()).path;
    final File file = File('$tempPath${Random().nextInt(100)}.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }
}
