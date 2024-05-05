import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/config/styles.dart';
import 'package:neon3/controllers/pages/complete_page_controller.dart';

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
      child: HookConsumer(builder: (context, ref, _) {
        return Scaffold(
            appBar: AppBar(
              title: const Text(
                '完成',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Styles.appBarTitleColor),
              ),
              actions: [
                IconButton(
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.chevron_right)),
              ],
              // leading: IconButton(
              //     onPressed: () => context.go('/encoding', extra: filePath),
              //     icon: const Icon(Icons.chevron_left)),
            ),
            body: _buildBody());
      }),
    );
  }

  Widget _buildBody() {
    return Consumer(builder: (context, ref, _) {
      final videoPlayerService =
          ref.watch(completePageProvider.select((s) => s.videoPlayerService));
      final completePageController = ref.read(completePageProvider.notifier);
      final isPlaying =
          ref.watch(completePageProvider.select((s) => s.isPlaying));
      final shortestSide = MediaQuery.of(context).size.shortestSide;

      return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 4),
              InkWell(
                onTap: () async {
                  EasyLoading.show();
                  ref.read(completePageProvider.notifier).downloadVideo();
                  EasyLoading.showSuccess('動画の保存が\n完了しました');
                },
                child: _buildShowModalIcon(
                    '動画を保存', Icons.download_rounded, shortestSide),
              ),
              const SizedBox(height: 4),
              videoPlayerService != null
                  ? SizedBox(
                      // width: 187.5,
                      width: shortestSide,
                      child: GestureDetector(
                        onTap: () {
                          isPlaying
                              ? completePageController.pause()
                              : completePageController.play();
                        },
                        child: videoPlayerService.buildVideoPlayer(),
                      ),
                    )
                  : const CircularProgressIndicator(),
            ]),
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
}
