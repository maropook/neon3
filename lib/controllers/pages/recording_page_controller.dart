import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

part 'recording_page_controller.freezed.dart';

@freezed
class RecordingPageState with _$RecordingPageState {
  const factory RecordingPageState({
    @Default(null) CameraController? controller,
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

  CameraController? cameraController;
  final Record _audioRecorder = Record();

  Future<void> init() async {
    try {
      final cameras = await availableCameras();
      final selectedCamera = cameras[0];
      final controller = CameraController(
          selectedCamera, ResolutionPreset.medium,
          enableAudio: false, imageFormatGroup: ImageFormatGroup.bgra8888);
      await controller.initialize();
      cameraController = controller;
      addControllerListener(cameraController!);
      state = state.copyWith(controller: controller);
    } catch (e) {
      Logger.logError('camera_provider_controller', e.toString());
    }
  }

  void addControllerListener(CameraController controller) {
    controller.addListener(() {
      state = state.copyWith(
          isRecordingVideo: cameraController!.value.isRecordingVideo);
    });
  }

  Future<void> startAudioRecording(String audioPath) async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();
      }
    } catch (e) {
      Logger.logError(
          'camera_provider_controller:start_audio_recording', e.toString());
    }
  }

  Future<void> startRecording() async {
    try {
      await startAudioRecording(
          '${(await getApplicationDocumentsDirectory()).path}/audio_file.m4a');
      await cameraController?.startVideoRecording();
    } on CameraException catch (e) {
      Logger.logError(
          'camera_provider_controller:start_recording', e.toString());
    }
  }

  Future<void> stopRecording() async {
    try {
      final audioFilePath = await _audioRecorder.stop();
      final videoFile = await cameraController?.stopVideoRecording();

      state = state.copyWith(
          audioFilePath: audioFilePath, videoFilePath: videoFile?.path);
    } on CameraException catch (e) {
      Logger.logError('camera_provider_controller', e.toString());
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}
