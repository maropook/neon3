import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/services/logger.dart';
import 'package:neon3/services/speech_to_text_service.dart';
import 'package:neon3/services/thumbnail_service.dart';
import 'package:neon3/services/video_player_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:neon3/ui/pages/edit_page/edit_page.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

part 'edit_page_controller.freezed.dart';

@freezed
class EditPageState with _$EditPageState {
  const factory EditPageState({
    @Default(false) bool isPlaying,
    @Default(null) VideoPlayerService? videoPlayerService,
    @Default(null) ThumbnailService? thumbnailService,
    @Default([]) List<SubtitleText> subtitleTexts,
    @Default(false) bool isAvatarActive,
    @Default(0.0) double videoPlayerWidth,
    @Default('') String thumbnailFilePath,
    @Default([]) List<Uint8List?> thumbnailFileDataList,
    @Default(Duration.zero) Duration videoPosition,
    @Default(false) bool isComplete,
  }) = _EditPageState;
}

class EditPageProviderArg {
  EditPageProviderArg({
    required this.videoFilePath,
    required this.audioFilePath,
    required this.activeFrames,
    required this.shortestSide,
  });

  final String videoFilePath;
  final String audioFilePath;
  final List<Map<String, double>> activeFrames;
  final double shortestSide;
}

final editPageProvider =
    StateNotifierProvider.autoDispose<EditPageController, EditPageState>((ref) {
  return throw UnimplementedError();
});

class EditPageController extends StateNotifier<EditPageState> {
  EditPageController({required EditPageProviderArg editPageProviderArg})
      : _editPageProviderArg = editPageProviderArg,
        super(const EditPageState()) {
    init();
  }

  final EditPageProviderArg _editPageProviderArg;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final SpeechToTextService _speechToTextService = SpeechToTextService();
  ThumbnailService? _thumbnailService;
  VideoPlayerService? _videoPlayerService;

  Future<void> init() async {
    try {
      // await _speechToTextService.buildTexts(sampleActiveFrames, _audioFilePath,
      await _speechToTextService.buildTexts(
          _editPageProviderArg.activeFrames, _editPageProviderArg.audioFilePath,
          (List<SubtitleText> texts) {
        state = state.copyWith(subtitleTexts: texts);
      });
      _videoPlayerService =
          VideoPlayerService(videoFilePath: _editPageProviderArg.videoFilePath);
      await _videoPlayerService!.init(addListenersFunction: () {
        videoCompleteCallback(_videoPlayerService!);
        state = state.copyWith(
            // isComplete: isVideoComplete(_videoPlayerService!),
            isPlaying: _videoPlayerService!.isPlaying,
            videoPosition: _videoPlayerService!.position,
            isAvatarActive:
                isAvatarActive(_videoPlayerService!.currentSeconds));
      });

      // await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      _thumbnailService = ThumbnailService(
          videoFilePath: _editPageProviderArg.videoFilePath,
          aspectRatio: _videoPlayerService!.aspectRatio,
          shortestSide: _editPageProviderArg.shortestSide,
          videoDurationMs: _videoPlayerService!.videoDurationInMilliseconds);

      state = state.copyWith(
          videoPlayerService: _videoPlayerService,
          thumbnailService: _thumbnailService);

      _thumbnailService!.generateThumbnails().listen((event) {
        state = state.copyWith(thumbnailFileDataList: [...event]);
      });

      await play();
      getVideoPlayerWidth(editVideoPlayerKey); //playのあとじゃないとうまく行かない
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
    await _audioPlayer.play(UrlSource(_editPageProviderArg.audioFilePath));
  }

  Future<void> seek({required Duration duration}) async {
    await _audioPlayer.seek(duration);
    await _videoPlayerService!.seek(duration: duration);
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

  Future<void> videoCompleteCallback(
      VideoPlayerService videoPlayerService) async {
    bool isVideoComplete = !videoPlayerService.isPlaying &&
        videoPlayerService.position > Duration.zero &&
        videoPlayerService.position.inMicroseconds >=
            videoPlayerService.duration.inMicroseconds;

    if (!isVideoComplete) return;
    await seek(duration: Duration.zero);
    await play();
  }

  bool isAvatarActive(double currentSeconds) {
    for (int i = 0; i < _editPageProviderArg.activeFrames.length; ++i) {
      if (_editPageProviderArg.activeFrames[i]['startTime']! <=
              currentSeconds &&
          _editPageProviderArg.activeFrames[i]['endTime']! >= currentSeconds) {
        return true;
      }
    }
    return false;
  }
}
