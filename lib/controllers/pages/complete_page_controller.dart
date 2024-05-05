import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/services/logger.dart';
import 'package:neon3/services/video_player_service.dart';

part 'complete_page_controller.freezed.dart';

@freezed
class CompletePageState with _$CompletePageState {
  const factory CompletePageState({
    @Default(false) bool isPlaying,
    @Default(null) VideoPlayerService? videoPlayerService,
  }) = _CompletePageState;
}

final completePageProvider = StateNotifierProvider.autoDispose<
    CompletePageController, CompletePageState>((ref) {
  return throw UnimplementedError();
});

class CompletePageController extends StateNotifier<CompletePageState> {
  CompletePageController({required String videoFilePath})
      : _videoFilePath = videoFilePath,
        super(const CompletePageState()) {
    init();
  }
  final String _videoFilePath;
  VideoPlayerService? _videoPlayerService;

  Future<void> init() async {
    try {
      _videoPlayerService = VideoPlayerService(videoFilePath: _videoFilePath);
      await _videoPlayerService!.init(addListenersFunction: () {
        state = state.copyWith(isPlaying: _videoPlayerService!.isPlaying);
      });

      state = state.copyWith(videoPlayerService: _videoPlayerService);
      await play();
    } catch (e) {
      Logger.logError('complete_page_controller:init', e.toString());
    }
  }

  Future<void> play() async {
    await _videoPlayerService!.play();
  }

  Future<void> pause() async {
    await _videoPlayerService!.pause();
  }

  @override
  void dispose() {
    _videoPlayerService!.dispose();
    super.dispose();
  }
}
