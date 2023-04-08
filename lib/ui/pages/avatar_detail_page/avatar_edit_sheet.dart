import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/avatar_edit_sheet_controller.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/ui/components/src/universal_image.dart';

Future<Avatar?> showAvatarEditSheet(BuildContext context,
    {required Avatar avatar}) {
  return showModalBottomSheet<Avatar>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return _AvatarEditSheet(avatar);
      });
}

class _AvatarEditSheet extends StatelessWidget {
  const _AvatarEditSheet(this.avatar, {Key? key}) : super(key: key);
  final Avatar avatar;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        avatarEditSheetProvider
            .overrideWith((ref) => AvatarEditSheetController(avatar: avatar))
      ],
      child: _buildModal(context),
    );
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
      final activeImagePath = ref
          .watch(avatarEditSheetProvider.select((s) => s.newActiveImagePath));
      final stopImagePath =
          ref.watch(avatarEditSheetProvider.select((s) => s.newStopImagePath));
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                child: stopImagePath.isNotEmpty
                    ? SizedBox(
                        width: 150, child: Image.file(File(stopImagePath)))
                    : SizedBox(
                        width: 150, child: UniversalImage(avatar.stopImageUrl)),
                onTap: () async {
                  await ref
                      .read(avatarEditSheetProvider.notifier)
                      .setNewImage(isActive: false);
                },
              ),
              GestureDetector(
                child: activeImagePath.isNotEmpty
                    ? SizedBox(
                        width: 150, child: Image.file(File(activeImagePath)))
                    : SizedBox(
                        width: 150,
                        child: UniversalImage(avatar.activeImageUrl)),
                onTap: () async {
                  await ref
                      .read(avatarEditSheetProvider.notifier)
                      .setNewImage(isActive: true);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              height: 100,
              child: ElevatedButton(
                onPressed: () async {
                  EasyLoading.show();
                  final newAvatar = await ref
                      .read(avatarEditSheetProvider.notifier)
                      .updateAvatar(previousAvatar: avatar);
                  EasyLoading.dismiss();
                  Navigator.of(context).pop(newAvatar);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                ),
                child: const Text(
                  '完了',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
