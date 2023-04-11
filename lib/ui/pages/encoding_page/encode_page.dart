import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/encode_page_controller.dart';
import 'package:neon3/ui/pages/page_router.dart';

class EncodePage extends ConsumerWidget {
  const EncodePage({required this.encodePageArgs, super.key});

  final EncodePageArgs encodePageArgs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        encodePageProvider.overrideWith((ref) {
          final encodePageProviderArgs = EncodePageProviderArg(
            videoFilePath: encodePageArgs.videoFilePath,
            audioFilePath: encodePageArgs.audioFilePath,
            avatar: encodePageArgs.avatar,
            subtitleTexts: encodePageArgs.subtitleTexts,
            activeFrames: encodePageArgs.activeFrames,
            musicFilePath: encodePageArgs.musicFilePath,
            ttsAudioFilePath: encodePageArgs.ttsAudioFilePath,
          );
          return EncodePageController(
              encodePageProviderArg: encodePageProviderArgs);
        })
      ],
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text('エンコーディング'),
            actions: [
              IconButton(
                  onPressed: () => context.go(
                        '/complete',
                        extra: encodePageArgs.videoFilePath,
                      ),
                  icon: const Icon(Icons.chevron_right)),
            ],
            leading: IconButton(
                onPressed: () => context.go(
                      '/edit',
                      extra: EditPageArgs(
                        audioFilePath: encodePageArgs.audioFilePath,
                        videoFilePath: encodePageArgs.videoFilePath,
                        activeFrames: encodePageArgs.activeFrames,
                        avatar: encodePageArgs.avatar,
                      ),
                    ),
                icon: const Icon(Icons.chevron_left)),
          ),
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Consumer(builder: (context, ref, _) {
      final double progressRate =
          ref.watch(encodePageProvider.select((s) => s.progressRate));

      ref.listen<String>(
          encodePageProvider.select((s) => s.encodedVideoFilePath),
          (_, encodedVideoFilePath) {
        if (encodedVideoFilePath != '') {
          context.go('/complete', extra: encodedVideoFilePath);
        }
      });

      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 310,
                ),
                const Text(
                  'エンコーディング中',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                _buildProgressBar(progressRate),
              ],
            )),
          ]);
    });
  }

  Widget _buildProgressBar(double progressRate) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: FAProgressBar(
        currentValue: progressRate,
        size: 36,
        borderRadius:
            BorderRadiusGeometry.lerp(BorderRadius.zero, BorderRadius.zero, 0),
        border: Border.all(color: Colors.white, width: 3),
        backgroundColor: Colors.white,
        progressColor: Colors.black,
      ),
    );
  }
}
