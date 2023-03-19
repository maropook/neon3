import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:maropook_neon2/ui/pages/encoding_page/src/advertisement.dart';
import 'package:maropook_neon2/ui/pages/encoding_page/src/progress_bar.dart';
import 'package:neon_video_encoder/neon_video_encoder.dart';

final StateProvider<double> progressRateProvider =
    StateProvider((StateProviderRef<double> ref) => 0.0);

class Progress extends ConsumerWidget {
  const Progress({Key? key}) : super(key: key);

  void resetProgress(WidgetRef ref) {
    ref.read(progressRateProvider.notifier).state = 0.0;
  }

  void updateProgress(
      NeonVideoEncoder neonVideoEncoder, String method, WidgetRef ref) {
    neonVideoEncoder.getProgressStatus.listen((dynamic value) {
      ref.read(progressRateProvider.notifier).state = value as double;

      Logger.log('encode', '$method  =>  ${ref.watch(progressRateProvider)} %');
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
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
              ))),
    );
  }
}
