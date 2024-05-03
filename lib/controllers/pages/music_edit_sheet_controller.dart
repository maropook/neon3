import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/services/file_service.dart';
import 'package:neon3/services/fire_avatar_service.dart';

part 'music_edit_sheet_controller.freezed.dart';

@freezed
class MusicEditSheetState with _$MusicEditSheetState {
  const factory MusicEditSheetState({
    @Default('') String musicFilePath,
  }) = _MusicEditSheetState;
}

final musicEditSheetProvider = StateNotifierProvider.autoDispose<
    MusicEditSheetController,
    MusicEditSheetState>((ref) => MusicEditSheetController());

class MusicEditSheetController extends StateNotifier<MusicEditSheetState> {
  MusicEditSheetController() : super(const MusicEditSheetState()) {
    init();
  }
  final FireAvatarService fireAvatarService = FireAvatarService();
  final FileService fileService = FileService();

  Future<void> init() async {}
  Future<String> getPickedFilePath() async {
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile == null) {
      return '';
    }
    final String pickedFilePath = pickedFile.files.single.path!;
    final String outputFilePath = (await fileService.saveFile(
            inputFilePath: pickedFilePath, outputFilePath: 'musicFile.mp3'))
        .path;

    return outputFilePath;
  }
}
