import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/import_sheet_controller.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/services/audio_record_service.dart';
import 'package:neon3/services/camera_service.dart';
import 'package:neon3/services/encode_service.dart';
import 'package:neon3/services/fire_avatar_service.dart';
import 'package:neon3/services/logger.dart';
import 'package:neon3/ui/pages/page_router.dart';
import 'package:neon3/ui/pages/recording_page/recording_page.dart';
import 'package:path_provider/path_provider.dart';
part 'recording_page_controller.freezed.dart';

@freezed
class RecordingPageState with _$RecordingPageState {
  const factory RecordingPageState({
    @Default(null) CameraService? cameraService,
    @Default(false) bool isRecordingVideo,
    @Default(null) String? videoFilePath,
    @Default(null) String? audioFilePath,
    @Default(0.0) double currentSeconds,
    @Default(false) bool isAvatarActive,
    @Default(null) Avatar? selectedAvatar,
    @Default([]) List<Map<String, double>> activeFrames,
    @Default(RecordingType.camera) RecordingType recordingType,
    @Default('') String importedFilePath,
    @Default(1.0) double recordingBackgroundWidth,
  }) = _CameraState;
}

final recordingPageProvider = StateNotifierProvider.autoDispose<
    RecordingPageController, RecordingPageState>((ref) {
  return throw UnimplementedError();
});

class RecordingPageController extends StateNotifier<RecordingPageState> {
  RecordingPageController({required BuildContext context})
      : _context = context,
        super(const RecordingPageState()) {
    init();
  }

  final BuildContext _context;
  final CameraService _cameraService = CameraService();
  final AudioRecordService _audioRecordService = AudioRecordService();
  final FireAvatarService _fireAvatarService = FireAvatarService();
  final double recordingTimeLimit = 60.0;
  Future<void> init() async {
    try {
      await fetchSelectedAvatarFromId();
      await _cameraService.init(addListenersFunction: () {
        state =
            state.copyWith(isRecordingVideo: _cameraService.isRecordingVideo);
      });
      state = state.copyWith(cameraService: _cameraService);
      Future.delayed(const Duration(milliseconds: 500)).then((_) {
        getRecordingBackgroundWidth();
      });
    } catch (e) {
      Logger.logError('recording_page_controller:init', e.toString());
    }
  }

  Future<void> startRecording() async {
    try {
      await setTimer();
      await _audioRecordService.startAudioRecording(
          '${(await getApplicationDocumentsDirectory()).path}/audio_file.m4a');
      await _cameraService.startRecording();
    } on CameraException catch (e) {
      Logger.logError(
          'recording_page_controller:start_recording', e.toString());
    }
  }

  Future<void> stopRecording() async {
    try {
      final audioFilePath = await _audioRecordService.stopAudioRecording();
      final videoFilePath = await _cameraService.stopRecording();

      state = state.copyWith(
          audioFilePath: audioFilePath, videoFilePath: videoFilePath);
    } on CameraException catch (e) {
      Logger.logError('recording_page_controller', e.toString());
    }
  }

  Future<void> stopRecordingBecauseOfTimeLimit() async {
    final recordingType = state.recordingType;

    if (recordingType == RecordingType.camera) {
      stopRecording();
    } else if (recordingType == RecordingType.image) {
      await stopRecordingWithImage();
    }

    final videoFilePath = state.videoFilePath;
    final audioFilePath = state.audioFilePath;
    final activeFrames = state.activeFrames;
    final avatar = state.selectedAvatar;
    final importedFilePath = state.importedFilePath;

    if (audioFilePath != null && videoFilePath != null && avatar != null) {
      await disposeTimer();
      final editPageArgs = EditPageArgs(
          audioFilePath: recordingType == RecordingType.video
              ? importedFilePath //videoのときはそもそもaudioFilePathいらない
              : audioFilePath,
          videoFilePath: videoFilePath,
          activeFrames: [
            //TODO:仮の値
            {"startTime": 0.2, "endTime": 0.7},
            {"startTime": 1.2, "endTime": 1.6},
            {"startTime": 2.0, "endTime": 2.2}
          ],
          avatar: avatar,
          recordingType: recordingType);
      _context.go('/edit', extra: editPageArgs);
    }
    return;
  }

  Future<void> stopRecordingWithImage() async {
    try {
      final audioFilePath = await _audioRecordService.stopAudioRecording();
      final EncodeService encodeService = EncodeService();
      final String videoFilePath = await encodeService.imageToVideo(
          imagePath: state.importedFilePath,
          videoDuration: Duration(
              milliseconds: currentSeconds *
                  1000 ~/
                  2)); //imageToVideoはvideoDurationの2倍の長さになってしまうので
      state = state.copyWith(
          audioFilePath: audioFilePath, videoFilePath: videoFilePath);
    } catch (e) {
      Logger.logError('recording_page_controller', e.toString());
    }
  }

  Future<void> disposeTimer() async {
    _frameTimer?.cancel();
    _secondTimer?.cancel();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _audioRecordService.dispose();
    super.dispose();
  }

  //avatar
  Future<Avatar> fetchSelectedAvatarFromId() async {
    String selectedAvatarId = await _fireAvatarService.fetchSelectedAvatarId();
    if (selectedAvatarId.isEmpty) {
      state = state.copyWith(selectedAvatar: defaultAvatar);
      return defaultAvatar;
    }
    final Avatar selectedAvatar =
        await _fireAvatarService.fetchAvatarFromUuid(id: selectedAvatarId) ??
            defaultAvatar;
    state = state.copyWith(selectedAvatar: selectedAvatar);
    return selectedAvatar;
  }

  //animation_avatar
  Timer? _secondTimer;
  Timer? _frameTimer;
  double startSeconds = 0.0;
  int _currentDetailedFrame = 0;

  final double threshold = 10.0;
  final int fps = 60;
  int get spf => 1000 ~/ fps;

  double get currentMillSeconds => 0.001 * (_currentDetailedFrame * spf);
  double get currentSeconds => state.currentSeconds + currentMillSeconds;

  Future<bool> getIsAvatarActive() async => await peak() > threshold;

  Future<double> peak() async {
    final amplitude = await _audioRecordService.getAmplitude();
    return amplitude.current + 40;
  }

  Future<void> setTimer() async {
    state = state.copyWith(currentSeconds: 0.0);
    _frameTimer = Timer.periodic(Duration(milliseconds: spf), (timer) async {
      _currentDetailedFrame++;
      await setActiveFrames();
    });
    _secondTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      state = state.copyWith(currentSeconds: state.currentSeconds + 1.0);
      _currentDetailedFrame = 0;
      if (currentSeconds >= recordingTimeLimit) {
        await stopRecordingBecauseOfTimeLimit();
      }
    });
  }

  Future<void> setActiveFrames() async {
    final isAvatarActive = await getIsAvatarActive();

    if (state.isAvatarActive == isAvatarActive) return;

    state = state.copyWith(isAvatarActive: isAvatarActive);

    if (isAvatarActive) {
      startSeconds = currentSeconds;
    } else {
      state = state.copyWith(activeFrames: [
        ...state.activeFrames,
        {"startTime": startSeconds, "endTime": currentSeconds},
      ]);
      Logger.log("setActiveFrames", state.activeFrames.toString());
    }
  }

  void setImportSheetArg(ImportSheetArg? arg) {
    if (arg == null) return;
    state = state.copyWith(
        recordingType: arg.recordingType,
        importedFilePath: arg.importedFilePath);
    getRecordingBackgroundWidth();
  }

  void getRecordingBackgroundWidth() {
    try {
      state = state.copyWith(
          recordingBackgroundWidth:
              recordingBackgroundKey.currentContext?.size?.width ?? 1);
    } catch (e) {
      Logger.logError('get_video_player_width', e.toString());
    }
  }
}

List<Map<String, double>> activeFrames = [
  {"startTime": 1.3, "endTime": 2.0},
  {"startTime": 3.0, "endTime": 4.5}
];
