import 'package:camera/camera.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:record/record.dart';

part 'camera_controller.freezed.dart';

@freezed
class CameraState with _$CameraState {
  const factory CameraState({
    @Default(null) CameraController? controller,
    @Default(false) bool isRecordingVideo,
    @Default(null) String? videoFilePath,
    @Default(null) String? audioFilePath,
  }) = _CameraState;
}

final cameraProvider =
    StateNotifierProvider.autoDispose<CameraProviderController, CameraState>(
        (ref) {
  return CameraProviderController();
});

class CameraProviderController extends StateNotifier<CameraState> {
  CameraProviderController() : super(const CameraState()) {
    init();
  }

  CameraController? cameraController;
  final Record record = Record();

  Future<void> init() async {
    try {
      final cameras = await availableCameras();
      final selectedCamera = cameras[0]; //0:外カメ 1:内カメ
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

  Future<void> startVideoRecording() async {
    try {
      if (await record.hasPermission()) {
        await record.start(
          path: 'audio_file.m4a',
        );
      }
      await cameraController?.startVideoRecording();
    } on CameraException catch (e) {
      Logger.logError('camera_provider_controller', e.toString());
    }
  }

  Future<void> stopVideoRecording() async {
    try {
      final audioFilePath = await record.stop();
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
