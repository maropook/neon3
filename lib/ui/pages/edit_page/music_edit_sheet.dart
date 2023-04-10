import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/music_edit_sheet_controller.dart';

Future<String?> showMusicEditSheet(
  BuildContext context,
) {
  return showModalBottomSheet<String?>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return const _MusicEditSheet();
      });
}

class _MusicEditSheet extends StatelessWidget {
  const _MusicEditSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildModal(context);
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
      return Column(
        children: [
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final pickedFile = await ref
                  .read(musicEditSheetProvider.notifier)
                  .getPickedFilePath();

              Navigator.of(context).pop(pickedFile);
            },
            child: const Text(
              'BGMを追加',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 50),
          GestureDetector(
            onTap: () async {
              Navigator.of(context).pop('delete');
            },
            child: const Text(
              'BGMを削除',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    });
  }
}
