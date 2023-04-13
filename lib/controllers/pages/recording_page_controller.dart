import 'dart:async';

import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/import_sheet_controller.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/services/audio_record_service.dart';
import 'package:neon3/services/camera_service.dart';
import 'package:neon3/services/encode_service.dart';
import 'package:neon3/services/fire_avatar_service.dart';
import 'package:neon3/services/logger.dart';
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
  return RecordingPageController();
});

class RecordingPageController extends StateNotifier<RecordingPageState> {
  RecordingPageController() : super(const RecordingPageState()) {
    init();
  }

  final CameraService _cameraService = CameraService();
  final AudioRecordService _audioRecordService = AudioRecordService();
  final FireAvatarService _fireAvatarService = FireAvatarService();

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

  Future<void> stopRecordingWithVideo() async {
    //これimportしたらそのままedit_homeに行けたほうがいいんじゃないか？
    //buildTextsをできるかわからないが。
    try {
      final audioFilePath = await _audioRecordService.stopAudioRecording();
      final videoFilePath = state.importedFilePath;

      state = state.copyWith(
          audioFilePath: audioFilePath, videoFilePath: videoFilePath);
    } catch (e) {
      Logger.logError('recording_page_controller', e.toString());
    }
  }

  Future<void> stopRecordingWithImage() async {
    try {
      final audioFilePath = await _audioRecordService.stopAudioRecording();
      final EncodeService encodeService = EncodeService();
      final String videoFilePath = await encodeService.imageToVideo(
          imagePath: state.importedFilePath,
          videoDuration: Duration(milliseconds: currentMillSeconds.toInt()));

      state = state.copyWith(
          audioFilePath: audioFilePath, videoFilePath: videoFilePath);
    } on CameraException catch (e) {
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
    _secondTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(currentSeconds: state.currentSeconds + 1.0);
      _currentDetailedFrame = 0;
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
