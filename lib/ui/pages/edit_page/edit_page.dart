import 'dart:typed_data';
import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/edit_page_controller.dart';
import 'package:neon3/gen/assets.gen.dart';
import 'package:neon3/services/subtitle_font_service.dart';
import 'package:neon3/ui/components/src/universal_image.dart';
import 'package:neon3/ui/pages/edit_page/artificial_voice_edit_sheet.dart';
import 'package:neon3/ui/pages/edit_page/change_avatar_sheet.dart';
import 'package:neon3/ui/pages/edit_page/edit_subtitle_texts_painter.dart';
import 'package:neon3/ui/pages/edit_page/music_edit_sheet.dart';
import 'package:neon3/ui/pages/edit_page/subtitle_edit_sheet.dart';
import 'package:neon3/ui/pages/edit_page/subtitle_timing_edit_sheet.dart';
import 'package:neon3/ui/pages/page_router.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

final GlobalKey editVideoPlayerKey = GlobalKey();

class EditPage extends StatelessWidget {
  const EditPage({required this.editPageArgs, super.key});

  final EditPageArgs editPageArgs;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        editPageProvider.overrideWith((ref) {
          final editPageProviderArg = EditPageProviderArg(
            videoFilePath: editPageArgs.videoFilePath,
            audioFilePath: editPageArgs.audioFilePath,
            recordingType: editPageArgs.recordingType,
            activeFrames: editPageArgs.activeFrames,
            shortestSide: MediaQuery.of(context).size.shortestSide,
            avatar: editPageArgs.avatar,
          );
          return EditPageController(editPageProviderArg: editPageProviderArg);
        })
      ],
      child: Scaffold(
          appBar: _buildAppBar(context),
          backgroundColor: Colors.white,
          body: _buildBody()),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('エディット'),
      actions: [
        Consumer(builder: (context, ref, _) {
          return IconButton(
              onPressed: () async {
                final List<SubtitleText> subtitleTexts =
                    ref.read(editPageProvider.select((s) => s.subtitleTexts));
                final avatar =
                    ref.read(editPageProvider.select((s) => s.avatar));
                final musicFilePath =
                    ref.read(editPageProvider.select((s) => s.musicFilePath));
                final ttsAudioFilePath = ref
                    .read(editPageProvider.select((s) => s.ttsAudioFilePath));
                final activeFrames =
                    ref.read(editPageProvider.select((s) => s.activeFrames));
                if (avatar == null) return;
                final encodePageArgs = EncodePageArgs(
                  videoFilePath: editPageArgs.videoFilePath,
                  audioFilePath: editPageArgs.audioFilePath,
                  musicFilePath: musicFilePath,
                  ttsAudioFilePath: ttsAudioFilePath,
                  activeFrames: activeFrames,
                  subtitleTexts: subtitleTexts,
                  avatar: avatar,
                  recordingType: editPageArgs.recordingType,
                );

                context.go('/encoding', extra: encodePageArgs);
              },
              icon: const Icon(Icons.chevron_right));
        }),
      ],
      leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.chevron_left)),
    );
  }

  Widget _buildBody() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildPreview(),
          _buildThumbnail(),
          _buildTimeline(),
          _subtitleAddButton(),
          _buildEditContentIcons(),
        ]);
  }

  Widget _subtitleAddButton() {
    return Consumer(builder: (context, ref, _) {
      return GestureDetector(
        onTap: () {
          ref.read(editPageProvider.notifier).addSubtitle();
        },
        child: Container(
            color: Colors.grey.withOpacity(0.5),
            width: 30,
            height: 30,
            child: const Icon(Icons.add)),
      );
    });
  }

  Widget _buildPreview() {
    return Consumer(builder: (context, ref, _) {
      final videoController =
          ref.watch(editPageProvider.select((s) => s.videoPlayerService));
      final editPageController = ref.read(editPageProvider.notifier);
      final isPlaying = ref.watch(editPageProvider.select((s) => s.isPlaying));

      return videoController != null
          ? Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    isPlaying
                        ? editPageController.pause()
                        : editPageController.play();
                  },
                  child: Stack(alignment: Alignment.bottomRight, children: [
                    RepaintBoundary(
                        key: editVideoPlayerKey,
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
      final isAvatarActive =
          ref.watch(editPageProvider.select((s) => s.isAvatarActive));
      final videoPlayerWidth =
          ref.watch(editPageProvider.select((s) => s.videoPlayerWidth));
      final avatar = ref.watch(editPageProvider.select((s) => s.avatar));

      return avatar != null
          ? SizedBox(
              width: videoPlayerWidth / 2,
              child: UniversalImage(
                  isAvatarActive ? avatar.activeImageUrl : avatar.stopImageUrl),
            )
          : const CircularProgressIndicator();
    });
  }

  Widget _buildSubtitleTexts() {
    return Consumer(builder: (context, ref, _) {
      final List<int> displaySubtitleIndexList =
          ref.watch(editPageProvider.select((s) => s.displaySubtitleIndexList));

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
    final SubtitleFontService subtitleFontService = SubtitleFontService();
    return Consumer(builder: (context, ref, _) {
      final videoPlayerWidth =
          ref.watch(editPageProvider.select((s) => s.videoPlayerWidth));
      final double aspectRatio = ref.watch(editPageProvider
              .select((s) => s.videoPlayerService?.aspectRatio)) ??
          1.0;
      final List<SubtitleText> texts =
          ref.watch(editPageProvider.select((s) => s.subtitleTexts));
      final SubtitleText text = texts[index];

      final int fontSize = (videoPlayerWidth * text.fontSize).toInt();
      final double subtitleWidth = getSubtitleWidth(text, videoPlayerWidth);

      final fontPadding = videoPlayerWidth *
          subtitleFontService.getFontHeight(text.fontName) *
          text.fontSize;

      // final bottomPadding = videoPlayerWidth * text.position.y + fontPadding;//TODO:こっちが正しいが、フォントによってpreviewがずれる
      final bottomPadding = videoPlayerWidth * text.position.y;
      final leftPadding = (videoPlayerWidth * text.position.x) +
          (videoPlayerWidth - subtitleWidth) / 2;

      return SizedBox(
          height: videoPlayerWidth / aspectRatio,
          width: videoPlayerWidth,
          child: Padding(
            padding: EdgeInsets.only(left: leftPadding, bottom: bottomPadding),
            child: _buildSubtitleText(context, index),
          ));
    });
  }

  Widget _buildSubtitleText(BuildContext context, int index) {
    return Consumer(builder: (context, ref, _) {
      final double videoPlayerWidth =
          ref.watch(editPageProvider.select((s) => s.videoPlayerWidth));
      final List<SubtitleText> texts =
          ref.watch(editPageProvider.select((s) => s.subtitleTexts));
      final SubtitleText text = texts[index];

      final Color fontColor = HexColor.fromHex(text.fontColorCode);
      final Color fontBorderColor = HexColor.fromHex(text.borderColorCode);
      final int fontSize = (videoPlayerWidth * text.fontSize).toInt();

      return GestureDetector(
          onTap: () async {
            await ref.read(editPageProvider.notifier).showModalCallback();
            final args = await showSubtitleEditSheet(
                context, SubtitleEditPageArgs(subtitleText: text));
            if (args?.isDelete == true) {
              ref.read(editPageProvider.notifier).deleteSubtitle(text.id);
            }
            //TODO: ref.read(editPageProvider.notifier).updateSubtitle(subtitleText);//select.sの参照を渡してるから勝手にupdateされる
            await ref.read(editPageProvider.notifier).closeModalCallback();
          },
          child: Stack(
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
                text.word.isEmpty ? '※空白のテキスト' : text.word,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily:
                      text.fontName == 'systemFont' ? null : text.fontName,
                  fontSize: fontSize.toDouble(),
                  foreground: Paint()
                    ..strokeWidth = fontSize * 0.05
                    ..color = text.word.isEmpty
                        ? fontBorderColor.withOpacity(0.5)
                        : fontBorderColor
                    ..style = PaintingStyle.stroke,
                ),
              ),
            ],
          ));
    });
  }

  Widget _buildSubtitleTextsTimeline() {
    return Consumer(builder: (context, ref, _) {
      final List<SubtitleText> texts =
          ref.watch(editPageProvider.select((s) => s.subtitleTexts));
      final Duration videoDuration = ref.watch(editPageProvider
          .select((s) => s.videoPlayerService?.duration ?? Duration.zero));
      final timelineWidth =
          ref.watch(editPageProvider.notifier.select((s) => s.timelineWidth));
      final thumbnailHeight =
          ref.watch(editPageProvider.notifier.select((s) => s.thumbnailHeight));

      ref.watch(editPageProvider.select((s) => s.thumbnailService));

      return Container(
        color: Colors.grey[150],
        width: timelineWidth,
        child: Column(
          children: [
            for (SubtitleText text in texts)
              CustomPaint(
                foregroundPainter: EditSubtitleTextsPainter(
                  text,
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
          ref.watch(editPageProvider.select((s) => s.videoPosition));
      final Duration videoDuration = ref.watch(editPageProvider
          .select((s) => s.videoPlayerService?.duration ?? Duration.zero));
      final timelineWidth = ref.watch(editPageProvider
              .select((s) => s.thumbnailService?.timelineWidth)) ??
          0;

      return SizedBox(
        width: timelineWidth,
        child: ProgressBar(
          progress: videoPosition,
          total: videoDuration,
          onSeek: (duration) {
            ref.read(editPageProvider.notifier).seek(duration: duration);
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
      final List<Uint8List?> thumbnailFileDataList =
          ref.watch(editPageProvider.select((s) => s.thumbnailFileDataList));
      final thumbnailService =
          ref.watch(editPageProvider.select((s) => s.thumbnailService));

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

  Widget _buildEditContentIcons() {
    return Consumer(builder: (context, ref, _) {
      final videoController =
          ref.watch(editPageProvider.select((s) => s.videoPlayerService));
      final List<SubtitleText> texts =
          ref.watch(editPageProvider.select((s) => s.subtitleTexts));
      final avatar = ref.watch(editPageProvider.select((s) => s.avatar));
      final activeFrames =
          ref.watch(editPageProvider.select((s) => s.activeFrames));

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () async {
              await ref.read(editPageProvider.notifier).pause();
              final newAvatar = await showChangeAvatarSheet(context);
              ref.read(editPageProvider.notifier).setSelectedAvatar(newAvatar);
              await ref.read(editPageProvider.notifier).closeModalCallback();
            },
            child: _buildShowModalIcon(
              'アバターを変更',
              Assets.images.changeAvatarIcon,
              context,
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (videoController == null || avatar == null) return;
              await ref.read(editPageProvider.notifier).pause();
              final subtitleTimingEditPageArgs = SubtitleTimingEditPageArgs(
                  audioFilePath: editPageArgs.audioFilePath,
                  videoFilePath: editPageArgs.videoFilePath,
                  activeFrames: activeFrames,
                  avatar: avatar,
                  subtitleTexts: texts);
              await showSubtitleTimingEditSheet(
                  context, subtitleTimingEditPageArgs);
              await ref.read(editPageProvider.notifier).closeModalCallback();
            },
            child: _buildShowModalIcon(
                'テキストを編集', Assets.images.textEditIcon, context),
          ),
          GestureDetector(
            onTap: () async {
              await ref.read(editPageProvider.notifier).showModalCallback();
              final musicFilePath = await showMusicEditSheet(context) ?? '';
              await ref
                  .read(editPageProvider.notifier)
                  .setMusicFile(musicFilePath);
              await ref.read(editPageProvider.notifier).closeModalCallback();
              //''のときはreturnされるので現状維持
            },
            child: _buildShowModalIcon(
                'BGMを追加', Assets.images.addBgmIcon, context),
          ),
          GestureDetector(
            onTap: () async {
              await ref.read(editPageProvider.notifier).showModalCallback();
              final subtitleTexts =
                  ref.read(editPageProvider.select((s) => s.subtitleTexts));
              final audioType =
                  ref.read(editPageProvider.select((s) => s.audioType));
              final ttsAudioFile = await showArtificialVoiceEditSheet(
                      context, subtitleTexts, audioType) ??
                  '';
              await ref
                  .read(editPageProvider.notifier)
                  .setTtsAudioFile(ttsAudioFile);
              await ref.read(editPageProvider.notifier).closeModalCallback();
            },
            child: _buildShowModalIcon(
                '人工音声', Assets.images.artificialVoiceIcon, context),
          ),
        ],
      );
    });
  }

  Widget _buildShowModalIcon(
      String text, String iconPath, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.shortestSide / 4,
      child: Column(
        children: [
          SvgPicture.asset(iconPath),
          Text(text, style: const TextStyle(color: Colors.black, fontSize: 10))
        ],
      ),
    );
  }
}
