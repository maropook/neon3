import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'camera_controller.freezed.dart';

@freezed
class CameraState with _$CameraState {
  const factory CameraState({
    @Default([]) List<CameraDescription> cameras,
    @Default(null) CameraController? controller,
  }) = _CameraState;
}

final cameraProvider =
    StateNotifierProvider.autoDispose<CameraProviderController, CameraState>(
        (ref) {
  final cameraProviderController = CameraProviderController();
  ref.onDispose((() => cameraProviderController.cameraController?.dispose()));
  return cameraProviderController;
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
      state = state.copyWith(cameras: cameras, controller: controller);
    } catch (e) {
      debugPrint('$e');
    }
  }
}
