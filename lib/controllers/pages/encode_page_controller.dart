import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/services/encode_service.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

part 'encode_page_controller.freezed.dart';

@freezed
class EncodePageState with _$EncodePageState {
  const factory EncodePageState({
    @Default(0.0) double progressRate,
    @Default('') String encodedVideoFilePath,
  }) = _EncodePageState;
}

final encodePageProvider =
    StateNotifierProvider.autoDispose<EncodeController, EncodePageState>((ref) {
  return throw UnimplementedError();
});

class EncodeController extends StateNotifier<EncodePageState> {
  EncodeController(
      {required String videoFilePath,
      required String audioFilePath,
      required Avatar avatar,
      required List<SubtitleText> subtitleTexts,
      required List<Map<String, double>> activeFrames})
      : _videoFilePath = videoFilePath,
        _audioFilePath = audioFilePath,
        _avatar = avatar,
        _subtitleTexts = subtitleTexts,
        _activeFrames = activeFrames,
        super(const EncodePageState()) {
    init();
  }
  final String _videoFilePath;
  final String _audioFilePath;
  final Avatar _avatar;
  final List<SubtitleText> _subtitleTexts;
  final List<Map<String, double>> _activeFrames;
  final EncodeService _encodeService = EncodeService();

  Future<void> init() async {
    final String encodedVideoFilePath = await _encodeService.encode(
        addListenersFunction: (dynamic value) {
          state = state.copyWith(progressRate: value as double);
        },
        audioFilePath: _audioFilePath,
        videoFilePath: _videoFilePath,
        activeFrames: _activeFrames,
        subtitleTexts: _subtitleTexts,
        avatar: _avatar);

    state = state.copyWith(encodedVideoFilePath: encodedVideoFilePath);
  }
}
