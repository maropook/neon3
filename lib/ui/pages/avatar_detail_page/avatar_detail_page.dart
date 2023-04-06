import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/controllers/pages/avatar_detail_page_controller.dart';
import 'package:maropook_neon2/controllers/pages/avatar_list_page_controller.dart';
import 'package:maropook_neon2/models/src/avatar.dart';
import 'package:maropook_neon2/ui/components/src/universal_image.dart';

class AvatarDetailPage extends ConsumerWidget {
  AvatarDetailPage({super.key, required Avatar avatar}) : _avatar = avatar;

  final Avatar _avatar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
        overrides: [
          avatarDetailPageProvider.overrideWith(
              (ref) => AvatarDetailPageController(avatar: _avatar))
        ],
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text('アバター詳細'),
            leading: IconButton(
                onPressed: () async {
                  await ref
                      .read(avatarListPageProvider.notifier)
                      .fetchAvatars();
                  await ref
                      .read(avatarListPageProvider.notifier)
                      .fetchSelectedAvatar();
                  context.go('/avatar/list');
                },
                icon: const Icon(Icons.chevron_left)),
          ),
          body: _buildBody(),
        ));
  }

  Widget _buildBody() {
    return Consumer(builder: (context, ref, _) {
      final avatar =
          ref.watch(avatarDetailPageProvider.select((s) => s.avatar));
      final selectedAvatarId =
          ref.watch(avatarDetailPageProvider.select((s) => s.selectedAvatarId));
      return avatar != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    ref.read(avatarDetailPageProvider.notifier).selectAvatar();
                  },
                  child: Icon(
                    Icons.star,
                    color: avatar.id == selectedAvatarId
                        ? Colors.yellow
                        : Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: 150,
                        height: 150,
                        child: UniversalImage(avatar.stopImageUrl)),
                    SizedBox(
                        width: 150,
                        height: 150,
                        child: UniversalImage(avatar.activeImageUrl)),
                  ],
                ),
                if (!avatar.isDefault) _buildEditContents(context, ref)
              ],
            )
          : const CircularProgressIndicator();
    });
  }

  Widget _buildEditContents(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarDetailPageProvider.select((s) => s.avatar));

    return Column(
      children: [
        _buildShowModalButton(context, ref),
        IconButton(
            onPressed: () async {
              if (avatar == null) {
                return;
              }
              await goToAvatarListCallBack(ref, avatar.id);
              context.go('/avatar/list');
            },
            icon: const Icon(
              Icons.delete,
              size: 50,
              color: Colors.white,
            )),
      ],
    );
  }

  Widget _buildShowModalButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(avatarDetailPageProvider.notifier).clearNewImagePath();
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            isDismissible: true,
            builder: (BuildContext context) {
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
                  child: _buildEditAvatarModalBody(context, ref));
            });
      },
      child: const Icon(
        Icons.edit,
        size: 50,
        color: Colors.white,
      ),
    );
  }

  Widget _buildEditAvatarModalBody(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarDetailPageProvider.select((s) => s.avatar));

    final activeImagePath =
        ref.watch(avatarDetailPageProvider.select((s) => s.newActiveImagePath));
    final stopImagePath =
        ref.watch(avatarDetailPageProvider.select((s) => s.newStopImagePath));
    return avatar != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //TODO: setNewImageしてもFile(activeImagePath)が更新されない(https://github.com/maropook/maropook_neon2/issues/63)

                  GestureDetector(
                    child: activeImagePath.isNotEmpty
                        ? SizedBox(
                            width: 150,
                            child: Image.file(File(activeImagePath)))
                        : SizedBox(
                            width: 150,
                            child: UniversalImage(avatar!.activeImageUrl)),
                    onTap: () async {
                      await ref
                          .read(avatarDetailPageProvider.notifier)
                          .setNewImage(isActive: true);
                    },
                  ),
                  GestureDetector(
                    child: stopImagePath.isNotEmpty
                        ? SizedBox(
                            width: 150, child: Image.file(File(stopImagePath)))
                        : SizedBox(
                            width: 150,
                            child: UniversalImage(avatar!.stopImageUrl)),
                    onTap: () async {
                      await ref
                          .read(avatarDetailPageProvider.notifier)
                          .setNewImage(isActive: false);
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
                      await ref
                          .read(avatarDetailPageProvider.notifier)
                          .updateAvatar(previousAvatar: _avatar);
                      EasyLoading.dismiss();
                      Navigator.of(context).pop();
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
          )
        : const CircularProgressIndicator();
  }

  Future<void> goToAvatarListCallBack(WidgetRef ref, String avatarId) async {
    await ref
        .read(avatarDetailPageProvider.notifier)
        .deleteAvatar(id: avatarId);
    await ref.read(avatarListPageProvider.notifier).fetchAvatars();
    await ref.read(avatarListPageProvider.notifier).fetchSelectedAvatar();
  }
}
