import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/models/src/active_frame.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/services/encode_service.dart';
import 'package:neon3/services/logger.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

part 'encode_page_controller.freezed.dart';

@freezed
class EncodePageState with _$EncodePageState {
  const factory EncodePageState({
    @Default(0.0) double progressRate,
    @Default('') String encodedVideoFilePath,
  }) = _EncodePageState;
}

class EncodePageProviderArg {
  EncodePageProviderArg(
      {required this.videoFilePath,
      required this.audioFilePath,
      required this.musicFilePath,
      required this.ttsAudioFilePath,
      required this.avatar,
      required this.subtitleTexts,
      required this.activeFrames});

  final String videoFilePath;
  final String audioFilePath;
  final String musicFilePath;
  final String ttsAudioFilePath;
  final Avatar avatar;
  final List<SubtitleText> subtitleTexts;
  final List<ActiveFrame> activeFrames;
}

final encodePageProvider =
    StateNotifierProvider.autoDispose<EncodePageController, EncodePageState>(
        (ref) {
  return throw UnimplementedError();
});

class EncodePageController extends StateNotifier<EncodePageState> {
  EncodePageController({
    required EncodePageProviderArg encodePageProviderArg,
  })  : _encodePageProviderArg = encodePageProviderArg,
        super(const EncodePageState()) {
    init();
  }
  final EncodePageProviderArg _encodePageProviderArg;

  final EncodeService _encodeService = EncodeService();

  Future<void> init() async {
    final String encodedVideoFilePath = await _encodeService.encode(
        addListenersFunction: (dynamic value) {
          state = state.copyWith(progressRate: value as double);
        },
        audioFilePath: _encodePageProviderArg.audioFilePath,
        musicFilePath: _encodePageProviderArg.musicFilePath,
        ttsAudioFilePath: _encodePageProviderArg.ttsAudioFilePath,
        videoFilePath: _encodePageProviderArg.videoFilePath,
        activeFrames: _encodePageProviderArg.activeFrames,
        subtitleTexts: _encodePageProviderArg.subtitleTexts,
        avatar: _encodePageProviderArg.avatar);

    final bool? success = await GallerySaver.saveVideo(encodedVideoFilePath);
    Logger.log('encode_page_controller', '[init save_video] $success');

    state = state.copyWith(encodedVideoFilePath: encodedVideoFilePath);
  }
}
