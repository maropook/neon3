import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/config/styles.dart';
import 'package:neon3/controllers/pages/change_avatar_sheet_controller.dart';
import 'package:neon3/gen/assets.gen.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/ui/components/src/universal_image.dart';

Future<Avatar?> showChangeAvatarSheet(
  BuildContext context,
) {
  return showModalBottomSheet<Avatar?>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return const _ChangeAvatarSheet();
      });
}

class _ChangeAvatarSheet extends StatelessWidget {
  const _ChangeAvatarSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildModal(context);
  }

  Widget _buildModal(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.longestSide - 400,
        margin: const EdgeInsets.only(top: 400),
        decoration: const BoxDecoration(
          color: Styles.secondaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: _buildBody());
  }

  Widget _buildBody() {
    return Consumer(builder: (context, ref, _) {
      final avatarList =
          ref.watch(changeAvatarSheetProvider.select((s) => s.avatarList));
      final selectedAvatar = ref.watch(
              changeAvatarSheetProvider.select((s) => s.selectedAvatar)) ??
          defaultAvatar;

      return GridView.builder(
        padding: const EdgeInsets.all(10), //4辺すべて同じ値の余白
        itemCount: avatarList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: GestureDetector(
                  onTap: () async {
                    final newSelectAvatar = await ref
                        .read(changeAvatarSheetProvider.notifier)
                        .selectAvatar(avatarList[index]);
                    Navigator.of(context).pop(newSelectAvatar);
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    fit: StackFit.loose,
                    children: [
                      avatarList[index].stopImageUrl.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: UniversalImage(
                                  avatarList[index].stopImageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : UniversalImage(
                              Assets.images.faceSmile,
                              fit: BoxFit.cover,
                            ),
                      if (avatarList[index].id == selectedAvatar.id)
                        const Icon(
                          Icons.check_circle,
                          color: Styles.pastelGreenColor,
                        ),
                    ],
                  )));
        },
      );
    });
  }
}
