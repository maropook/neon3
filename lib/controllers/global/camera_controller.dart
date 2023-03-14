import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/services/logger.dart';

part 'camera_controller.freezed.dart';

@freezed
class CameraState with _$CameraState {
  const factory CameraState({
    @Default(null) CameraController? controller,
    @Default(false) bool isRecordingVideo,
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

  Future<void> init() async {
    try {
      final cameras = await availableCameras();
      final selectedCamera = cameras[0]; //0:外カメ 1:内カメ
      final controller =
          CameraController(selectedCamera, ResolutionPreset.medium);
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
      await cameraController?.startVideoRecording();
    } on CameraException catch (e) {
      Logger.logError('camera_provider_controller', e.toString());
    }
  }

  Future<String?> stopVideoRecording() async {
    try {
      final file = await cameraController?.stopVideoRecording();
      return file?.path;
    } on CameraException catch (e) {
      Logger.logError('camera_provider_controller', e.toString());
      return null;
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}
