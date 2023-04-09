import 'dart:typed_data';

import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailService {
  ThumbnailService(
      {required double aspectRatio,
      required double shortestSide,
      required String videoFilePath,
      required int videoDurationMs})
      : _aspectRatio = aspectRatio,
        _shortestSide = shortestSide,
        _videoFilePath = videoFilePath,
        _videoDurationMs = videoDurationMs;

  final double _aspectRatio;
  final double _shortestSide;
  final String _videoFilePath;
  final int _videoDurationMs;

  double get thumbnailHeight => _shortestSide / 7;
  double get thumbnailWidth => thumbnailHeight * _aspectRatio;
  int get numberOfThumbnails => _shortestSide ~/ thumbnailWidth;
  double get timelineWidth =>
      numberOfThumbnails * thumbnailHeight * _aspectRatio;
  double get eachPart => _videoDurationMs / numberOfThumbnails;
  double get aspectRatio => _aspectRatio;

  double get shortestSide => _shortestSide;

  final List<Uint8List?> byteList = <Uint8List?>[];

  Stream<List<Uint8List?>> generateThumbnails() async* {
    for (int i = 1; i <= numberOfThumbnails; i++) {
      Uint8List? bytes;
      bytes = await VideoThumbnail.thumbnailData(
        video: _videoFilePath,
        imageFormat: ImageFormat.JPEG,
        timeMs: (eachPart * i).toInt(),
        quality: 75,
      );
      if (bytes != null) {
        byteList.add(bytes);
      }
      yield byteList;
    }
  }
}
