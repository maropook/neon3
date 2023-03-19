import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/ui/pages/encoding_page/src/advertisement.dart';
import 'package:maropook_neon2/ui/pages/encoding_page/src/encode_page_controller.dart';
import 'package:maropook_neon2/ui/pages/encoding_page/src/progress.dart';
import 'package:maropook_neon2/ui/pages/encoding_page/src/progress_bar.dart';
import 'package:video_player/video_player.dart';

class EncodePage extends ConsumerWidget {
  const EncodePage({required this.filePath, super.key});

  final String filePath;
  final Progress progress = const Progress();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        encodePageProvider
            .overrideWith((ref) => EncodeController(videoFilePath: filePath))
      ],
      child: Scaffold(
          appBar: AppBar(
            title: const Text('エンコーディング'),
            actions: [
              IconButton(
                  onPressed: () => context.go('/complete', extra: filePath),
                  icon: const Icon(Icons.chevron_right)),
            ],
            leading: IconButton(
                onPressed: () => context.go('/edit', extra: filePath),
                icon: const Icon(Icons.chevron_left)),
          ),
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Consumer(builder: (context, ref, _) {
      final double progressRate =
          ref.watch(encodePageProvider.select((s) => s.progressRate));

      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () async {
                  final videoFilePath =
                      await ref.read(encodePageProvider.notifier).encode();
                  context.go('/complete', extra: videoFilePath);
                },
                icon: const Icon(Icons.chevron_left)),
            false != null
                ? Center(
                    child: Container(
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Advertisement(
                              MediaQuery.of(context).size.shortestSide,
                            ),
                            ProgressBar(ref.watch(progressRateProvider)),
                          ],
                        )))
                : const CircularProgressIndicator(),
          ]);
    });
  }
}
