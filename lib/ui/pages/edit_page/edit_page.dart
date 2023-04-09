import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/edit_page_controller.dart';
import 'package:neon3/gen/assets.gen.dart';
import 'package:neon3/ui/components/src/universal_image.dart';
import 'package:neon3/ui/pages/edit_page/change_avatar_sheet.dart';
import 'package:neon3/ui/pages/edit_page/music_edit_sheet.dart';
import 'package:neon3/ui/pages/edit_page/subtitle_edit_sheet.dart';
import 'package:neon3/ui/pages/page_router.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

final GlobalKey editVideoPlayerKey = GlobalKey();

class EditPage extends HookConsumerWidget {
  const EditPage({required this.editPageArgs, super.key});

  final EditPageArgs editPageArgs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        editPageProvider.overrideWith((ref) => EditPageController(
              videoFilePath: editPageArgs.videoFilePath,
              audioFilePath: editPageArgs.audioFilePath,
              activeFrames: editPageArgs.activeFrames,
              shortestSide: MediaQuery.of(context).size.shortestSide,
            ))
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
                    ref.watch(editPageProvider.select((s) => s.subtitleTexts));

                final encodePageArgs = EncodePageArgs(
                    videoFilePath: editPageArgs.videoFilePath,
                    audioFilePath: editPageArgs.audioFilePath,
                    activeFrames: editPageArgs.activeFrames,
                    subtitleTexts: subtitleTexts,
                    avatar: editPageArgs.avatar);

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
    return Consumer(builder: (context, ref, _) {
      final List<SubtitleText> texts =
          ref.watch(editPageProvider.select((s) => s.subtitleTexts));

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
            for (int i = 0; i < texts.length; i++)
              Text("${texts[i].startTime}:${texts[i].word}",
                  style: const TextStyle(color: Colors.black)),
            _buildEditContentIcons(),
          ]);
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

      return SizedBox(
        width: videoPlayerWidth / 2,
        child: UniversalImage(isAvatarActive
            ? editPageArgs.avatar.activeImageUrl
            : editPageArgs.avatar.stopImageUrl),
      );
    });
  }

  Widget _buildEditContentIcons() {
    return Consumer(builder: (context, ref, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEditContentIcon('アバターを変更', Assets.images.changeAvatarIcon,
              context, showChangeAvatarSheet),
          _buildEditContentIcon('テキストを編集', Assets.images.textEditIcon, context,
              showSubtitleEditSheet),
          _buildEditContentIcon(
              'BGMを追加', Assets.images.addBgmIcon, context, showMusicEditSheet),
          _buildEditContentIcon('人工音声', Assets.images.artificialVoiceIcon,
              context, showSubtitleEditSheet),
        ],
      );
    });
  }

  Widget _buildEditContentIcon(
      String text,
      String iconPath,
      BuildContext context,
      Future<void> Function(BuildContext) showModalBottomSheet) {
    return GestureDetector(
      onTap: () async {
        await showModalBottomSheet(context);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.shortestSide / 4,
        child: Column(
          children: [
            SvgPicture.asset(iconPath),
            Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
