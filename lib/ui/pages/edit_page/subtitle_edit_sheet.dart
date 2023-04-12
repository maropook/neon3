import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/subtitle_edit_sheet_controller.dart';
import 'package:neon3/ui/pages/page_router.dart';

final GlobalKey subtitleEditVideoPlayerKey = GlobalKey();

Future<void> showSubtitleEditSheet(
  BuildContext context,
  SubtitleEditPageArgs subtitleEditPageArgs,
) {
  return showModalBottomSheet<void>(
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
        children: []);
  }
}
