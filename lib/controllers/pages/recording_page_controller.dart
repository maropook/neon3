import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/services/camera_service.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

part 'recording_page_controller.freezed.dart';

@freezed
class RecordingPageState with _$RecordingPageState {
  const factory RecordingPageState({
    @Default(null) CameraService? cameraService,
    @Default(false) bool isRecordingVideo,
    @Default(null) String? videoFilePath,
    @Default(null) String? audioFilePath,
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
  final Record _audioRecorder = Record();

  Future<void> init() async {
    try {
      await _cameraService.init(addListenersFunction: () {
        state =
            state.copyWith(isRecordingVideo: _cameraService.isRecordingVideo);
      });
      state = state.copyWith(cameraService: _cameraService);
    } catch (e) {
      Logger.logError('recording_page_controller:init', e.toString());
    }
  }

  Future<void> startAudioRecording(String audioPath) async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();
      }
    } catch (e) {
      Logger.logError(
          'recording_page_controller:start_audio_recording', e.toString());
    }
  }

  Future<void> startRecording() async {
    try {
      await startAudioRecording(
          '${(await getApplicationDocumentsDirectory()).path}/audio_file.m4a');
      await _cameraService.startRecording();
    } on CameraException catch (e) {
      Logger.logError(
          'recording_page_controller:start_recording', e.toString());
    }
  }

  Future<void> stopRecording() async {
    try {
      final audioFilePath = await _audioRecorder.stop();
      final videoFilePath = await _cameraService.stopRecording();

      state = state.copyWith(
          audioFilePath: audioFilePath, videoFilePath: videoFilePath);
    } on CameraException catch (e) {
      Logger.logError('recording_page_controller', e.toString());
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }
}
