import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/services/logger.dart';
import 'package:neon3/services/thumbnail_service.dart';
import 'package:neon3/services/video_player_service.dart';

part 'trim_page_controller.freezed.dart';

enum EditorDragType { left, center, right }

@freezed
class TrimPageState with _$TrimPageState {
  const factory TrimPageState({
    @Default(false) bool isPlaying,
    @Default(null) VideoPlayerService? videoPlayerService,
    @Default(null) ThumbnailService? thumbnailService,
    @Default([]) List<Uint8List?> thumbnailFileDataList,
    @Default(0.0) double previousVideoCurrentSeconds,
    @Default(0.0) double seekBarsLeftPadding,
    @Default(0.0) double testSeekBarsLeftPadding,
    @Default(0.0) double startTimeInMilliseconds,
    @Default(0.0) double endTimeInMilliseconds,
    @Default(false) bool isPlayingBeforeDrag,
  }) = _TrimPageState;
}

final trimPageProvider =
    StateNotifierProvider.autoDispose<TrimPageController, TrimPageState>((ref) {
  return throw UnimplementedError();
});

class TrimPageProviderArg {
  TrimPageProviderArg({
    required this.videoFilePath,
    required this.shortestSide,
  });

  final String videoFilePath;
  final double shortestSide;
}

class TrimPageController extends StateNotifier<TrimPageState> {
  TrimPageController({required TrimPageProviderArg editPageProviderArg})
      : _editPageProviderArg = editPageProviderArg,
        super(const TrimPageState()) {
    init();
  }
  final TrimPageProviderArg _editPageProviderArg;
  VideoPlayerService? _videoPlayerService;
  ThumbnailService? _thumbnailService;

  //video_player_service
  Duration get videoDuration => _videoPlayerService?.duration ?? Duration.zero;
  Duration get position => _videoPlayerService?.position ?? Duration.zero;
  double get videoCurrentSeconds => _videoPlayerService?.currentSeconds ?? 0.0;
  double get videoDurationInMilliseconds =>
      _videoPlayerService?.videoDurationInMilliseconds ?? 0.0;
  double get videoDurationInSeconds =>
      (_videoPlayerService?.videoDurationInMilliseconds ?? 1) / 1000;
  double get aspectRatio => _videoPlayerService?.aspectRatio ?? 1;
  bool get isPlaying => _videoPlayerService?.isPlaying ?? false;

  //thumbnail_service
  double get thumbnailHeight => shortestSide / 7;
  double get thumbnailWidth => thumbnailHeight * aspectRatio;
  int get numberOfThumbnails => shortestSide ~/ thumbnailWidth;
  double get timelineWidth =>
      numberOfThumbnails * thumbnailHeight * aspectRatio;
  double get eachPart => _thumbnailService?.eachPart ?? 0;
  double get shortestSide => _editPageProviderArg.shortestSide;

  //animation
  Timer? _frameTimer;
  double startSeconds = 0.0;
  double elapsedMilliSeconds = 0.0;
  double get calculatedVideoCurrentSeconds =>
      state.previousVideoCurrentSeconds + elapsedMilliSeconds * 0.001;
  final int fps = 60;
  int get spf => 1000 ~/ fps;

  double get maxTimelinesLeftPadding => timelineWidth - 3;
  double seekBarsLeftPadding() {
    double timelinesLeftPadding =
        (calculatedVideoCurrentSeconds / videoDurationInSeconds) *
            timelineWidth;
    if (timelinesLeftPadding >= maxTimelinesLeftPadding) {
      return maxTimelinesLeftPadding;
    }
    return timelinesLeftPadding;
  }

  double testSeekBarsLeftPadding() {
    double timelinesLeftPadding =
        (videoCurrentSeconds / videoDurationInSeconds) * timelineWidth;
    if (timelinesLeftPadding >= maxTimelinesLeftPadding) {
      return maxTimelinesLeftPadding;
    }
    return timelinesLeftPadding;
  }

  double get maxTrimRectWidth =>
      videoTimeLimitInMillSeconds / videoDurationInMilliseconds * timelineWidth;
  double videoTimeLimitInMillSeconds = 60000.0;
  bool get isOverTimeLimitBeforeTrim =>
      videoDurationInMilliseconds > videoTimeLimitInMillSeconds;

  Future<void> init() async {
    try {
      _videoPlayerService =
          VideoPlayerService(videoFilePath: _editPageProviderArg.videoFilePath);
      await _videoPlayerService!.init(addListenersFunction: () {
        state = state.copyWith(
            isPlaying: _videoPlayerService!.isPlaying,
            testSeekBarsLeftPadding: testSeekBarsLeftPadding());
      });

      _thumbnailService = ThumbnailService(
          videoFilePath: _editPageProviderArg.videoFilePath,
          aspectRatio: aspectRatio,
          shortestSide: _editPageProviderArg.shortestSide,
          videoDurationMs: videoDurationInMilliseconds);

      state = state.copyWith(
          videoPlayerService: _videoPlayerService,
          endTimeInMilliseconds: isOverTimeLimitBeforeTrim
              ? videoTimeLimitInMillSeconds
              : videoDurationInMilliseconds,
          thumbnailService: _thumbnailService);

      _thumbnailService!.generateThumbnails().listen((event) {
        state = state.copyWith(thumbnailFileDataList: [...event]);
      });

      await play();
    } catch (e) {
      Logger.logError('trim_page_controller:init', e.toString());
    }
  }

  Future<void> videoCompleteCallback() async {
    bool isVideoComplete = isPlaying &&
        position > Duration.zero &&
        calculatedVideoCurrentSeconds * 1000 >= state.endTimeInMilliseconds;

    if (!isVideoComplete) return;
    await rewindVideoStart();
  }

  Future<void> rewindVideoStart() async {
    await _videoPlayerService!.pause();
    state = state.copyWith(
        previousVideoCurrentSeconds: state.startTimeInMilliseconds * 0.001);
    disposeTimer();
    await seek(
        duration: Duration(
            microseconds: (state.startTimeInMilliseconds * 1000).toInt()));
    elapsedMilliSeconds = 0.0;
    state = state.copyWith(seekBarsLeftPadding: seekBarsLeftPadding());
  }

  Future<void> setTimer() async {
    elapsedMilliSeconds = 0.0;
    _frameTimer =
        Timer.periodic(const Duration(milliseconds: 20), (timer) async {
      elapsedMilliSeconds = elapsedMilliSeconds + 20;
      state = state.copyWith(seekBarsLeftPadding: seekBarsLeftPadding());
      videoCompleteCallback();
    });
  }

  void disposeTimer() async {
    _frameTimer?.cancel();
  }

  Future<void> play() async {
    await _videoPlayerService!.play();
    await setTimer();
  }

  Future<void> pause() async {
    state = state.copyWith(
        previousVideoCurrentSeconds: calculatedVideoCurrentSeconds);
    disposeTimer();
    await _videoPlayerService!.pause();
  }

  Future<void> seek({required Duration duration}) async {
    await _videoPlayerService!.seek(duration: duration);
  }

  //subtitle_edit
  EditorDragType _dragType = EditorDragType.left;

  Offset dragStartPosition() {
    final double startTimeInMilliseconds = state.startTimeInMilliseconds;
    final Offset startPos = Offset(
        startTimeInMilliseconds / videoDuration.inMilliseconds * timelineWidth,
        0);
    return startPos;
  }

  Offset dragEndPosition() {
    final double endTimeInMilliseconds = state.endTimeInMilliseconds;
    final Offset endPos = Offset(
        endTimeInMilliseconds / videoDuration.inMilliseconds * timelineWidth,
        0);
    return endPos;
  }

  void startTimeDragged(Offset startPos) {
    final startTimeInMilliseconds =
        videoDurationInMilliseconds * startPos.dx / timelineWidth;
    state = state.copyWith(startTimeInMilliseconds: startTimeInMilliseconds);
  }

  void endTimeDragged(Offset endPos) {
    final endTimeInMilliseconds =
        videoDurationInMilliseconds * endPos.dx / timelineWidth;
    state = state.copyWith(endTimeInMilliseconds: endTimeInMilliseconds);
  }

  void startAndEndTimeDragged(Offset startPos, Offset endPos) {
    startTimeDragged(startPos);
    endTimeDragged(endPos);
  }

  void dragStart(DragStartDetails details) {
    const int sideSize = 24;
    state = state.copyWith(isPlayingBeforeDrag: isPlaying);

    if (details.localPosition.dx <= dragStartPosition().dx + sideSize) {
      _dragType = EditorDragType.left;
    } else if (details.localPosition.dx <= dragEndPosition().dx - sideSize) {
      _dragType = EditorDragType.center;
    } else {
      _dragType = EditorDragType.right;
    }
  }

  void dragUpdate(DragUpdateDetails details) {
    Offset startPos = dragStartPosition();
    Offset endPos = dragEndPosition();
    if (_dragType == EditorDragType.left) {
      if (((startPos.dx + details.delta.dx >= 0) &&
              (startPos.dx + details.delta.dx <= endPos.dx)) &&
          !(endPos.dx - startPos.dx - details.delta.dx > maxTrimRectWidth)) {
        startPos += details.delta;
        startTimeDragged(startPos);
      }
    } else if (_dragType == EditorDragType.center) {
      if ((startPos.dx + details.delta.dx >= 0) &&
          (endPos.dx + details.delta.dx <= timelineWidth)) {
        startPos += details.delta;
        endPos += details.delta;
        startAndEndTimeDragged(startPos, endPos);
      }
    } else {
      if ((endPos.dx + details.delta.dx <= timelineWidth) &&
          (endPos.dx + details.delta.dx >= startPos.dx) &&
          !(endPos.dx - startPos.dx + details.delta.dx > maxTrimRectWidth)) {
        endPos += details.delta;
        endTimeDragged(endPos);
      }
    }
  }

  Future<void> dragEnd(DragEndDetails details) async {
    await rewindVideoStart();
    if (!state.isPlayingBeforeDrag) return;
    await play();
  }

  @override
  void dispose() {
    if (isPlaying) {
      disposeTimer();
    }
    _videoPlayerService!.dispose();
    super.dispose();
  }
}
