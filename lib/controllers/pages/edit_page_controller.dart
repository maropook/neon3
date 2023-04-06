import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:maropook_neon2/services/speech_to_text_service.dart';
import 'package:maropook_neon2/services/video_player_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:maropook_neon2/ui/pages/edit_page/edit_page.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

part 'edit_page_controller.freezed.dart';

@freezed
class EditPageState with _$EditPageState {
  const factory EditPageState({
    @Default(false) bool isPlaying,
    @Default(null) VideoPlayerService? videoPlayerService,
    @Default([]) List<SubtitleText> subtitleTexts,
    @Default(false) bool isAvatarActive,
    @Default(0.0) double videoPlayerWidth,
  }) = _EditPageState;
}

final editPageProvider =
    StateNotifierProvider.autoDispose<EditPageController, EditPageState>((ref) {
  return throw UnimplementedError();
});

class EditPageController extends StateNotifier<EditPageState> {
  EditPageController({
    required String videoFilePath,
    required String audioFilePath,
    required List<Map<String, double>> activeFrames,
  })  : _videoFilePath = videoFilePath,
        _audioFilePath = audioFilePath,
        _activeFrames = activeFrames,
        super(const EditPageState()) {
    init();
  }

  final String _videoFilePath;
  final String _audioFilePath;
  final List<Map<String, double>> _activeFrames;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SpeechToTextService _speechToTextService = SpeechToTextService();
  VideoPlayerService? _videoPlayerService;

  List<Map<String, double>> sampleActiveFrames = [
    {"startTime": 0, "endTime": 1.0},
    {"startTime": 0, "endTime": 1.0},
    {"startTime": 0, "endTime": 1.5}
  ];

  Future<void> init() async {
    try {
      // await _speechToTextService.buildTexts(sampleActiveFrames, _audioFilePath,
      await _speechToTextService.buildTexts(_activeFrames, _audioFilePath,
          (List<SubtitleText> texts) {
        state = state.copyWith(subtitleTexts: texts);
      });
      _videoPlayerService = VideoPlayerService(videoFilePath: _videoFilePath);
      await _videoPlayerService!.init(addListenersFunction: () {
        state = state.copyWith(isPlaying: _videoPlayerService!.isPlaying);
        state = state.copyWith(
            isAvatarActive:
                isAvatarActive(_videoPlayerService!.currentSeconds));
      });

      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      state = state.copyWith(videoPlayerService: _videoPlayerService);
      await play();
      getVideoPlayerWidth(editVideoPlayerKey);
    } catch (e) {
      Logger.logError('edit_controller:init', e.toString());
    }
  }

  void getVideoPlayerWidth(GlobalKey globalKey) {
    try {
      state = state.copyWith(
          videoPlayerWidth: globalKey.currentContext?.size?.width ?? 0);
    } catch (e) {
      Logger.logError('get_video_player_width', e.toString());
    }
  }

  Future<void> play() async {
    await _videoPlayerService!.play();
    await _audioPlayer.play(UrlSource(_audioFilePath));
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    await _videoPlayerService!.pause();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _videoPlayerService!.dispose();
    super.dispose();
  }

  bool isAvatarActive(double currentSeconds) {
    for (int i = 0; i < _activeFrames.length; ++i) {
      if (_activeFrames[i]['startTime']! <= currentSeconds &&
          _activeFrames[i]['endTime']! >= currentSeconds) {
        return true;
      }
    }
    return false;
  }
}
