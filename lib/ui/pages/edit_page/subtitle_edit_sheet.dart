import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/subtitle_edit_sheet_controller.dart';
import 'package:neon3/ui/pages/page_router.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

Future<SubtitleText?> showSubtitleEditSheet(
  BuildContext context,
  SubtitleEditPageArgs subtitleEditPageArgs,
) {
  return showModalBottomSheet<SubtitleText?>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return _SubtitleEditSheet(
          subtitleEditPageArgs: subtitleEditPageArgs,
        );
      });
}

class _SubtitleEditSheet extends StatelessWidget {
  const _SubtitleEditSheet({required this.subtitleEditPageArgs, super.key});

  final SubtitleEditPageArgs subtitleEditPageArgs;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(overrides: [
      subtitleEditSheetProvider.overrideWith((ref) {
        final subtitleEditSheetProviderArg = SubtitleEditSheetProviderArg(
          subtitleText: subtitleEditPageArgs.subtitleText,
        );
        return SubtitleEditSheetController(
            subtitleEditSheetProviderArg: subtitleEditSheetProviderArg);
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
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildSubtitlesTextField()]);
  }

  // TODO: text_fieldをどうするか
  Widget _buildSubtitlesTextField() {
    return Consumer(builder: (context, ref, _) {
      final subtitleText =
          ref.watch(subtitleEditSheetProvider.select((s) => s.subtitleText));
      final subtitleTextEditController = ref
          .watch(subtitleEditSheetProvider.notifier)
          .subtitleTextEditController;
      final focusNode = ref.watch(subtitleEditSheetProvider.notifier).focusNode;

      return Column(
        children: [
          TextButton(
            child: const Text('完了',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
            onPressed: () {
              final FocusScopeNode currentScope = FocusScope.of(context);
              if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                focusNode.unfocus();
              }
              Navigator.of(context).pop(subtitleText);
            },
          ),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            obscureText: false,
            autofocus: true,
            focusNode: focusNode,
            onChanged: ref.read(subtitleEditSheetProvider.notifier).onChanged,
            controller: subtitleTextEditController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black.withOpacity(0),
              border: InputBorder.none,
            ),
          ),
        ],
      );
    });
  }
}
