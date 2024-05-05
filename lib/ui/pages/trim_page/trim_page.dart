import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/config/styles.dart';
import 'package:neon3/ui/pages/page_router.dart';
import 'package:neon_video_encoder/neon_video_encoder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:neon3/controllers/pages/trim_page_controller.dart';
import 'package:neon3/ui/pages/trim_page/edit_subtitle_texts_painter.dart';

class TrimPage extends StatelessWidget {
  const TrimPage(this.editPageArgs, {super.key});

  final EditPageArgs editPageArgs;
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        trimPageProvider.overrideWith((ref) => TrimPageController(
            editPageProviderArg: TrimPageProviderArg(
                videoFilePath: editPageArgs.videoFilePath,
                shortestSide: MediaQuery.of(context).size.shortestSide)))
      ],
      child: Scaffold(appBar: _buildAppBar(), body: _buildBody()),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'トリミング',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Styles.secondaryColor),
      ),
      actions: [
        Consumer(builder: (context, ref, _) {
          return IconButton(
              onPressed: () async {
                final NeonVideoEncoder neonVideoEncoder = NeonVideoEncoder();

                final startTimeInSeconds = ref.watch(trimPageProvider
                        .select((s) => s.startTimeInMilliseconds)) *
                    0.001;
                final endTimeInSeconds = ref.watch(trimPageProvider
                        .select((s) => s.endTimeInMilliseconds)) *
                    0.001;
                final trimmedVideoFilePath = await neonVideoEncoder.trimVideo(
                    inputFilePath: editPageArgs.videoFilePath,
                    outputFilePath: await getTempFilePath('trimmed-video.mp4'),
                    startTime: startTimeInSeconds,
                    endTime: endTimeInSeconds);
                editPageArgs.videoFilePath = trimmedVideoFilePath;
                context.go('/edit', extra: editPageArgs);
              },
              icon: const Icon(Icons.chevron_right));
        }),
      ],
    );
  }

  Future<String> getTempFilePath(String fileName) async {
    final Directory documentsDirectory = await getTemporaryDirectory();
    return '${documentsDirectory.path}/$fileName';
  }

  Widget _buildBody() {
    return Consumer(builder: (context, ref, _) {
      final videoPlayerService =
          ref.watch(trimPageProvider.select((s) => s.videoPlayerService));
      final trimPageController = ref.read(trimPageProvider.notifier);
      final isPlaying = ref.watch(trimPageProvider.select((s) => s.isPlaying));
      final Size size = MediaQuery.of(context).size;
      double shortestSide = size.shortestSide;

      return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              videoPlayerService != null
                  ? SizedBox(
                      width: shortestSide * 0.8,
                      child: GestureDetector(
                        onTap: () {
                          isPlaying
                              ? trimPageController.pause()
                              : trimPageController.play();
                        },
                        child: videoPlayerService.buildVideoPlayer(),
                      ),
                    )
                  : const CircularProgressIndicator(),
              _buildTimeline(),
              const SizedBox(),
            ]),
      );
    });
  }

  Widget _buildSeekBar() {
    return Consumer(builder: (context, ref, _) {
      final thumbnailService =
          ref.watch(trimPageProvider.select((s) => s.thumbnailService));
      final seekBarsLeftPadding =
          ref.watch(trimPageProvider.select((s) => s.seekBarsLeftPadding));

      return thumbnailService != null
          ? Positioned(
              top: 3,
              left: seekBarsLeftPadding,
              width: 3,
              height: thumbnailService.thumbnailHeight,
              child: Container(
                color: Styles.primaryColor,
              ),
            )
          : const CircularProgressIndicator();
    });
  }

  Widget _buildTestSeekBar() {
    return Consumer(builder: (context, ref, _) {
      final thumbnailService =
          ref.watch(trimPageProvider.select((s) => s.thumbnailService));
      final seekBarsLeftPadding =
          ref.watch(trimPageProvider.select((s) => s.testSeekBarsLeftPadding));

      return thumbnailService != null
          ? Positioned(
              top: 3,
              left: seekBarsLeftPadding,
              width: 3,
              height: thumbnailService.thumbnailHeight,
              child: Container(
                color: Colors.blue,
              ),
            )
          : const CircularProgressIndicator();
    });
  }

  Widget _buildTimeline() {
    return Consumer(builder: (context, ref, _) {
      final thumbnailService =
          ref.watch(trimPageProvider.select((s) => s.thumbnailService));

      return thumbnailService != null
          ? SizedBox(
              height: thumbnailService.thumbnailHeight + 6,
              width: thumbnailService.timelineWidth + 6,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  _buildThumbnail(),
                  _buildSeekBar(),
                  // _buildTestSeekBar(),
                  _buildSubtitleTextsTimeline(),
                ],
              ),
            )
          : const CircularProgressIndicator();
    });
  }

  Widget _buildSubtitleTextsTimeline() {
    return Consumer(builder: (context, ref, _) {
      final Duration videoDuration = ref.watch(trimPageProvider
          .select((s) => s.videoPlayerService?.duration ?? Duration.zero));
      final double startTimeInMilliseconds =
          ref.watch(trimPageProvider.select((s) => s.startTimeInMilliseconds));
      final double endTimeInMilliseconds =
          ref.watch(trimPageProvider.select((s) => s.endTimeInMilliseconds));
      final timelineWidth =
          ref.watch(trimPageProvider.notifier.select((s) => s.timelineWidth));
      final thumbnailHeight =
          ref.watch(trimPageProvider.notifier.select((s) => s.thumbnailHeight));

      ref.watch(trimPageProvider.select((s) => s.thumbnailService));

      return SizedBox(
        height: thumbnailHeight + 6,
        width: timelineWidth + 6,
        child: GestureDetector(
          onHorizontalDragStart: (DragStartDetails details) {
            ref.read(trimPageProvider.notifier).dragStart(details);
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            ref.read(trimPageProvider.notifier).dragUpdate(details);
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            ref.read(trimPageProvider.notifier).dragEnd(details);
          },
          child: CustomPaint(
            foregroundPainter: EditSubtitleTextsPainter(
              startTimeInMilliseconds,
              endTimeInMilliseconds,
              videoDuration,
              timelineWidth,
              thumbnailHeight,
            ),
            child: Container(
              color: Colors.transparent,
              height: thumbnailHeight + 6,
              width: timelineWidth + 6,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildThumbnail() {
    return Consumer(builder: (context, ref, _) {
      final List<Uint8List?> thumbnailFileDataList =
          ref.watch(trimPageProvider.select((s) => s.thumbnailFileDataList));
      final thumbnailService =
          ref.watch(trimPageProvider.select((s) => s.thumbnailService));

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
}
