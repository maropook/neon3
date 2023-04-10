import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/services/file_service.dart';
import 'package:neon3/services/fire_avatar_service.dart';
import 'package:neon_video_encoder/subtitle_text.dart';
import 'package:uuid/uuid.dart';

part 'artificial_voice_edit_sheet_controller.freezed.dart';

enum AudioType { original, artificial }

@freezed
class ArtificialVoiceEditSheetState with _$ArtificialVoiceEditSheetState {
  const factory ArtificialVoiceEditSheetState({
    @Default(AudioType.original) AudioType audioType,
    @Default([]) List<SubtitleText> subtitleTexts,
    @Default(false) bool isMergeTtsAudio,
    @Default('') String ttsAudioFilePath,
  }) = _ArtificialVoiceEditSheetState;
}

class ArtificialVoiceEditSheetProviderArg {
  ArtificialVoiceEditSheetProviderArg({
    required this.subtitleTexts,
  });

  final List<SubtitleText> subtitleTexts;
}

final artificialVoiceEditSheetProvider = StateNotifierProvider.autoDispose<
    ArtificialVoiceEditSheetController,
    ArtificialVoiceEditSheetState>((ref) => throw UnimplementedError());

class ArtificialVoiceEditSheetController
    extends StateNotifier<ArtificialVoiceEditSheetState> {
  ArtificialVoiceEditSheetController(
      {required ArtificialVoiceEditSheetProviderArg
          artificialVoiceEditSheetProviderArg})
      : _artificialVoiceEditSheetProviderArg =
            artificialVoiceEditSheetProviderArg,
        super(const ArtificialVoiceEditSheetState()) {
    init();
  }

  final ArtificialVoiceEditSheetProviderArg
      _artificialVoiceEditSheetProviderArg;

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
