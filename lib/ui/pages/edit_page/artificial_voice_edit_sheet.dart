import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/artificial_voice_edit_sheet_controller.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

Future<String?> showArtificialVoiceEditSheet(
  BuildContext context,
  List<SubtitleText> subtitleTexts,
  AudioType audioType,
) {
  return showModalBottomSheet<String?>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return _ArtificialVoiceEditSheet(
            subtitleTexts: subtitleTexts, audioType: audioType);
      });
}

class _ArtificialVoiceEditSheet extends StatelessWidget {
  const _ArtificialVoiceEditSheet(
      {required List<SubtitleText> subtitleTexts,
      required AudioType audioType,
      super.key})
      : _subtitleTexts = subtitleTexts,
        _audioType = audioType;

  final List<SubtitleText> _subtitleTexts;
  final AudioType _audioType;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(overrides: [
      artificialVoiceEditSheetProvider.overrideWith((ref) {
        final artificialVoiceEditSheetProviderArg =
            ArtificialVoiceEditSheetProviderArg(
          subtitleTexts: _subtitleTexts,
          audioType: _audioType,
        );
        return ArtificialVoiceEditSheetController(
            artificialVoiceEditSheetProviderArg:
                artificialVoiceEditSheetProviderArg);
      })
    ], child: _buildModal(context));
  }

  Widget _buildModal(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.longestSide - 64,
        margin: const EdgeInsets.only(top: 64),
        decoration: const BoxDecoration(
          color: Color.fromARGB(109, 0, 0, 0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: _buildBody());
  }

  Widget _buildBody() {
    return Consumer(builder: (context, ref, _) {
      final audioType = ref
          .watch(artificialVoiceEditSheetProvider.select((s) => s.audioType));
      return Column(
        children: [
          Text(
            '人工音声(${audioType == AudioType.original ? 'オリジナル' : '人工音声'})',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 40),
          GestureDetector(
              onTap: () async {
                final ttsAudioFilePath = await ref
                    .read(artificialVoiceEditSheetProvider.notifier)
                    .switchAudioType(AudioType.original);
                Navigator.of(context).pop(ttsAudioFilePath);
              },
              child: const Text(
                'オリジナル',
                style: TextStyle(color: Colors.white),
              )),
          const SizedBox(height: 40),
          GestureDetector(
              onTap: () async {
                final ttsAudioFilePath = await ref
                    .read(artificialVoiceEditSheetProvider.notifier)
                    .switchAudioType(AudioType.artificial);
                Navigator.of(context).pop(ttsAudioFilePath);
              },
              child: const Text(
                '人工音声',
                style: TextStyle(color: Colors.white),
              )),
        ],
      );
    });
  }
}
