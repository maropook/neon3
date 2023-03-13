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
            ? CameraPreview(cameraController!)
            : const Center(child: CircularProgressIndicator()));
  }
}
