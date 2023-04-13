import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/import_sheet_controller.dart';
import 'package:neon3/controllers/pages/recording_page_controller.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/ui/components/src/universal_image.dart';
import 'package:neon3/ui/pages/page_router.dart';
import 'package:neon3/ui/pages/recording_page/import_sheet.dart';

final GlobalKey recordingBackgroundKey = GlobalKey();

class RecordingPage extends ConsumerWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('レコーディング'),
      actions: [
        Consumer(builder: (context, ref, _) {
          return IconButton(
              onPressed: () async {
                final ImportSheetArg? importSheetArg = await showImportSheet(
                    context,
                    ImportSheetArg(recordingType: RecordingType.camera));
                ref
                    .read(recordingPageProvider.notifier)
                    .setImportSheetArg(importSheetArg);
              },
              icon: const Icon(Icons.download_rounded));
        })
      ],
      leading: IconButton(
          onPressed: () => context.go('/avatar/list'),
          icon: const Icon(Icons.face)),
    );
  }

  Widget _buildBody() {
    return Consumer(builder: (context, ref, _) {
      final cameraService =
          ref.watch(recordingPageProvider.select((s) => s.cameraService));

      return cameraService != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildPreview(),
                _buildButton(),
                _buildMemo(),
              ],
            )
          : const Center(child: CircularProgressIndicator());
    });
  }

  Widget _buildRecordingBackground() {
    return Consumer(builder: (context, ref, _) {
      final cameraService =
          ref.watch(recordingPageProvider.select((s) => s.cameraService));
      final recordingType =
          ref.watch(recordingPageProvider.select((s) => s.recordingType));
      final importedFilePath =
          ref.watch(recordingPageProvider.select((s) => s.importedFilePath));

      return RepaintBoundary(
        key: recordingBackgroundKey,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: 1300,
              maxHeight: MediaQuery.of(context).size.longestSide - 200),
          child: recordingType == RecordingType.camera
              ? cameraService!.buildCameraPreview()
              : UniversalImage(importedFilePath),
        ),
      );
    });
  }

  Widget _buildPreview() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        _buildRecordingBackground(),
        _buildAvatar(),
      ],
    );
  }

  Widget _buildMemo() {
    return Consumer(builder: (context, ref, _) {
      final bool isAvatarActive =
          ref.watch(recordingPageProvider.select((s) => s.isAvatarActive));
      final double currentSeconds =
          ref.watch(recordingPageProvider.select((s) => s.currentSeconds));

      return Row(
        children: [
          Text(isAvatarActive.toString(),
              style: const TextStyle(color: Colors.white)),
          Text(currentSeconds.toString(),
              style: const TextStyle(color: Colors.white)),
        ],
      );
    });
  }

  Widget _buildAvatar() {
    return Consumer(builder: (context, ref, _) {
      final bool isAvatarActive =
          ref.watch(recordingPageProvider.select((s) => s.isAvatarActive));
      final Avatar selectedAvatar =
          ref.watch(recordingPageProvider.select((s) => s.selectedAvatar)) ??
              defaultAvatar;
      final double avatarWidth = ref.watch(
              recordingPageProvider.select((s) => s.recordingBackgroundWidth)) /
          2;
      return SizedBox(
        width: avatarWidth,
        child: UniversalImage(isAvatarActive
            ? selectedAvatar.activeImageUrl
            : selectedAvatar.stopImageUrl),
      );
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
              final editPageArgs = EditPageArgs(
                  audioFilePath: audioFilePath,
                  videoFilePath: videoFilePath,
                  activeFrames: [
                    //TODO:仮の値
                    {"startTime": 0.2, "endTime": 0.7},
                    {"startTime": 1.2, "endTime": 1.6},
                    {"startTime": 2.0, "endTime": 2.2}
                  ],
                  avatar: avatar);
              context.go('/edit', extra: editPageArgs);
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
