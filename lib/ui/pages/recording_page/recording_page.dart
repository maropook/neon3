import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/config/styles.dart';
import 'package:neon3/controllers/pages/import_sheet_controller.dart';
import 'package:neon3/controllers/pages/recording_page_controller.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/ui/components/src/universal_image.dart';
import 'package:neon3/ui/pages/page_router.dart';
import 'package:neon3/ui/pages/recording_page/import_sheet.dart';

final GlobalKey recordingBackgroundKey = GlobalKey();
const isSimulator = false;

class RecordingPage extends ConsumerWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        recordingPageProvider.overrideWith((ref) {
          return RecordingPageController(context: context);
        })
      ],
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'レコーディング',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Styles.appBarTitleColor),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer(builder: (context, ref, _) {
      final cameraService =
          ref.watch(recordingPageProvider.select((s) => s.cameraService));
      final Size size = MediaQuery.of(context).size;
      double shortestSide = size.shortestSide;

      return cameraService != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildPreview(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImportButton(),
                    _buildRecordingButton(),
                    InkWell(
                        onTap: () => context.go('/avatar/list'),
                        child: _buildShowModalIcon(
                            'アバター', Icons.face, shortestSide)),
                  ],
                ),
                const SizedBox(),
                // _buildMemo(),
              ],
            )
          : Center(
              child: Column(
              children: [
                // InkWell(
                //     onTap: () => context.go('/avatar/list'),
                //     child:
                //         _buildShowModalIcon('アバター', Icons.face, shortestSide)),
                // _buildImportButton(),
                const CircularProgressIndicator(),
              ],
            ));
    });
  }

  Widget _buildImportButton() {
    return Consumer(builder: (context, ref, _) {
      final activeFrames = ref
          .read(recordingPageProvider)
          .activeFrames; //TODO:videoのときactiveFramesが作られない
      final avatar = ref
          .watch(recordingPageProvider)
          .selectedAvatar; //TODO:ref.readだとavatarはnullになる
      //ref.watchじゃないと何故かできない→recordingpageの下にimportPageがあるから、recordingProviderが破棄されて、selectedAvatarがいないままになる
      final Size size = MediaQuery.of(context).size;
      double shortestSide = size.shortestSide;

      return InkWell(
        onTap: () async {
          final ImportSheetArg? importSheetArg = await showImportSheet(
              context, ImportSheetArg(recordingType: RecordingType.camera));
          final recordingType = importSheetArg?.recordingType;
          ref
              .read(recordingPageProvider.notifier)
              .setImportSheetArg(importSheetArg);

          if (importSheetArg == null ||
              avatar == null ||
              recordingType == RecordingType.camera) return;
          if (recordingType == RecordingType.image) {
            ref
                .read(recordingPageProvider.notifier)
                .getRecordingBackgroundWidth();
            return;
          }

          final editPageArgs = EditPageArgs(
              audioFilePath: importSheetArg.importedFilePath,
              videoFilePath: importSheetArg.importedFilePath,
              //TODO:importedFilePathのときactiveFrames設定できない問題
              activeFrames: activeFrames,
              // activeFrames: activeFrames,
              avatar: avatar,
              recordingType: recordingType!);
          if (recordingType == RecordingType.video) {
            context.go('/trim', extra: editPageArgs);
            return;
          }
          context.go('/edit', extra: editPageArgs);
        },
        child:
            _buildShowModalIcon('インポート', Icons.download_rounded, shortestSide),
      );
    });
  }

  Widget _buildShowModalIcon(
      String text, IconData iconData, double shortestSide) {
    return Builder(builder: (context) {
      return Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Icon(
          iconData,
          size: 45,
          color: Styles.secondaryColor,
        ),
      );
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
              // minWidth: 1300,
              maxHeight: MediaQuery.of(context).size.longestSide - 200),
          child: recordingType == RecordingType.camera
              ? cameraService!.buildCameraPreview()
              : UniversalImage(importedFilePath),
        ),
      );
    });
  }

  Widget _buildProgressBar() {
    return Consumer(builder: (context, ref, _) {
      final progressRate =
          ref.watch(recordingPageProvider.select((s) => s.currentSeconds));
      return Padding(
        padding: const EdgeInsets.all(10),
        child: FAProgressBar(
          maxValue: 60,
          currentValue: progressRate,
          size: 10,
          borderRadius: BorderRadiusGeometry.lerp(
              BorderRadius.zero, BorderRadius.zero, 0),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 0),
          progressColor: Styles.primaryColor.withOpacity(0.5),
          backgroundColor: Colors.white.withOpacity(0.5),
        ),
      );
    });
  }

  Widget _buildPreview() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            _buildRecordingBackground(),
            _buildAvatar(),
          ],
        ),
        _buildProgressBar(),
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

  Widget _buildRecordingButton() {
    return Consumer(builder: (context, ref, _) {
      final bool isRecording =
          ref.watch(recordingPageProvider.select((s) => s.isRecordingVideo));

      return GestureDetector(
        onTap: () async {
          if (isRecording) {
            final recordingType = ref.read(recordingPageProvider).recordingType;

            if (recordingType == RecordingType.camera) {
              await ref.read(recordingPageProvider.notifier).stopRecording();
            } else if (recordingType == RecordingType.image) {
              await ref
                  .read(recordingPageProvider.notifier)
                  .stopRecordingWithImage();
            }
            final videoFilePath = ref.read(recordingPageProvider).videoFilePath;
            final audioFilePath = ref.read(recordingPageProvider).audioFilePath;
            final activeFrames = ref.read(recordingPageProvider).activeFrames;
            final avatar = ref.read(recordingPageProvider).selectedAvatar;

            final importedFilePath =
                ref.read(recordingPageProvider).importedFilePath;
            if (audioFilePath != null &&
                videoFilePath != null &&
                avatar != null) {
              ref.read(recordingPageProvider.notifier).disposeTimer();
              final editPageArgs = EditPageArgs(
                  audioFilePath: recordingType == RecordingType.video
                      ? importedFilePath //videoのときはそもそもaudioFilePathいらない
                      : audioFilePath,
                  videoFilePath: videoFilePath,
                  activeFrames: activeFrames,
                  // activeFrames: sampleActiveFrames, //TODO:仮の値
                  // activeFrames: activeFrames,
                  avatar: avatar,
                  recordingType: recordingType);

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
                  color: Styles.secondaryColor,
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
                  color: Styles.recordingColor,
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
