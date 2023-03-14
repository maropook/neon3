import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/controllers/pages/edit_page_controller.dart';
import 'package:maropook_neon2/gen/assets.gen.dart';
import 'package:maropook_neon2/themes/styles.dart';
import 'package:video_player/video_player.dart';

class EditPage extends ConsumerWidget {
  const EditPage({required this.filePath, super.key});

  final String filePath;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        editPageProvider
            .overrideWith((ref) => EditController(videoFilePath: filePath))
      ],
      child: Scaffold(
          appBar: AppBar(
            title: const Text('エディット'),
            actions: [
              IconButton(
                  onPressed: () => context.go('/encoding'),
                  icon: const Icon(Icons.chevron_right)),
            ],
            leading: IconButton(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.chevron_left)),
          ),
          backgroundColor: Colors.white,
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Consumer(builder: (context, ref, _) {
      final editController =
          ref.watch(editPageProvider.select((s) => s.controller));
      final isPlaying = ref.watch(editPageProvider.select((s) => s.isPlaying));

      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            editController != null
                ? SizedBox(
                    height: 300,
                    child: GestureDetector(
                      onTap: () {
                        isPlaying
                            ? editController.pause()
                            : editController.play();
                      },
                      child: AspectRatio(
                        aspectRatio: editController.value.aspectRatio,
                        child: VideoPlayer(editController),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEditContentIcon(
                    'アバターを変更', Assets.images.changeAvatarIcon, context),
                _buildEditContentIcon(
                    'テキストを編集', Assets.images.textEditIcon, context),
                _buildEditContentIcon(
                    'BGMを追加', Assets.images.addBgmIcon, context),
                _buildEditContentIcon(
                    '人工音声', Assets.images.artificialVoiceIcon, context),
              ],
            )
          ]);
    });
  }

  Widget _buildEditContentIcon(
      String text, String iconPath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Styles.editModalBottomSheetBackGroundColor,
            isScrollControlled: true,
            context: context,
            isDismissible: true,
            builder: (BuildContext context) {
              return Container(
                  height: MediaQuery.of(context).size.longestSide - 64,
                  margin: const EdgeInsets.only(top: 64),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ));
            });
      },
      child: Column(
        children: [
          SvgPicture.asset(iconPath),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
