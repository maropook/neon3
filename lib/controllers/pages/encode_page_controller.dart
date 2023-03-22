import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/services/encode_service.dart';

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
      {required String videoFilePath, required String audioFilePath})
      : _videoFilePath = videoFilePath,
        _audioFilePath = audioFilePath,
        super(const EncodePageState()) {
    init();
  }
  final String _videoFilePath;
  final String _audioFilePath;
  final EncodeService _encodeService = EncodeService();

  Future<void> init() async {
    final encodedVideoFilePath = await _encodeService.encode(
        addListenersFunction: (dynamic value) {
          state = state.copyWith(progressRate: value as double);
        },
        audioFilePath: _audioFilePath,
        videoFilePath: _videoFilePath);

    state = state.copyWith(encodedVideoFilePath: encodedVideoFilePath);
  }
}
