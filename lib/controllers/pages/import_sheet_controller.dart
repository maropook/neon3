import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neon3/services/file_service.dart';
import 'package:neon3/services/fire_avatar_service.dart';

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

  final FireAvatarService fireAvatarService = FireAvatarService();
  final FileService fileService = FileService();

  Future<void> init() async {}
  // Future<String> getPickedFilePath() async {
  //   final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
  //   if (pickedFile == null) {
  //     return '';
  //   }
  //   final String pickedFilePath = pickedFile.files.single.path!;
  //   final String outputFilePath = (await fileService.saveFile(
  //           inputFilePath: pickedFilePath, outputFilePath: 'musicFile.mp3'))
  //       .path;

  //   return outputFilePath;
  // }

  final ImagePicker picker = ImagePicker();

  Future<String> getPickedFilePath() async {
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
}
