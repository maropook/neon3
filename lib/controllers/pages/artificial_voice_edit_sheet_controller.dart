import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/services/encode_service.dart';
import 'package:neon3/services/file_service.dart';
import 'package:neon3/services/fire_avatar_service.dart';
import 'package:neon3/services/text_to_speech.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

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
  final TextToSpeechService textToSpeechService = TextToSpeechService();
  final EncodeService encodeService = EncodeService();
  Future<void> init() async {
    state = state.copyWith(
        subtitleTexts: _artificialVoiceEditSheetProviderArg.subtitleTexts);
  }

  bool isExistTexts() {
    for (final SubtitleText text in state.subtitleTexts) {
      return text.word != '';
    }
    return false;
  }

  Future<String?> switchAudioType(AudioType targetAudioType) async {
    state = state.copyWith(audioType: targetAudioType);

    if (targetAudioType == AudioType.artificial && isExistTexts()) {
      if (state.isMergeTtsAudio) {
        return state.ttsAudioFilePath;
      }
      EasyLoading.show();
      final subtitleTexts =
          await textToSpeechService.generateSpeechFile(state.subtitleTexts);
      final ttsAudioFilePath = await encodeService.mergeAudio(subtitleTexts);
      state = state.copyWith(
          ttsAudioFilePath: ttsAudioFilePath,
          isMergeTtsAudio: true,
          subtitleTexts: subtitleTexts);
      EasyLoading.dismiss();
      return ttsAudioFilePath;
    }
    return 'delete';
  }
}
