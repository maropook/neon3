import 'dart:io';

import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart' as ap;

part 'edit_page_controller.freezed.dart';

@freezed
class EditPageState with _$EditPageState {
  const factory EditPageState({
    @Default(false) bool isPlaying,
    @Default(null) VideoPlayerController? controller,
  }) = _EditPageState;
}

final editPageProvider =
    StateNotifierProvider.autoDispose<EditController, EditPageState>((ref) {
  return throw UnimplementedError();
});

class EditController extends StateNotifier<EditPageState> {
  EditController({
    required String videoFilePath,
    required String audioFilePath,
  })  : _videoFilePath = videoFilePath,
        _audioFilePath = audioFilePath,
        super(const EditPageState()) {
    init();
  }
  VideoPlayerController? _videoPlayerController;
  final String _videoFilePath;
  final String _audioFilePath;
  final ap.AudioPlayer _audioPlayer = ap.AudioPlayer();

  Future<void> init() async {
    try {
      _videoPlayerController = VideoPlayerController.file(File(_videoFilePath));
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.setLooping(true);
      addVideoPlayerControllerListener(_videoPlayerController!);

      state = state.copyWith(controller: _videoPlayerController);
      await play();
    } catch (e) {
      Logger.logError('edit_controller', e.toString());
    }
  }

  void addVideoPlayerControllerListener(VideoPlayerController controller) {
    controller.addListener(() {
      state = state.copyWith(isPlaying: controller.value.isPlaying);
    });
  }

  Future<void> play() async {
    await _audioPlayer.play(ap.UrlSource(_audioFilePath));
    await _videoPlayerController!.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    await _videoPlayerController!.pause();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }
}
