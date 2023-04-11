import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/artificial_voice_edit_sheet_controller.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/services/audio_player_service.dart';
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
    @Default(null) Avatar? avatar,
    @Default(null) VideoPlayerService? videoPlayerService,
    @Default(null) ThumbnailService? thumbnailService,
    @Default([]) List<SubtitleText> subtitleTexts,
    @Default(false) bool isAvatarActive,
    @Default(0.0) double videoPlayerWidth,
    @Default('') String thumbnailFilePath,
    @Default('') String musicFilePath,
    @Default('') String ttsAudioFilePath,
    @Default(AudioType.original) AudioType audioType,
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
    required this.avatar,
  });

  final String videoFilePath;
  final String audioFilePath;
  final List<Map<String, double>> activeFrames;
  final double shortestSide;
  final Avatar avatar;
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
  final SpeechToTextService _speechToTextService = SpeechToTextService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  ThumbnailService? _thumbnailService;
  VideoPlayerService? _videoPlayerService;
  AudioPlayerService? _musicPlayerService;
  AudioPlayerService? _ttsAudioPlayerService;

//thumbnail_service
  double get thumbnailHeight => shortestSide / 7;
  double get thumbnailWidth => thumbnailHeight * aspectRatio;
  int get numberOfThumbnails => shortestSide ~/ thumbnailWidth;
  double get aspectRatio => _thumbnailService?.aspectRatio ?? 1;
  double get timelineWidth =>
      numberOfThumbnails * thumbnailHeight * aspectRatio;
  double get eachPart => _thumbnailService?.eachPart ?? 0;
  double get shortestSide => _editPageProviderArg.shortestSide;

  Future<void> init() async {
    try {
      // await _speechToTextService.buildTexts(sampleActiveFrames, _audioFilePath,
      state = state.copyWith(avatar: _editPageProviderArg.avatar);
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

    await _musicPlayerService?.play(state.musicFilePath);
    await _ttsAudioPlayerService?.play(state.ttsAudioFilePath);
  }

  Future<void> seek({required Duration duration}) async {
    await _audioPlayer.seek(duration);
    await _videoPlayerService!.seek(duration: duration);

    await _musicPlayerService?.seek(duration: duration);
    await _ttsAudioPlayerService?.seek(duration: duration);
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    await _videoPlayerService!.pause();

    await _musicPlayerService?.pause();
    await _ttsAudioPlayerService?.pause();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _videoPlayerService!.dispose();

    _musicPlayerService?.pause();
    _ttsAudioPlayerService?.pause();

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

  void setSelectedAvatar(Avatar? newAvatar) {
    if (newAvatar == null) return;

    state = state.copyWith(avatar: newAvatar);
  }

  Future<void> setMusicFile(String musicFilePath) async {
    if (musicFilePath.isEmpty) return;
    if (musicFilePath == 'delete') {
      //TODO: originalにされたときはdeleteとかじゃないやり方でやりたい。musicFilePathにdeleteをいれるのはおかしい
      await _musicPlayerService?.dispose();
      _musicPlayerService = null;
      state = state.copyWith(musicFilePath: '');
      return;
    }

    _musicPlayerService = AudioPlayerService(musicFilePath);
    state = state.copyWith(musicFilePath: musicFilePath);
  }

  Future<void> setTtsAudioFile(String ttsAudioFilePath) async {
    if (ttsAudioFilePath.isEmpty) return;
    if (ttsAudioFilePath == 'delete') {
      //TODO: originalにされたときはdeleteとかじゃないやり方でやりたい。ttsAudioFilePathにdeleteをいれるのはおかしい

      //TODO: ttsAudioFilePathにdeleteを入れるのは良くない＆deleteしたらせっかくつくったttsAudioFileがなくなってしまう。
      //artificialのまま字幕の文字全部消えて、そのままencode_controllerにaudioTypeを渡すとエラーになるとおもうが、
      //セーフ(いまのところ反映されない。一回字幕作成を押さないとつくりなおされないから。)&audioTypeではなく人工音声のfilePathを渡していて、
      //isEmptyのときはoriginalとみなしてencodeされるようにしているから

      await _ttsAudioPlayerService?.dispose();
      _ttsAudioPlayerService = null;
      state =
          state.copyWith(ttsAudioFilePath: '', audioType: AudioType.original);
      return;
    }

    _ttsAudioPlayerService = AudioPlayerService(ttsAudioFilePath);
    state = state.copyWith(
        ttsAudioFilePath: ttsAudioFilePath, audioType: AudioType.artificial);
  }
}
