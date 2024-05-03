import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/config/styles.dart';
import 'package:neon3/controllers/pages/avatar_add_sheet_controller.dart';
import 'package:neon3/gen/assets.gen.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/ui/components/src/universal_image.dart';

Future<Avatar?> showAvatarAddSheet(
  BuildContext context,
) {
  return showModalBottomSheet<Avatar>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return const _AvatarAddSheet();
      });
}

class _AvatarAddSheet extends StatelessWidget {
  const _AvatarAddSheet({Key? key}) : super(key: key);

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
      final activeImagePath =
          ref.watch(avatarAddSheetProvider.select((s) => s.newActiveImagePath));
      final stopImagePath =
          ref.watch(avatarAddSheetProvider.select((s) => s.newStopImagePath));
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
                    : _buildAddIcon(isActive: false),
                onTap: () async {
                  await ref
                      .read(avatarAddSheetProvider.notifier)
                      .setNewImage(isActive: false);
                },
              ),
              GestureDetector(
                child: activeImagePath.isNotEmpty
                    ? SizedBox(
                        width: 150, child: Image.file(File(activeImagePath)))
                    : _buildAddIcon(isActive: true),
                onTap: () async {
                  await ref
                      .read(avatarAddSheetProvider.notifier)
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
                      .read(avatarAddSheetProvider.notifier)
                      .addNewAvatar();
                  EasyLoading.dismiss();
                  Navigator.of(context).pop(newAvatar);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                ),
                child: const Text(
                  '追加',
                  style: TextStyle(
                      fontSize: 25,
                      color: Styles.secondaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAddIcon({required bool isActive}) {
    return Container(
      color: Colors.white,
      width: 170,
      height: 170,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                  width: 70,
                  height: 70,
                  child: UniversalImage(
                      isActive ? Assets.images.face : Assets.images.faceSmile)),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                  width: 70,
                  height: 70,
                  child: UniversalImage(Assets.images.photos)),
            ),
          ],
        ),
      ),
    );
  }
}
