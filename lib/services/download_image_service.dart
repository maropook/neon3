import 'package:image_downloader/image_downloader.dart';
import 'package:maropook_neon2/services/logger.dart';

class DownloadImageService {
  DownloadImageService();
  Future<String> downloadImage({required String downloadUrl}) async {
    try {
      var imageId = await ImageDownloader.downloadImage(downloadUrl) ?? '';
      return await ImageDownloader.findPath(imageId) ?? '';
    } catch (e) {
      Logger.logError('download_image', e.toString());
    }
    return '';
  }
}
