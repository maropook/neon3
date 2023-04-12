import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/services/logger.dart';
import 'package:neon3/services/thumbnail_service.dart';
import 'package:neon3/services/video_player_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:neon3/ui/pages/edit_page/subtitle_edit_sheet.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

part 'subtitle_edit_sheet_controller.freezed.dart';

enum EditorDragType { left, center, right }

@freezed
class SubtitleEditSheetState with _$SubtitleEditSheetState {
  const factory SubtitleEditSheetState({
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
  }) = _SubtitleEditSheetState;
}

class SubtitleEditSheetProviderArg {
  SubtitleEditSheetProviderArg({
    required this.videoFilePath,
    required this.audioFilePath,
    required this.activeFrames,
    required this.shortestSide,
    required this.subtitleTexts,
  });

  final String videoFilePath;
  final String audioFilePath;
  final List<Map<String, double>> activeFrames;
  final List<SubtitleText> subtitleTexts;
  final double shortestSide;
}

final subtitleEditSheetProvider = StateNotifierProvider.autoDispose<
    SubtitleEditSheetController, SubtitleEditSheetState>((ref) {
  return throw UnimplementedError();
});

class SubtitleEditSheetController
    extends StateNotifier<SubtitleEditSheetState> {
  SubtitleEditSheetController(
      {required SubtitleEditSheetProviderArg subtitleEditSheetProviderArg})
      : _subtitleEditSheetProviderArg = subtitleEditSheetProviderArg,
        super(const SubtitleEditSheetState()) {
    init();
  }

  final SubtitleEditSheetProviderArg _subtitleEditSheetProviderArg;

  final AudioPlayer _audioPlayer = AudioPlayer();
  ThumbnailService? _thumbnailService;
  VideoPlayerService? _videoPlayerService;

  //video_player_service
  bool get isPlaying => _videoPlayerService?.isPlaying ?? false;
  Duration get videoDuration => _videoPlayerService?.duration ?? Duration.zero;
  Duration get position => _videoPlayerService?.position ?? Duration.zero;
  double get currentSeconds => _videoPlayerService?.currentSeconds ?? 0.0;
  double get aspectRatio => _videoPlayerService?.aspectRatio ?? 1;
  int get videoDurationInMilliseconds =>
      _videoPlayerService?.videoDurationInMilliseconds ?? 0;

//thumbnail_service
  double get thumbnailHeight => shortestSide / 7;
  double get thumbnailWidth => thumbnailHeight * aspectRatio;
  int get numberOfThumbnails => shortestSide ~/ thumbnailWidth;
  double get timelineWidth =>
      numberOfThumbnails * thumbnailHeight * aspectRatio;
  double get eachPart => _thumbnailService?.eachPart ?? 0;
  double get shortestSide => _subtitleEditSheetProviderArg.shortestSide;

  Future<void> init() async {
    try {
      state = state.copyWith(
          subtitleTexts: _subtitleEditSheetProviderArg.subtitleTexts);
      _videoPlayerService = VideoPlayerService(
          videoFilePath: _subtitleEditSheetProviderArg.videoFilePath);
      await _videoPlayerService!.init(addListenersFunction: () {
        videoCompleteCallback();
        state = state.copyWith(
            // isComplete: isVideoComplete(_videoPlayerService!),
            isPlaying: isPlaying,
            videoPosition: position,
            isAvatarActive: isAvatarActive(currentSeconds));
      });

      // await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      _thumbnailService = ThumbnailService(
          videoFilePath: _subtitleEditSheetProviderArg.videoFilePath,
          aspectRatio: aspectRatio,
          shortestSide: _subtitleEditSheetProviderArg.shortestSide,
          videoDurationMs: videoDurationInMilliseconds);

      state = state.copyWith(
          videoPlayerService: _videoPlayerService,
          thumbnailService: _thumbnailService);

      _thumbnailService!.generateThumbnails().listen((event) {
        state = state.copyWith(thumbnailFileDataList: [...event]);
      });

      await play();
      getVideoPlayerWidth(subtitleEditVideoPlayerKey); //playのあとじゃないとうまく行かない
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
    await _videoPlayerService?.play();
    await _audioPlayer
        .play(UrlSource(_subtitleEditSheetProviderArg.audioFilePath));
  }

  Future<void> seek({required Duration duration}) async {
    await _audioPlayer.seek(duration);
    await _videoPlayerService?.seek(duration: duration);
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    await _videoPlayerService?.pause();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _videoPlayerService?.dispose();
    super.dispose();
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
    for (int i = 0;
        i < _subtitleEditSheetProviderArg.activeFrames.length;
        ++i) {
      if (_subtitleEditSheetProviderArg.activeFrames[i]['startTime']! <=
              currentSeconds &&
          _subtitleEditSheetProviderArg.activeFrames[i]['endTime']! >=
              currentSeconds) {
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

  void startTimeDragged(int index, Offset startPos) {
    final startTimeInMilliseconds =
        videoDurationInMilliseconds * startPos.dx / timelineWidth;
    final startTime = startTimeInMilliseconds / 1000;
    _subtitleEditSheetProviderArg.activeFrames[index]['startTime'] = startTime;

    final texts = state.subtitleTexts; //TODO:もう少しうまくできそう
    texts[index].startTime = startTime;
    state = state.copyWith(subtitleTexts: [...texts]);
  }

  void endTimeDragged(int index, Offset endPos) {
    final endTimeInMilliseconds =
        videoDurationInMilliseconds * endPos.dx / timelineWidth;
    final endTime = endTimeInMilliseconds / 1000; //_videoEndPosはmillisecondsのため

    _subtitleEditSheetProviderArg.activeFrames[index]['endTime'] = endTime;

    final texts = state.subtitleTexts; //TODO:
    texts[index].endTime = endTime;
    state = state.copyWith(subtitleTexts: [...texts]);
  }

  void dragStart(DragStartDetails details, int index) {
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

  void dragUpdate(DragUpdateDetails details, int index) {
    Offset startPos = dragStartPosition(index);
    Offset endPos = dragEndPosition(index);
    if (_dragType == EditorDragType.left) {
      if (((startPos.dx + details.delta.dx >= 0) &&
              (startPos.dx + details.delta.dx <= endPos.dx)) &&
          !(endPos.dx - startPos.dx - details.delta.dx > timelineWidth)) {
        startPos += details.delta;
        startTimeDragged(index, startPos);
      }
    } else if (_dragType == EditorDragType.center) {
      if ((startPos.dx + details.delta.dx >= 0) &&
          (endPos.dx + details.delta.dx <= timelineWidth)) {
        startPos += details.delta;
        endPos += details.delta;
        startTimeDragged(index, startPos);
        endTimeDragged(index, endPos);
      }
    } else {
      if ((endPos.dx + details.delta.dx <= timelineWidth) &&
          (endPos.dx + details.delta.dx >= startPos.dx) &&
          !(endPos.dx - startPos.dx + details.delta.dx > timelineWidth)) {
        endPos += details.delta;
        endTimeDragged(index, endPos);
      }
    }
  }
}
