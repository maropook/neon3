import 'dart:math';
import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/config/styles.dart';
import 'package:neon3/controllers/pages/subtitle_timing_edit_sheet_controller.dart';
import 'package:neon3/models/src/active_frame.dart';
import 'package:neon3/services/subtitle_font_service.dart';
import 'package:neon3/ui/components/src/universal_image.dart';
import 'package:neon3/ui/pages/edit_page/edit_subtitle_texts_painter.dart';
import 'package:neon3/ui/pages/page_router.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

final GlobalKey subtitleTimingEditVideoPlayerKey = GlobalKey();

class SubtitleTimingSheetArgs {
  SubtitleTimingSheetArgs(
      {required this.subtitleTexts, required this.activeFrames});

  List<SubtitleText> subtitleTexts;
  List<ActiveFrame> activeFrames;
}

Future<void> showSubtitleTimingEditSheet(
  BuildContext context,
  SubtitleTimingEditPageArgs subtitleTimingEditPageArgs,
) {
  return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return _SubtitleTimingEditSheet(
          subtitleTimingEditPageArgs: subtitleTimingEditPageArgs,
        );
      });
}

class _SubtitleTimingEditSheet extends StatelessWidget {
  const _SubtitleTimingEditSheet(
      {required this.subtitleTimingEditPageArgs, super.key});

  final SubtitleTimingEditPageArgs subtitleTimingEditPageArgs;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(overrides: [
      subtitleTimingEditSheetProvider.overrideWith((ref) {
        final subtitleTimingEditSheetProviderArg =
            SubtitleTimingEditSheetProviderArg(
          videoFilePath: subtitleTimingEditPageArgs.videoFilePath,
          audioFilePath: subtitleTimingEditPageArgs.audioFilePath,
          activeFrames: subtitleTimingEditPageArgs.activeFrames,
          subtitleTexts: subtitleTimingEditPageArgs.subtitleTexts,
          shortestSide: MediaQuery.of(context).size.shortestSide,
        );
        return SubtitleTimingEditSheetController(
            subtitleTimingEditSheetProviderArg:
                subtitleTimingEditSheetProviderArg);
      })
    ], child: _buildModal(context));
  }

  Widget _buildModal(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.longestSide - 64,
        margin: const EdgeInsets.only(top: 64),
        decoration: const BoxDecoration(
          color: Styles.secondaryColor,
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
          _buildPreview(),
          _buildSubtitleTextsTimeline(),
          Column(
            children: [
              _buildThumbnail(),
              _buildTimeline(),
            ],
          ),
          const SizedBox(),
        ]);
  }

  Widget _buildPreview() {
    return Consumer(builder: (context, ref, _) {
      final videoController = ref.watch(
          subtitleTimingEditSheetProvider.select((s) => s.videoPlayerService));
      final subtitleTimingEditSheetController =
          ref.read(subtitleTimingEditSheetProvider.notifier);
      final isPlaying =
          ref.watch(subtitleTimingEditSheetProvider.select((s) => s.isPlaying));

      return videoController != null
          ? Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    isPlaying
                        ? subtitleTimingEditSheetController.pause()
                        : subtitleTimingEditSheetController.play();
                  },
                  child: Stack(alignment: Alignment.bottomRight, children: [
                    RepaintBoundary(
                        key: subtitleTimingEditVideoPlayerKey,
                        child: SizedBox(
                          height: 250,
                          child: videoController.buildVideoPlayer(),
                        )),
                    _buildAvatar(),
                  ]),
                ),
                _buildSubtitleTexts(),
              ],
            )
          : const CircularProgressIndicator();
    });
  }

  Widget _buildAvatar() {
    return Consumer(builder: (context, ref, _) {
      final isAvatarActive = ref.watch(
          subtitleTimingEditSheetProvider.select((s) => s.isAvatarActive));
      final videoPlayerWidth = ref.watch(
          subtitleTimingEditSheetProvider.select((s) => s.videoPlayerWidth));

      return SizedBox(
        width: videoPlayerWidth / 2,
        child: UniversalImage(isAvatarActive
            ? subtitleTimingEditPageArgs.avatar.activeImageUrl
            : subtitleTimingEditPageArgs.avatar.stopImageUrl),
      );
    });
  }

  Widget _buildSubtitleTexts() {
    return Consumer(builder: (context, ref, _) {
      final List<int> displaySubtitleIndexList = ref.watch(
          subtitleTimingEditSheetProvider
              .select((s) => s.displaySubtitleIndexList));

      return Stack(
        children: [
          for (int i = 0; i < displaySubtitleIndexList.length; i++)
            _buildSubtitleTextPosition(displaySubtitleIndexList[i])
        ],
      );
    });
  }

  double getSubtitleWidth(SubtitleText text, double videoPlayerWidth) {
    final String word = text.word;
    final double fontSize = videoPlayerWidth * text.fontSize;
    if (!word.contains('\n')) {
      return fontSize * text.word.length;
    }
    final words = word.split('\n');
    final wordLengthList = <int>[];
    for (String word in words) {
      wordLengthList.add(word.length);
    }
    final wordLength = wordLengthList.reduce(max);
    return wordLength * fontSize;
  }

  Widget _buildSubtitleTextPosition(int index) {
    // final SubtitleFontService subtitleFontService = SubtitleFontService();
    return Consumer(builder: (context, ref, _) {
      final videoPlayerWidth = ref.watch(
          subtitleTimingEditSheetProvider.select((s) => s.videoPlayerWidth));
      final double aspectRatio = ref.watch(subtitleTimingEditSheetProvider
              .select((s) => s.videoPlayerService?.aspectRatio)) ??
          1.0;
      final List<SubtitleText> texts = ref.watch(
          subtitleTimingEditSheetProvider.select((s) => s.subtitleTexts));
      final SubtitleText text = texts[index];

      // final int fontSize = (videoPlayerWidth * text.fontSize).toInt();

      // final fontPadding = videoPlayerWidth *
      //     subtitleFontService.getFontHeight(text.fontName) *
      //     text.fontSize;

      final double subtitleWidth = getSubtitleWidth(text, videoPlayerWidth);

      // final bottomPadding = videoPlayerWidth * text.position.y + fontPadding;//TODO:こっちが正しいが、フォントによってpreviewがずれる
      final bottomPadding = videoPlayerWidth * text.position.y;
      final leftPadding = (videoPlayerWidth * text.position.x) +
          (videoPlayerWidth - subtitleWidth) / 2;

      return SizedBox(
          height: videoPlayerWidth / aspectRatio,
          width: videoPlayerWidth,
          child: Padding(
            padding: EdgeInsets.only(
                left: leftPadding >= 0 ? leftPadding : 0,
                bottom: bottomPadding >= 0 ? bottomPadding : 0),
            child: _buildSubtitleText(context, index),
          ));
    });
  }

  Widget _buildSubtitleText(BuildContext context, int index) {
    return Consumer(builder: (context, ref, _) {
      final double videoPlayerWidth = ref.watch(
          subtitleTimingEditSheetProvider.select((s) => s.videoPlayerWidth));
      final List<SubtitleText> texts = ref.watch(
          subtitleTimingEditSheetProvider.select((s) => s.subtitleTexts));
      final SubtitleText text = texts[index];

      final Color fontColor = HexColor.fromHex(text.fontColorCode);
      final Color fontBorderColor = HexColor.fromHex(text.borderColorCode);
      final int fontSize = (videoPlayerWidth * text.fontSize).toInt();

      return Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Text(
            textAlign: TextAlign.center,
            text.word,
            style: TextStyle(
                fontFamily:
                    text.fontName == 'systemFont' ? null : text.fontName,
                fontSize: fontSize.toDouble(),
                foreground: Paint()
                  ..color = text.word.isEmpty
                      ? fontBorderColor.withOpacity(0.5)
                      : fontColor),
          ),
          Text(
            //縁取り文字
            text.word.isEmpty ? '※空白のテキスト' : text.word,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily:
                    text.fontName == 'systemFont' ? null : text.fontName,
                fontSize: fontSize.toDouble(),
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = fontSize * 0.05
                  ..color = text.word.isEmpty
                      ? fontBorderColor.withOpacity(0.5)
                      : fontBorderColor),
          ),
        ],
      );
    });
  }

  Widget _buildSubtitleTextsTimeline() {
    return Consumer(builder: (context, ref, _) {
      final List<SubtitleText> texts = ref.watch(
          subtitleTimingEditSheetProvider.select((s) => s.subtitleTexts));
      final Duration videoDuration = ref.watch(subtitleTimingEditSheetProvider
          .select((s) => s.videoPlayerService?.duration ?? Duration.zero));
      final timelineWidth = ref.watch(subtitleTimingEditSheetProvider.notifier
          .select((s) => s.timelineWidth));
      final thumbnailHeight = ref.watch(subtitleTimingEditSheetProvider.notifier
          .select((s) => s.thumbnailHeight));

      ref.watch(
          subtitleTimingEditSheetProvider.select((s) => s.thumbnailService));

      return SizedBox(
        width: timelineWidth,
        height: thumbnailHeight * 4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (int index = 0; index < texts.length; ++index)
                GestureDetector(
                  onHorizontalDragStart: (DragStartDetails details) {
                    ref
                        .read(subtitleTimingEditSheetProvider.notifier)
                        .dragStart(details, index, texts[index].id);
                  },
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    ref
                        .read(subtitleTimingEditSheetProvider.notifier)
                        .dragUpdate(details, index, texts[index].id);
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
              // for (int i = 0; i < texts.length; i++)//Memo
              //   Text("${texts[i].startTime}:${texts[i].word}",
              //       style: const TextStyle(color: Styles.secondaryColor)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTimeline() {
    return Consumer(builder: (context, ref, _) {
      final Duration videoPosition = ref.watch(
          subtitleTimingEditSheetProvider.select((s) => s.videoPosition));
      final Duration videoDuration = ref.watch(subtitleTimingEditSheetProvider
          .select((s) => s.videoPlayerService?.duration ?? Duration.zero));
      final timelineWidth = ref.watch(subtitleTimingEditSheetProvider
              .select((s) => s.thumbnailService?.timelineWidth)) ??
          0;

      return SizedBox(
        width: timelineWidth,
        child: ProgressBar(
          progress: videoPosition,
          total: videoDuration,
          onSeek: (duration) {
            ref
                .read(subtitleTimingEditSheetProvider.notifier)
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
          subtitleTimingEditSheetProvider
              .select((s) => s.thumbnailFileDataList));
      final thumbnailService = ref.watch(
          subtitleTimingEditSheetProvider.select((s) => s.thumbnailService));

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
