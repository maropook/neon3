import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:neon3/services/logger.dart';

class CameraService {
  CameraService();

  CameraController? _cameraController;
  bool get isRecordingVideo =>
      _cameraController?.value.isRecordingVideo ?? false;

  Future<void> init({required void Function() addListenersFunction}) async {
    try {
      final cameras = await availableCameras();
      final selectedCamera = cameras[0];
      _cameraController = CameraController(
          selectedCamera, ResolutionPreset.medium,
          enableAudio: false, imageFormatGroup: ImageFormatGroup.bgra8888);
      await _cameraController!.initialize();
      addListener(addListenersFunction);
    } catch (e) {
      Logger.logError('camera_service:init', e.toString());
    }
  }

  Widget buildCameraPreview() {
    return _cameraController != null
        ? CameraPreview(_cameraController!)
        : const SizedBox();
  }

  void addListener(void Function() addListenersFunction) {
    _cameraController!.addListener(() {
      addListenersFunction();
    });
  }

  Future<void> startRecording() async {
    try {
      await _cameraController?.startVideoRecording();
    } on CameraException catch (e) {
      Logger.logError('camera_service:start_recording', e.toString());
    }
  }

  Future<String?> stopRecording() async {
    try {
      final videoFile = await _cameraController?.stopVideoRecording();
      return videoFile?.path;
    } on CameraException catch (e) {
      Logger.logError('camera_service', e.toString());
      return null;
    }
  }

  void dispose() {
    _cameraController?.dispose();
  }
}
