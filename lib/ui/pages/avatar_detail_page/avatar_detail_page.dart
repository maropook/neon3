import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/controllers/pages/avatar_list_page_controller.dart';
import 'package:maropook_neon2/models/src/avatar.dart';
import 'package:maropook_neon2/ui/components/src/universal_image.dart';

class AvatarDetailPage extends ConsumerWidget {
  AvatarDetailPage({super.key, required Avatar avatar}) : _avatar = avatar;

  final Avatar _avatar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarListPageProvider.select((s) => s.avatarList
        .where((element) => element.id == _avatar.id)
        .toList()
        .first));
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('アバター詳細'),
        leading: IconButton(
            onPressed: () => context.go('/avatar/list'),
            icon: const Icon(Icons.chevron_left)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  width: 150,
                  height: 150,
                  child: UniversalImage(avatar.activeImageUrl)),
              SizedBox(
                  width: 150,
                  height: 150,
                  child: UniversalImage(avatar.stopImageUrl)),
            ],
          ),
          _buildShowModalButton(context, ref),
          IconButton(
              onPressed: () async {
                await ref
                    .read(avatarListPageProvider.notifier)
                    .deleteAvatar(id: avatar.id);
                context.go('/avatar/list');
              },
              icon: const Icon(
                Icons.delete,
                size: 50,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  Widget _buildShowModalButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(avatarListPageProvider.notifier).clearNewImagePath();
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
                  child: _buildAddAvatarModalBody());
            });
      },
      child: const Icon(
        Icons.edit,
        size: 50,
        color: Colors.white,
      ),
    );
  }

  Widget _buildAddAvatarModalBody() {
    return Consumer(builder: (context, ref, _) {
      final avatar = ref.watch(avatarListPageProvider.select((s) => s.avatarList
          .where((element) => element.id == _avatar.id)
          .toList()
          .first));
      final activeImagePath =
          ref.watch(avatarListPageProvider.select((s) => s.newActiveImagePath));
      final stopImagePath =
          ref.watch(avatarListPageProvider.select((s) => s.newStopImagePath));
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                child: activeImagePath.isNotEmpty
                    ? SizedBox(
                        width: 150, child: Image.file(File(activeImagePath)))
                    : SizedBox(
                        width: 150,
                        child: UniversalImage(avatar.activeImageUrl)),
                onTap: () async {
                  await ref
                      .read(avatarListPageProvider.notifier)
                      .setNewImage(isActive: true);
                },
              ),
              GestureDetector(
                child: stopImagePath.isNotEmpty
                    ? SizedBox(
                        width: 150, child: Image.file(File(stopImagePath)))
                    : SizedBox(
                        width: 150, child: UniversalImage(avatar.stopImageUrl)),
                onTap: () async {
                  await ref
                      .read(avatarListPageProvider.notifier)
                      .setNewImage(isActive: false);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100, //横幅
              height: 100, //高さ
              child: ElevatedButton(
                onPressed: () async {
                  EasyLoading.show();
                  await ref
                      .read(avatarListPageProvider.notifier)
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
      );
    });
  }
}
