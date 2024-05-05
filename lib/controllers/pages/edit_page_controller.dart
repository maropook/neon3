import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/artificial_voice_edit_sheet_controller.dart';
import 'package:neon3/controllers/pages/import_sheet_controller.dart';
import 'package:neon3/models/src/active_frame.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/services/audio_player_service.dart';
import 'package:neon3/services/encode_service.dart';
import 'package:neon3/services/logger.dart';
import 'package:neon3/services/speech_to_text_service.dart';
import 'package:neon3/services/text_to_speech.dart';
import 'package:neon3/services/thumbnail_service.dart';
import 'package:neon3/services/video_player_service.dart';
import 'package:neon3/ui/pages/edit_page/edit_page.dart';
import 'package:neon_video_encoder/subtitle_text.dart';
import 'package:uuid/uuid.dart';

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
    @Default(1.0) double videoPlayerWidth,
    @Default('') String thumbnailFilePath,
    @Default('') String musicFilePath,
    @Default('') String ttsAudioFilePath,
    @Default(false) bool isMergeTtsAudio,
    @Default(AudioType.original) AudioType audioType,
    @Default([]) List<Uint8List?> thumbnailFileDataList,
    @Default(Duration.zero) Duration videoPosition,
    @Default(Duration.zero) Duration beforeShowingVideoPosition,
    @Default(false) bool isComplete,
    @Default([]) List<int> displaySubtitleIndexList,
    @Default(false) bool isExistSubtitleTextNow,
    @Default(0) int focusTextsIndex,
    @Default(0.0) double currentSeconds,
    @Default([]) List<ActiveFrame> activeFrames,
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
  final List<ActiveFrame> activeFrames;
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

  ThumbnailService? _thumbnailService;
  VideoPlayerService? _videoPlayerService;
  AudioPlayerService? _audioPlayerService;
  AudioPlayerService? _musicPlayerService;
  AudioPlayerService? _ttsAudioPlayerService;

//video_player_service
  bool get isPlaying => _videoPlayerService?.isPlaying ?? false;
  Duration get videoDuration => _videoPlayerService?.duration ?? Duration.zero;
  Duration get position => _videoPlayerService?.position ?? Duration.zero;
  // double get currentSeconds => _videoPlayerService?.currentSeconds ?? 0.0;
  double get aspectRatio => _videoPlayerService?.aspectRatio ?? 1;
  double get videoDurationInMilliseconds =>
      _videoPlayerService?.videoDurationInMilliseconds ?? 0.0;
  double get videoDurationInSeconds => videoDurationInMilliseconds * 0.001;

//thumbnail_service
  double get thumbnailHeight => shortestSide / 7;
  double get thumbnailWidth => thumbnailHeight * aspectRatio;
  int get numberOfThumbnails => shortestSide ~/ thumbnailWidth;
  double get timelineWidth =>
      numberOfThumbnails * thumbnailHeight * aspectRatio;
  double get eachPart => _thumbnailService?.eachPart ?? 0;
  double get shortestSide => _editPageProviderArg.shortestSide;

//animation_avatar
  Timer? _secondTimer;
  Timer? _frameTimer;
  //videoPlayerのaddListenerはfpsが2レベルなのでカクつくので自作のTimerでAvatarや字幕の出現の判定をする
  double startSeconds = 0.0;
  int _currentDetailedFrame = 0;

  final double threshold = 10.0;
  //1秒あたりの画像コマ数 videoPlayerのCallBackは0.485~0.496あたりの間
  final int fps = 10;
  int get spf => 1000 ~/ fps;

  double get currentMillSeconds => 0.001 * (_currentDetailedFrame * spf);
  double get currentSeconds => state.currentSeconds + currentMillSeconds;

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
        setDisplaySubtitleTextIndex();
        print(currentSeconds);
        state = state.copyWith(
          // isComplete: isVideoComplete(_videoPlayerService!),
          isPlaying: isPlaying,
          videoPosition: position,
          // isAvatarActive: isAvatarActive(currentSeconds)
        );
        videoCompleteCallback();
      });
      if (recordingType != RecordingType.video) {
        _audioPlayerService =
            AudioPlayerService(_editPageProviderArg.audioFilePath);
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

      //playの後だと呼び出されない時があるので
      await Future.delayed(const Duration(milliseconds: 700)).then((_) {
        getVideoPlayerWidth(editVideoPlayerKey);
      });
      await play();
    } catch (e) {
      Logger.logError('edit_controller:init', e.toString());
    }
  }

  Future<void> play() async {
    await _videoPlayerService?.play();
    await _audioPlayerService?.play(_editPageProviderArg.audioFilePath);

    setTimer();

    await _musicPlayerService?.play(state.musicFilePath);
    await _ttsAudioPlayerService?.play(state.ttsAudioFilePath);
  }

  Future<void> seek({required Duration duration}) async {
    await _audioPlayerService?.seek(duration: duration);
    await _videoPlayerService?.seek(duration: duration);

    await _musicPlayerService?.seek(duration: duration);
    await _ttsAudioPlayerService?.seek(duration: duration);

    disposeTimer();
    seekTimer(duration);
  }

  Future<void> pause() async {
    await _audioPlayerService?.pause();
    await _videoPlayerService?.pause();

    await _musicPlayerService?.pause();
    await _ttsAudioPlayerService?.pause();

    disposeTimer();
  }

  Future<void> setTimer() async {
    _frameTimer = Timer.periodic(Duration(milliseconds: spf), (timer) async {
      _currentDetailedFrame++;
      print(currentSeconds);
      setDisplaySubtitleTextIndex();
      state = state.copyWith(
        isAvatarActive: isAvatarActive(currentSeconds),
        // videoPosition: Duration(milliseconds: (currentSeconds * 0.001).toInt()),
      );
    });
    _secondTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      state = state.copyWith(currentSeconds: state.currentSeconds + 1.0);
      _currentDetailedFrame = 0;
    });
  }

  void seekTimer(Duration duration) {
    state = state.copyWith(currentSeconds: duration.inSeconds.toDouble());
    _currentDetailedFrame = 0;
  }

  void resetTime() {
    state = state.copyWith(currentSeconds: 0.0);
    _currentDetailedFrame = 0;
  }

  void disposeTimer() {
    resetTime();
    _frameTimer?.cancel();
    _secondTimer?.cancel();
  }

  @override
  void dispose() {
    _audioPlayerService?.dispose();
    _videoPlayerService?.dispose();

    _musicPlayerService?.pause();
    _ttsAudioPlayerService?.pause();

    disposeTimer();

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
      final width = globalKey.currentContext?.size?.width;
      Logger.log('get_video_player_width', width.toString()); //ログがないと表示されない時がある

      state = state.copyWith(videoPlayerWidth: width ?? 1);
    } catch (e) {
      Logger.logError('get_video_player_width', e.toString());
    }
  }

  bool isAvatarActive(double currentSeconds) {
    for (int i = 0; i < state.activeFrames.length; ++i) {
      if (state.activeFrames[i].startTime <= currentSeconds &&
          state.activeFrames[i].endTime >= currentSeconds) {
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

      //TODO: ttsAudioFilePathにdeleteを入れるのは良くない＆deleteしたら作ったttsAudioFileがなくなってしまう。
      //artificialのまま字幕の文字全部消えて、そのままencode_controllerにaudioTypeを渡すとエラーになると思うが、
      //(いまのところ反映されないのでエラーにならない。一回字幕作成を押さないとつくりなおされないから)&audioTypeではなく人工音声のfilePathを渡していて、
      //isEmptyのときはoriginalとみなしてencodeされるようにしているから

      await _ttsAudioPlayerService?.dispose();
      _ttsAudioPlayerService = null;
      _audioPlayerService =
          AudioPlayerService(_editPageProviderArg.audioFilePath);
      state =
          state.copyWith(ttsAudioFilePath: '', audioType: AudioType.original);
      return;
    }

    await _audioPlayerService?.dispose();
    _audioPlayerService = null;
    _ttsAudioPlayerService = AudioPlayerService(ttsAudioFilePath);
    state = state.copyWith(
        ttsAudioFilePath: ttsAudioFilePath, audioType: AudioType.artificial);
  }

  //subtitle_display
  void setDisplaySubtitleTextIndex() {
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
    final newActiveFrame = ActiveFrame(
      id: const Uuid().v4(),
      startTime: currentSeconds,
      endTime: (currentSeconds + videoDurationInSeconds) / 2,
    );

    final newSubtitleText = SubtitleText(
      id: newActiveFrame.id,
      startTime: newActiveFrame.startTime,
      endTime: newActiveFrame.endTime,
      word: '',
    );

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

  void deleteSubtitle(String id) {
    final subtitleTexts =
        state.subtitleTexts.where((text) => text.id != id).toList();
    final activeFrames =
        state.activeFrames.where((frame) => frame.id != id).toList();

    state = state.copyWith(
        subtitleTexts: [...subtitleTexts], activeFrames: [...activeFrames]);
  }

//artificial_voice
  final TextToSpeechService textToSpeechService = TextToSpeechService();
  final EncodeService encodeService = EncodeService();

  bool isExistTexts() {
    for (final SubtitleText text in state.subtitleTexts) {
      return text.word != '';
    }
    return false;
  }

  Future<String?> switchAudioType(AudioType targetAudioType) async {
    //というかttsAudioFileをわたせばよいのでは？
    //あとあと字幕変えた時にこまるのか・・字幕の文字変わってるかもしれないから。
    //頻繁に押す人いない
    //ttsAudioTypeだけ渡したらいいんじゃないか？
    //というかこれ字幕変えてすぐは人工音声アップデートされないね、自分で押しに行かないと
    //でもgenerate
    //sheetにisMergeTtsAudioをわたして、arg.isMergeTtsAudioがtrueのときは
    //generateSpeechFileをしない
    //sheetから最初にttsFileをもらう、そのあとはtargetAudioTypeをもらう・・
    if (targetAudioType == AudioType.artificial && isExistTexts()) {
      state = state.copyWith(audioType: AudioType.artificial);
      // if (state.isMergeTtsAudio) {
      //   return state.ttsAudioFilePath;
      // }//作り直してもいいでしょ。
      EasyLoading.show(status: '人口音声を作成中・・');
      final subtitleTexts =
          await textToSpeechService.generateSpeechFile(state.subtitleTexts);
      final ttsAudioFilePath = await encodeService.mergeAudio(subtitleTexts);
      state = state.copyWith(
          ttsAudioFilePath: ttsAudioFilePath,
          isMergeTtsAudio: true,
          subtitleTexts: subtitleTexts);
      EasyLoading.showSuccess('人口音声が作成されました');
      return ttsAudioFilePath;
    }
    state = state.copyWith(audioType: AudioType.original);
    return 'delete';
  }
}
