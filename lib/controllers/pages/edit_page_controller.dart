import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:maropook_neon2/services/video_player_service.dart';
import 'package:audioplayers/audioplayers.dart';

part 'edit_page_controller.freezed.dart';

@freezed
class EditPageState with _$EditPageState {
  const factory EditPageState({
    @Default(false) bool isPlaying,
    @Default(null) VideoPlayerService? videoPlayerService,
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
  })  : _videoFilePath = videoFilePath,
        _audioFilePath = audioFilePath,
        super(const EditPageState()) {
    init();
  }

  final String _videoFilePath;
  final String _audioFilePath;
  final AudioPlayer _audioPlayer = AudioPlayer();
  VideoPlayerService? _videoPlayerService;

  Future<void> init() async {
    try {
      _videoPlayerService = VideoPlayerService(videoFilePath: _videoFilePath);
      await _videoPlayerService!.init(addListenersFunction: () {
        state = state.copyWith(isPlaying: _videoPlayerService!.isPlaying);
      });

      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      state = state.copyWith(videoPlayerService: _videoPlayerService);
      await play();
    } catch (e) {
      Logger.logError('edit_controller:init', e.toString());
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
}
