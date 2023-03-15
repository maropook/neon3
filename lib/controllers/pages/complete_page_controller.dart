import 'dart:io';

import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:video_player/video_player.dart';

part 'complete_page_controller.freezed.dart';

@freezed
class CompletePageState with _$CompletePageState {
  const factory CompletePageState({
    @Default(false) bool isPlaying,
    @Default(null) VideoPlayerController? controller,
  }) = _CompletePageState;
}

final completePageProvider =
    StateNotifierProvider.autoDispose<CompleteController, CompletePageState>(
        (ref) {
  return throw UnimplementedError();
});

class CompleteController extends StateNotifier<CompletePageState> {
  CompleteController({required String videoFilePath})
      : _videoFilePath = videoFilePath,
        super(const CompletePageState()) {
    init();
  }
  VideoPlayerController? _videoPlayerController;
  final String _videoFilePath;

  Future<void> init() async {
    try {
      _videoPlayerController = VideoPlayerController.file(File(_videoFilePath));
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.setLooping(true);
      addVideoPlayerControllerListener(_videoPlayerController!);
      state = state.copyWith(controller: _videoPlayerController);
      await _videoPlayerController!.play();
    } catch (e) {
      Logger.logError('complete_controller', e.toString());
    }
  }

  void addVideoPlayerControllerListener(VideoPlayerController controller) {
    controller.addListener(() {
      state = state.copyWith(isPlaying: controller.value.isPlaying);
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }
}
