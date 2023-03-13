import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/controllers/global/camera_controller.dart';

class RecordingPage extends ConsumerWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraController =
        ref.watch(cameraProvider.select((s) => s.controller));

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('レコーディング'),
          actions: [
            IconButton(
                onPressed: () => context.go('/import'),
                icon: const Icon(Icons.download_rounded)),
            IconButton(
                onPressed: () => context.go('/edit/path'),
                icon: const Icon(Icons.chevron_right)),
          ],
          leading: IconButton(
              onPressed: () => context.go('/avatar/list'),
              icon: const Icon(Icons.face)),
        ),
        body: cameraController != null
            ? _buildBody(cameraController)
            : const Center(child: CircularProgressIndicator()));
  }

  Widget _buildBody(CameraController cameraController) {
    return Consumer(builder: (context, ref, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [CameraPreview(cameraController), _buildButton()],
      );
    });
  }

  Widget _buildButton() {
    return Consumer(builder: (context, ref, _) {
      final bool isRecording =
          ref.watch(cameraProvider.select((s) => s.isRecordingVideo));

      return GestureDetector(
        onTap: () {
          if (isRecording) {
            ref.read(cameraProvider.notifier).stopVideoRecording();
            return;
          }
          ref.read(cameraProvider.notifier).startVideoRecording();
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(
              color: Colors.white,
              width: 5.0,
            ),
          ),
          child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: isRecording ? BoxShape.rectangle : BoxShape.circle,
                color: Colors.red,
              )),
        ),
      );
    });
  }
}
