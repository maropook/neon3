import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecordingPage extends ConsumerWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraController = ref.watch(cameraControllerProvider);

    return Scaffold(
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
        body: cameraController.when(
            data: (data) => CameraPreview(data),
            error: (error, stackTrace) => Text('Error: $error'),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )));
  }
}

final cameraControllerProvider =
    FutureProvider.autoDispose<CameraController>((ref) async {
  final cameras = await availableCameras();
  final camera = cameras[0]; //0:外カメ 1:内カメ
  final controller = CameraController(camera, ResolutionPreset.medium);
  await controller.initialize();

  ref.onDispose(() {
    controller.dispose();
  });

  return controller;
});
