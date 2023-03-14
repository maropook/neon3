import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:video_player/video_player.dart';

part 'edit_page_controller.freezed.dart';

@freezed
class EditPageState with _$EditPageState {
  const factory EditPageState({
    @Default(false) bool isInitialized,
    @Default(null) String? videoFilePath,
    @Default(null) VideoPlayerController? controller,
  }) = _EditPageState;
}

final editPageProvider =
    StateNotifierProvider.autoDispose<EditController, EditPageState>((ref) {
  return throw UnimplementedError();
});

class EditController extends StateNotifier<EditPageState> {
  EditController({required String videoFilePath})
      : _videoFilePath = videoFilePath,
        super(const EditPageState()) {
    init();
  }
  VideoPlayerController? _videoPlayerController;
  final String _videoFilePath;

  Future<void> init() async {
    try {
      // _videoPlayerController = VideoPlayerController.asset(_videoFilePath);
      _videoPlayerController =
          VideoPlayerController.asset("assets/movies/sample.mp4");
      await _videoPlayerController!.initialize();
      state = state.copyWith(controller: _videoPlayerController);
      await _videoPlayerController!.play();
    } catch (e) {
      Logger.logError('edit_controller', e.toString());
    }
  }

  void addVideoPlayerControllerListener(VideoPlayerController controller) {
    controller.addListener(() {});
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }
}
