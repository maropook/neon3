import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/controllers/pages/recording_page_controller.dart';
import 'package:maropook_neon2/models/src/avatar.dart';
import 'package:maropook_neon2/ui/components/src/universal_image.dart';

class RecordingPage extends ConsumerWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Consumer(builder: (context, ref, _) {
      final cameraService =
          ref.watch(recordingPageProvider.select((s) => s.cameraService));
      final isAvatarActive =
          ref.watch(recordingPageProvider.select((s) => s.isAvatarActive));
      final current =
          ref.watch(recordingPageProvider.select((s) => s.currentSeconds));
      final Avatar selectedAvatar =
          ref.watch(recordingPageProvider.select((s) => s.selectedAvatar)) ??
              defaultAvatar;

      return cameraService != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    cameraService.buildCameraPreview(),
                    SizedBox(
                      width: 100,
                      child: UniversalImage(isAvatarActive
                          ? selectedAvatar.activeImageUrl
                          : selectedAvatar.stopImageUrl),
                    ),
                  ],
                ),
                _buildButton(),
                Row(
                  children: [
                    Text(isAvatarActive.toString(),
                        style: const TextStyle(color: Colors.white)),
                    Text(current.toString(),
                        style: const TextStyle(color: Colors.white)),
                  ],
                )
              ],
            )
          : const Center(child: CircularProgressIndicator());
    });
  }

  Widget _buildButton() {
    return Consumer(builder: (context, ref, _) {
      final bool isRecording =
          ref.watch(recordingPageProvider.select((s) => s.isRecordingVideo));

      return GestureDetector(
        onTap: () async {
          if (isRecording) {
            await ref.read(recordingPageProvider.notifier).stopRecording();
            final videoFilePath = ref.read(recordingPageProvider).videoFilePath;
            final audioFilePath = ref.read(recordingPageProvider).audioFilePath;
            final activeFrames = ref.read(recordingPageProvider).activeFrames;
            final avatar = ref.read(recordingPageProvider).selectedAvatar;
            if (audioFilePath != null &&
                videoFilePath != null &&
                avatar != null) {
              ref.read(recordingPageProvider.notifier).disposeTimer();
              context.go('/edit',
                  extra: EditPageArgs(
                      audioFilePath: audioFilePath,
                      videoFilePath: videoFilePath,
                      activeFrames: activeFrames,
                      avatar: avatar));
            }
            return;
          }
          ref.read(recordingPageProvider.notifier).startRecording();
        },
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(
              color: Colors.white,
              width: 5.0,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
              AnimatedContainer(
                width: isRecording ? 30 : 50,
                height: isRecording ? 30 : 50,
                decoration: BoxDecoration(
                  shape: isRecording ? BoxShape.rectangle : BoxShape.rectangle,
                  borderRadius: isRecording
                      ? BorderRadius.circular(4)
                      : BorderRadius.circular(25),
                  color: Colors.red,
                ),
                curve: Curves.linear,
                duration: const Duration(milliseconds: 100),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class EditPageArgs {
  EditPageArgs(
      {required this.audioFilePath,
      required this.videoFilePath,
      required this.activeFrames,
      required this.avatar});

  String audioFilePath;
  String videoFilePath;
  List<Map<String, double>> activeFrames;
  Avatar avatar;
}
