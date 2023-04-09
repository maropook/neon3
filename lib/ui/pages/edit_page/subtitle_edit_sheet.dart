import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/subtitle_edit_sheet_controller.dart';
import 'package:neon3/ui/components/src/universal_image.dart';
import 'package:neon3/ui/pages/edit_page/edit_subtitle_texts_painter.dart';
import 'package:neon3/ui/pages/page_router.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

final GlobalKey subtitleEditVideoPlayerKey = GlobalKey();

Future<void> showSubtitleEditSheet(
  BuildContext context,
  SubtitleEditPageArgs subtitleEditPageArgs,
) {
  return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return _SubtitleEditSheet(
          subtitleEditPageArgs: subtitleEditPageArgs,
        );
      });
}

class _SubtitleEditSheet extends StatelessWidget {
  const _SubtitleEditSheet({required this.subtitleEditPageArgs, super.key});

  final SubtitleEditPageArgs subtitleEditPageArgs;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(overrides: [
      subtitleEditSheetProvider.overrideWith((ref) {
        final subtitleEditSheetProviderArg = SubtitleEditSheetProviderArg(
          videoFilePath: subtitleEditPageArgs.videoFilePath,
          audioFilePath: subtitleEditPageArgs.audioFilePath,
          activeFrames: subtitleEditPageArgs.activeFrames,
          subtitleTexts: subtitleEditPageArgs.subtitleTexts,
          shortestSide: MediaQuery.of(context).size.shortestSide,
        );
        return SubtitleEditSheetController(
            subtitleEditSheetProviderArg: subtitleEditSheetProviderArg);
      })
    ], child: _buildModal(context));
  }

  Widget _buildModal(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.longestSide - 64,
        margin: const EdgeInsets.only(top: 64),
        decoration: const BoxDecoration(
          color: Color.fromARGB(109, 0, 0, 0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: _buildBody());
  }

  Widget _buildBody() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              _buildVideoPlayer(),
              _buildAvatar(),
            ],
          ),
          _buildThumbnail(),
          _buildTimeline(),
          _buildSubtitleTextsTimeline(),
        ]);
  }

  Widget _buildSubtitleTextsTimeline() {
    return Consumer(builder: (context, ref, _) {
      final List<SubtitleText> texts =
          ref.watch(subtitleEditSheetProvider.select((s) => s.subtitleTexts));
      final Duration videoPosition =
          ref.watch(subtitleEditSheetProvider.select((s) => s.videoPosition));
      final Duration videoDuration = ref.watch(subtitleEditSheetProvider
          .select((s) => s.videoPlayerService?.duration ?? Duration.zero));
      final timelineWidth = ref.watch(
          subtitleEditSheetProvider.notifier.select((s) => s.timelineWidth));
      final thumbnailHeight = ref.watch(
          subtitleEditSheetProvider.notifier.select((s) => s.thumbnailHeight));

      ref.watch(subtitleEditSheetProvider.select((s) => s.thumbnailService));

      return Container(
        color: Colors.grey[150],
        width: timelineWidth,
        child: Column(
          children: [
            for (int index = 0; index < texts.length; ++index)
              GestureDetector(
                onHorizontalDragStart: (DragStartDetails details) {
                  ref
                      .read(subtitleEditSheetProvider.notifier)
                      .startDrag(details, index);
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  ref
                      .read(subtitleEditSheetProvider.notifier)
                      .updateDrag(details, index);
                },
                child: CustomPaint(
                  foregroundPainter: EditSubtitleTextsPainter(
                    texts[index],
                    videoDuration,
                    timelineWidth,
                    thumbnailHeight,
                  ),
                  child: Container(
                    color: const Color.fromARGB(255, 50, 50, 50),
                    height: thumbnailHeight,
                    width: timelineWidth + 6,
                  ),
                ),
              ),
            for (int i = 0; i < texts.length; i++)
              Text("${texts[i].startTime}:${texts[i].word}",
                  style: const TextStyle(color: Colors.black)),
          ],
        ),
      );
    });
  }

  Widget _buildTimeline() {
    return Consumer(builder: (context, ref, _) {
      final Duration videoPosition =
          ref.watch(subtitleEditSheetProvider.select((s) => s.videoPosition));
      final Duration videoDuration = ref.watch(subtitleEditSheetProvider
          .select((s) => s.videoPlayerService?.duration ?? Duration.zero));
      final timelineWidth = ref.watch(subtitleEditSheetProvider
              .select((s) => s.thumbnailService?.timelineWidth)) ??
          0;

      return SizedBox(
        width: timelineWidth,
        child: ProgressBar(
          progress: videoPosition,
          total: videoDuration,
          onSeek: (duration) {
            ref
                .read(subtitleEditSheetProvider.notifier)
                .seek(duration: duration);
          },
          baseBarColor: Colors.grey.withOpacity(0.24),
          barHeight: 15.0,
          thumbRadius: 7.5,
          barCapShape: BarCapShape.square,
        ),
      );
    });
  }

  Widget _buildThumbnail() {
    return Consumer(builder: (context, ref, _) {
      final List<Uint8List?> thumbnailFileDataList = ref.watch(
          subtitleEditSheetProvider.select((s) => s.thumbnailFileDataList));
      final thumbnailService = ref
          .watch(subtitleEditSheetProvider.select((s) => s.thumbnailService));

      return thumbnailService != null
          ? Center(
              child: SizedBox(
                height: thumbnailService.thumbnailHeight,
                width: thumbnailService.timelineWidth,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: thumbnailFileDataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: thumbnailService.thumbnailHeight,
                        width: thumbnailService.thumbnailWidth,
                        child: Image(
                          image: MemoryImage(thumbnailFileDataList[index]!),
                          fit: BoxFit.fitHeight,
                        ),
                      );
                    }),
              ),
            )
          : const CircularProgressIndicator();
    });
  }

  Widget _buildVideoPlayer() {
    return Consumer(builder: (context, ref, _) {
      final videoController = ref
          .watch(subtitleEditSheetProvider.select((s) => s.videoPlayerService));
      final editPageController = ref.read(subtitleEditSheetProvider.notifier);
      final isPlaying =
          ref.watch(subtitleEditSheetProvider.select((s) => s.isPlaying));

      return RepaintBoundary(
        key: subtitleEditVideoPlayerKey,
        child: videoController != null
            ? SizedBox(
                height: 250,
                child: GestureDetector(
                  onTap: () {
                    isPlaying
                        ? editPageController.pause()
                        : editPageController.play();
                  },
                  child: videoController.buildVideoPlayer(),
                ),
              )
            : const CircularProgressIndicator(),
      );
    });
  }

  Widget _buildAvatar() {
    return Consumer(builder: (context, ref, _) {
      final isAvatarActive =
          ref.watch(subtitleEditSheetProvider.select((s) => s.isAvatarActive));
      final videoPlayerWidth = ref
          .watch(subtitleEditSheetProvider.select((s) => s.videoPlayerWidth));

      return SizedBox(
        width: videoPlayerWidth / 2,
        child: UniversalImage(isAvatarActive
            ? subtitleEditPageArgs.avatar.activeImageUrl
            : subtitleEditPageArgs.avatar.stopImageUrl),
      );
    });
  }
}
