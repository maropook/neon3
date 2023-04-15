import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/artificial_voice_edit_sheet_controller.dart';
import 'package:neon3/controllers/pages/import_sheet_controller.dart';
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
    @Default([]) List<int> displaySubtitleIndexList,
    @Default(false) bool isAvatarActive,
    @Default(1.0) double videoPlayerWidth,
    @Default('') String thumbnailFilePath,
    @Default('') String musicFilePath,
    @Default('') String ttsAudioFilePath,
    @Default(AudioType.original) AudioType audioType,
    @Default([]) List<Uint8List?> thumbnailFileDataList,
    @Default(Duration.zero) Duration videoPosition,
    @Default(Duration.zero) Duration beforeShowingVideoPosition,
    @Default(false) bool isComplete,
    @Default(false) bool isExistSubtitleTextNow,
    @Default(0) int focusTextsIndex,
    @Default([]) List<Map<String, double>> activeFrames,
  }) = _EditPageState;
}

class EditPageProviderArg {
  EditPageProviderArg(
      {required this.videoFilePath,
      required this.audioFilePath,
      required this.activeFrames,
      required this.shortestSide,
      required this.avatar,
      required this.recordingType});

  final String videoFilePath;
  final String audioFilePath;
  final List<Map<String, double>> activeFrames;
  final double shortestSide;
  final Avatar avatar;
  final RecordingType recordingType;
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

  RecordingType get recordingType => _editPageProviderArg.recordingType;
  final EditPageProviderArg _editPageProviderArg;
  final SpeechToTextService _speechToTextService = SpeechToTextService();
  AudioPlayer? _audioPlayer;

  ThumbnailService? _thumbnailService;
  VideoPlayerService? _videoPlayerService;
  AudioPlayerService? _musicPlayerService;
  AudioPlayerService? _ttsAudioPlayerService;

//video_player_service
  bool get isPlaying => _videoPlayerService?.isPlaying ?? false;
  Duration get videoDuration => _videoPlayerService?.duration ?? Duration.zero;
  Duration get position => _videoPlayerService?.position ?? Duration.zero;
  double get currentSeconds => _videoPlayerService?.currentSeconds ?? 0.0;
  double get aspectRatio => _videoPlayerService?.aspectRatio ?? 1;
  int get videoDurationInMilliseconds =>
      _videoPlayerService?.videoDurationInMilliseconds ?? 0;
  double get videoDurationInSeconds => videoDurationInMilliseconds * 0.001;

//thumbnail_service
  double get thumbnailHeight => shortestSide / 7;
  double get thumbnailWidth => thumbnailHeight * aspectRatio;
  int get numberOfThumbnails => shortestSide ~/ thumbnailWidth;
  double get timelineWidth =>
      numberOfThumbnails * thumbnailHeight * aspectRatio;
  double get eachPart => _thumbnailService?.eachPart ?? 0;
  double get shortestSide => _editPageProviderArg.shortestSide;

  Future<void> init() async {
    try {
      state = state.copyWith(
          avatar: _editPageProviderArg.avatar,
          activeFrames: _editPageProviderArg.activeFrames);
      await _speechToTextService.buildTexts(
          _editPageProviderArg.activeFrames, _editPageProviderArg.audioFilePath,
          (List<SubtitleText> texts) {
        state = state.copyWith(subtitleTexts: [...texts]);
      });
      _videoPlayerService =
          VideoPlayerService(videoFilePath: _editPageProviderArg.videoFilePath);
      await _videoPlayerService!.init(addListenersFunction: () {
        videoCompleteCallback();
        setDisplaySubtitleTextIndex();
        state = state.copyWith(
            // isComplete: isVideoComplete(_videoPlayerService!),
            isPlaying: isPlaying,
            videoPosition: position,
            isAvatarActive: isAvatarActive(currentSeconds));
      });
      if (recordingType != RecordingType.video) {
        _audioPlayer = AudioPlayer();
      }
      _thumbnailService = ThumbnailService(
          videoFilePath: _editPageProviderArg.videoFilePath,
          aspectRatio: aspectRatio,
          shortestSide: _editPageProviderArg.shortestSide,
          videoDurationMs: videoDurationInMilliseconds);

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

  Future<void> play() async {
    await _videoPlayerService?.play();
    await _audioPlayer?.play(UrlSource(_editPageProviderArg.audioFilePath));

    await _musicPlayerService?.play(state.musicFilePath);
    await _ttsAudioPlayerService?.play(state.ttsAudioFilePath);
  }

  Future<void> seek({required Duration duration}) async {
    await _audioPlayer?.seek(duration);
    await _videoPlayerService?.seek(duration: duration);

    await _musicPlayerService?.seek(duration: duration);
    await _ttsAudioPlayerService?.seek(duration: duration);
  }

  Future<void> pause() async {
    await _audioPlayer?.pause();
    await _videoPlayerService?.pause();

    await _musicPlayerService?.pause();
    await _ttsAudioPlayerService?.pause();
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    _videoPlayerService?.dispose();

    _musicPlayerService?.pause();
    _ttsAudioPlayerService?.pause();

    super.dispose();
  }

  Future<void> showModalCallback() async {
    await pause();
    state = state.copyWith(beforeShowingVideoPosition: position);
  }

  Future<void> closeModalCallback() async {
    await seek(duration: state.beforeShowingVideoPosition);
    await play();
  }

  Future<void> videoCompleteCallback() async {
    bool isVideoComplete = !isPlaying &&
        position > Duration.zero &&
        position.inMicroseconds >= videoDuration.inMicroseconds;

    if (!isVideoComplete) return;
    await seek(duration: Duration.zero);
    await play();
  }

  //avatar
  void getVideoPlayerWidth(GlobalKey globalKey) {
    try {
      state = state.copyWith(
          videoPlayerWidth: globalKey.currentContext?.size?.width ?? 1);
    } catch (e) {
      Logger.logError('get_video_player_width', e.toString());
    }
  }

  bool isAvatarActive(double currentSeconds) {
    for (int i = 0; i < state.activeFrames.length; ++i) {
      if (state.activeFrames[i]['startTime']! <= currentSeconds &&
          state.activeFrames[i]['endTime']! >= currentSeconds) {
        return true;
      }
    }
    return false;
  }

  //select_avatar_modal
  void setSelectedAvatar(Avatar? newAvatar) {
    if (newAvatar == null) return;

    state = state.copyWith(avatar: newAvatar);
  }

  //music_edit_modal
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

  //artificial_voice_edit_modal
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

  //subtitle_display

  void setDisplaySubtitleTextIndex() {
    //video_player_listenerよりtimerでやったほうがいい？
    final texts = state.subtitleTexts;
    bool isExistSubtitleTextNow = false;
    List<int> displaySubtitleIndexList = [];

    for (int i = 0; i < texts.length; ++i) {
      if (texts[i].startTime <= currentSeconds &&
          texts[i].endTime >= currentSeconds) {
        displaySubtitleIndexList.add(i);
        isExistSubtitleTextNow = true;
      }
    }

    state = state.copyWith(
        isExistSubtitleTextNow: isExistSubtitleTextNow,
        displaySubtitleIndexList: [...displaySubtitleIndexList]);
  }

  void updateSubtitle(SubtitleText newText) {
    final subtitleTexts = state.subtitleTexts
        .map((text) => text.id == newText.id ? newText : text)
        .toList();

    state = state.copyWith(subtitleTexts: [...subtitleTexts]);
  }

  void addSubtitle() {
    final newSubtitleText = SubtitleText(
        startTime: currentSeconds, endTime: videoDurationInSeconds, word: '');
    final newActiveFrame = {
      'startTime': currentSeconds,
      'endTime': videoDurationInSeconds
    };
    state = state.copyWith(subtitleTexts: [
      ...state.subtitleTexts,
      newSubtitleText
    ], activeFrames: [
      ...state.activeFrames,
      newActiveFrame,
    ]);

    setDisplaySubtitleTextIndex();
    state = state.copyWith(isAvatarActive: isAvatarActive(currentSeconds));
  }
}
