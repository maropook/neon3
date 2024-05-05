import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

part 'import_sheet_controller.freezed.dart';

enum RecordingType { camera, video, image }

class ImportSheetArg {
  ImportSheetArg({required this.recordingType, this.importedFilePath = ''});
  RecordingType recordingType;
  String importedFilePath;
}

@freezed
class ImportSheetState with _$ImportSheetState {
  const factory ImportSheetState({
    @Default('') String videoFilePath,
    @Default('') String imageFilePath,
    @Default(RecordingType.camera) RecordingType recordingType,
  }) = _ImportSheetState;
}

final importSheetProvider =
    StateNotifierProvider.autoDispose<ImportSheetController, ImportSheetState>(
        (ref) {
  return throw UnimplementedError();
});

class ImportSheetController extends StateNotifier<ImportSheetState> {
  ImportSheetController({required ImportSheetArg importSheetProviderArg})
      : _importSheetProviderArg = importSheetProviderArg,
        super(const ImportSheetState()) {
    init();
  }

  final ImportSheetArg _importSheetProviderArg;

  final ImagePicker picker = ImagePicker();

  Future<void> init() async {}

  Future<String> getPickedImageFilePath() async {
    final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImageFile == null) return '';
    final String pickedImageFilePath = pickedImageFile.path;

    final croppedImageFile = await ImageCropper().cropImage(
      sourcePath: pickedImageFilePath, //pickedImageFile.path
      compressQuality: 80,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (croppedImageFile == null) {
      return '';
    }
    return croppedImageFile.path;
  }

  Future<String> getPickedVideoFilePath() async {
    final pickedImageFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedImageFile == null) return '';
    final String pickedImageFilePath = pickedImageFile.path;

    final videoInfo = FlutterVideoInfo();
    var info = await videoInfo.getVideoInfo(pickedImageFilePath);
    if (info!.duration! >= 2 * 1000) {
      print('動画の時間が60秒以上だったため、トリミングされました');
    }
    return pickedImageFilePath;
  }
}
