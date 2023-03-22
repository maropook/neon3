import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/controllers/pages/complete_page_controller.dart';
import 'package:video_player/video_player.dart';

class CompletePage extends StatelessWidget {
  const CompletePage({required this.filePath, super.key});

  final String filePath;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        completePageProvider.overrideWith(
            (ref) => CompletePageController(videoFilePath: filePath))
      ],
      child: Scaffold(
          appBar: AppBar(
            title: const Text('コンプリート'),
            actions: [
              IconButton(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.chevron_right)),
            ],
            leading: IconButton(
                onPressed: () => context.go('/encoding', extra: filePath),
                icon: const Icon(Icons.chevron_left)),
          ),
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Consumer(builder: (context, ref, _) {
      final videoController =
          ref.watch(completePageProvider.select((s) => s.videoPlayerService));
      final completePageController = ref.read(completePageProvider.notifier);
      final isPlaying =
          ref.watch(completePageProvider.select((s) => s.isPlaying));

      return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              videoController != null
                  ? SizedBox(
                      height: 300,
                      child: GestureDetector(
                        onTap: () {
                          isPlaying
                              ? completePageController.pause()
                              : completePageController.play();
                        },
                        child: videoController.buildVideoPlayer(),
                      ),
                    )
                  : const CircularProgressIndicator(),
            ]),
      );
    });
  }
}
