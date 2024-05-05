import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/models/src/active_frame.dart';
import 'package:neon3/services/logger.dart';
import 'package:neon3/services/thumbnail_service.dart';
import 'package:neon3/services/video_player_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:neon3/ui/pages/edit_page/subtitle_timing_edit_sheet.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

part 'subtitle_timing_edit_sheet_controller.freezed.dart';

enum EditorDragType { left, center, right }

@freezed
class SubtitleTimingEditSheetState with _$SubtitleTimingEditSheetState {
  const factory SubtitleTimingEditSheetState({
    @Default(false) bool isPlaying,
    @Default(null) VideoPlayerService? videoPlayerService,
    @Default(null) ThumbnailService? thumbnailService,
    @Default([]) List<SubtitleText> subtitleTexts,
    @Default([]) List<ActiveFrame> activeFrames,
    @Default(false) bool isAvatarActive,
    @Default(1.0) double videoPlayerWidth,
    @Default('') String thumbnailFilePath,
    @Default([]) List<Uint8List?> thumbnailFileDataList,
    @Default(Duration.zero) Duration videoPosition,
    @Default(false) bool isComplete,
    @Default(0.0) double currentSeconds,
    @Default([]) List<int> displaySubtitleIndexList,
    @Default(false) bool isExistSubtitleTextNow,
  }) = _SubtitleTimingEditSheetState;
}

class SubtitleTimingEditSheetProviderArg {
  SubtitleTimingEditSheetProviderArg({
    required this.videoFilePath,
    required this.audioFilePath,
    required this.activeFrames,
    required this.shortestSide,
    required this.subtitleTexts,
  });

  final String videoFilePath;
  final String audioFilePath;
  final List<ActiveFrame> activeFrames;
  final List<SubtitleText> subtitleTexts;
  final double shortestSide;
}

final subtitleTimingEditSheetProvider = StateNotifierProvider.autoDispose<
    SubtitleTimingEditSheetController, SubtitleTimingEditSheetState>((ref) {
  return throw UnimplementedError();
});

class SubtitleTimingEditSheetController
    extends StateNotifier<SubtitleTimingEditSheetState> {
  SubtitleTimingEditSheetController(
      {required SubtitleTimingEditSheetProviderArg
          subtitleTimingEditSheetProviderArg})
      : _subtitleTimingEditSheetProviderArg =
            subtitleTimingEditSheetProviderArg,
        super(const SubtitleTimingEditSheetState()) {
    init();
  }

  final SubtitleTimingEditSheetProviderArg _subtitleTimingEditSheetProviderArg;

  final AudioPlayer _audioPlayer = AudioPlayer();
  ThumbnailService? _thumbnailService;
  VideoPlayerService? _videoPlayerService;

  //video_player_service
  bool get isPlaying => _videoPlayerService?.isPlaying ?? false;
  Duration get videoDuration => _videoPlayerService?.duration ?? Duration.zero;
  Duration get position => _videoPlayerService?.position ?? Duration.zero;
  double get aspectRatio => _videoPlayerService?.aspectRatio ?? 1;
  double get videoDurationInMilliseconds =>
      _videoPlayerService?.videoDurationInMilliseconds ?? 0;

//thumbnail_service
  double get thumbnailHeight => shortestSide / 7;
  double get thumbnailWidth => thumbnailHeight * aspectRatio;
  int get numberOfThumbnails => shortestSide ~/ thumbnailWidth;
  double get timelineWidth =>
      numberOfThumbnails * thumbnailHeight * aspectRatio;
  double get eachPart => _thumbnailService?.eachPart ?? 0;
  double get shortestSide => _subtitleTimingEditSheetProviderArg.shortestSide;

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
          //TODO:参照を渡してるからeditできている。
          subtitleTexts: _subtitleTimingEditSheetProviderArg.subtitleTexts,
          activeFrames: _subtitleTimingEditSheetProviderArg.activeFrames);
      _videoPlayerService = VideoPlayerService(
          videoFilePath: _subtitleTimingEditSheetProviderArg.videoFilePath);
      await _videoPlayerService!.init(addListenersFunction: () {
        videoCompleteCallback();
        state = state.copyWith(
          // isComplete: isVideoComplete(_videoPlayerService!),
          isPlaying: isPlaying,
          videoPosition: position,
          isAvatarActive: isAvatarActive(currentSeconds),
        );
      });

      // await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      _thumbnailService = ThumbnailService(
          videoFilePath: _subtitleTimingEditSheetProviderArg.videoFilePath,
          aspectRatio: aspectRatio,
          shortestSide: _subtitleTimingEditSheetProviderArg.shortestSide,
          videoDurationMs: videoDurationInMilliseconds);

      state = state.copyWith(
          videoPlayerService: _videoPlayerService,
          thumbnailService: _thumbnailService);

      _thumbnailService!.generateThumbnails().listen((event) {
        state = state.copyWith(thumbnailFileDataList: [...event]);
      });

      await play();
      getVideoPlayerWidth(
          subtitleTimingEditVideoPlayerKey); //playのあとじゃないとうまく行かない
    } catch (e) {
      Logger.logError('edit_controller:init', e.toString());
    }
  }

  void getVideoPlayerWidth(GlobalKey globalKey) {
    try {
      state = state.copyWith(
          videoPlayerWidth: globalKey.currentContext?.size?.width ?? 1);
    } catch (e) {
      Logger.logError('get_video_player_width', e.toString());
    }
  }

  Future<void> play() async {
    await _videoPlayerService?.play();
    await _audioPlayer
        .play(UrlSource(_subtitleTimingEditSheetProviderArg.audioFilePath));
    setTimer();
  }

  Future<void> seek({required Duration duration}) async {
    await _audioPlayer.seek(duration);
    await _videoPlayerService?.seek(duration: duration);

    disposeTimer();
    seekTimer(duration);
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    await _videoPlayerService?.pause();

    disposeTimer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _videoPlayerService?.dispose();

    disposeTimer();
    super.dispose();
  }

  Future<void> setTimer() async {
    _frameTimer = Timer.periodic(Duration(milliseconds: spf), (timer) async {
      _currentDetailedFrame++;
      print(currentSeconds);
      setDisplaySubtitleTextIndex();
      state = state.copyWith(
        isAvatarActive: isAvatarActive(currentSeconds),
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

  Future<void> videoCompleteCallback() async {
    bool isVideoComplete = !isPlaying &&
        position > Duration.zero &&
        position.inMicroseconds >= videoDuration.inMicroseconds;

    if (!isVideoComplete) return;
    await seek(duration: Duration.zero);
    await play();
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

  //subtitle_edit
  EditorDragType _dragType = EditorDragType.left;

  Offset dragStartPosition(int index) {
    final double startTimeInMilliseconds =
        state.subtitleTexts[index].startTime * 1000;
    final Offset startPos = Offset(
        startTimeInMilliseconds / videoDuration.inMilliseconds * timelineWidth,
        0);
    return startPos;
  }

  Offset dragEndPosition(int index) {
    final double endTimeInMilliseconds =
        state.subtitleTexts[index].endTime * 1000;
    final Offset endPos = Offset(
        endTimeInMilliseconds / videoDuration.inMilliseconds * timelineWidth,
        0);
    return endPos;
  }

  void startTimeDragged(int index, Offset startPos, String id) {
    final startTimeInMilliseconds =
        videoDurationInMilliseconds * startPos.dx / timelineWidth;
    final startTime = startTimeInMilliseconds / 1000;

    final newFrame = state.activeFrames[index];
    newFrame.startTime = startTime;

    final activeFrames = state.activeFrames
        .map((frame) => frame.id == newFrame.id ? newFrame : frame)
        .toList();

    final newText = state.subtitleTexts[index];
    newText.startTime = startTime;

    final texts = state.subtitleTexts
        .map((text) => text.id == newText.id ? newText : text)
        .toList();

    state = state
        .copyWith(subtitleTexts: [...texts], activeFrames: [...activeFrames]);
  }

  void endTimeDragged(int index, Offset endPos, String id) {
    final endTimeInMilliseconds =
        videoDurationInMilliseconds * endPos.dx / timelineWidth;
    final endTime = endTimeInMilliseconds / 1000; //_videoEndPosはmillisecondsのため

    final newFrame = state.activeFrames[index];
    newFrame.endTime = endTime;

    final activeFrames = state.activeFrames
        .map((frame) => frame.id == newFrame.id ? newFrame : frame)
        .toList();

    final newText = state.subtitleTexts[index];
    newText.endTime = endTime;

    final texts = state.subtitleTexts
        .map((text) => text.id == newText.id ? newText : text)
        .toList();

    state = state
        .copyWith(subtitleTexts: [...texts], activeFrames: [...activeFrames]);
  }

  void dragStart(DragStartDetails details, int index, String id) {
    const int sideSize = 24;

    if (details.localPosition.dx <= dragStartPosition(index).dx + sideSize) {
      _dragType = EditorDragType.left;
    } else if (details.localPosition.dx <=
        dragEndPosition(index).dx - sideSize) {
      _dragType = EditorDragType.center;
    } else {
      _dragType = EditorDragType.right;
    }
  }

  void dragUpdate(DragUpdateDetails details, int index, String id) {
    Offset startPos = dragStartPosition(index);
    Offset endPos = dragEndPosition(index);
    if (_dragType == EditorDragType.left) {
      if (((startPos.dx + details.delta.dx >= 0) &&
              (startPos.dx + details.delta.dx <= endPos.dx)) &&
          !(endPos.dx - startPos.dx - details.delta.dx > timelineWidth)) {
        startPos += details.delta;
        startTimeDragged(index, startPos, id);
      }
    } else if (_dragType == EditorDragType.center) {
      if ((startPos.dx + details.delta.dx >= 0) &&
          (endPos.dx + details.delta.dx <= timelineWidth)) {
        startPos += details.delta;
        endPos += details.delta;
        startTimeDragged(index, startPos, id);
        endTimeDragged(index, endPos, id);
      }
    } else {
      if ((endPos.dx + details.delta.dx <= timelineWidth) &&
          (endPos.dx + details.delta.dx >= startPos.dx) &&
          !(endPos.dx - startPos.dx + details.delta.dx > timelineWidth)) {
        endPos += details.delta;
        endTimeDragged(index, endPos, id);
      }
    }
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
}
