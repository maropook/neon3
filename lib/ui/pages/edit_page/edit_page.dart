import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/edit_page_controller.dart';
import 'package:neon3/gen/assets.gen.dart';
import 'package:neon3/ui/components/src/universal_image.dart';
import 'package:neon3/ui/pages/edit_page/artificial_voice_edit_sheet.dart';
import 'package:neon3/ui/pages/edit_page/change_avatar_sheet.dart';
import 'package:neon3/ui/pages/edit_page/edit_subtitle_texts_painter.dart';
import 'package:neon3/ui/pages/edit_page/music_edit_sheet.dart';
import 'package:neon3/ui/pages/edit_page/subtitle_edit_sheet.dart';
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
                if (avatar == null) return;
                final encodePageArgs = EncodePageArgs(
                    videoFilePath: editPageArgs.videoFilePath,
                    audioFilePath: editPageArgs.audioFilePath,
                    musicFilePath: musicFilePath,
                    ttsAudioFilePath: ttsAudioFilePath,
                    activeFrames: editPageArgs.activeFrames,
                    subtitleTexts: subtitleTexts,
                    avatar: avatar);

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
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              _buildVideoPlayer(),
              _buildAvatar(),
            ],
          ),
          // _buildThumbnail(),
          // _buildTimeline(),
          // _buildSubtitleTextsTimeline(),
          _buildEditContentIcons(),
        ]);
  }

  Widget _buildSubtitleTextsTimeline() {
    return Consumer(builder: (context, ref, _) {
      final List<SubtitleText> texts =
          ref.watch(editPageProvider.select((s) => s.subtitleTexts));
      final Duration videoPosition =
          ref.watch(editPageProvider.select((s) => s.videoPosition));
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

  Widget _buildVideoPlayer() {
    return Consumer(builder: (context, ref, _) {
      final videoController =
          ref.watch(editPageProvider.select((s) => s.videoPlayerService));
      final editPageController = ref.read(editPageProvider.notifier);
      final isPlaying = ref.watch(editPageProvider.select((s) => s.isPlaying));

      return RepaintBoundary(
        key: editVideoPlayerKey,
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

  Widget _buildEditContentIcons() {
    return Consumer(builder: (context, ref, _) {
      final videoController =
          ref.watch(editPageProvider.select((s) => s.videoPlayerService));
      final List<SubtitleText> texts =
          ref.watch(editPageProvider.select((s) => s.subtitleTexts));
      final avatar = ref.watch(editPageProvider.select((s) => s.avatar));

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () async {
              await ref.read(editPageProvider.notifier).pause();
              final newAvatar = await showChangeAvatarSheet(context);
              ref.read(editPageProvider.notifier).setSelectedAvatar(newAvatar);
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
              final subtitleEditPageArgs = SubtitleEditPageArgs(
                  audioFilePath: editPageArgs.audioFilePath,
                  videoFilePath: editPageArgs.videoFilePath,
                  activeFrames: editPageArgs.activeFrames,
                  avatar: avatar,
                  subtitleTexts: texts);
              await showSubtitleEditSheet(context, subtitleEditPageArgs);
            },
            child: _buildShowModalIcon(
                'テキストを編集', Assets.images.textEditIcon, context),
          ),
          GestureDetector(
            onTap: () async {
              await ref.read(editPageProvider.notifier).pause();
              final musicFilePath = await showMusicEditSheet(context) ?? '';
              ref.read(editPageProvider.notifier).setMusicFile(musicFilePath);
              //''のときはreturnされるので現状維持
            },
            child: _buildShowModalIcon(
                'BGMを追加', Assets.images.addBgmIcon, context),
          ),
          GestureDetector(
            onTap: () async {
              await ref.read(editPageProvider.notifier).pause();
              final subtitleTexts =
                  ref.read(editPageProvider.select((s) => s.subtitleTexts));
              final audioType =
                  ref.read(editPageProvider.select((s) => s.audioType));
              final ttsAudioFile = await showArtificialVoiceEditSheet(
                      context, subtitleTexts, audioType) ??
                  '';
              ref.read(editPageProvider.notifier).setTtsAudioFile(ttsAudioFile);
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
