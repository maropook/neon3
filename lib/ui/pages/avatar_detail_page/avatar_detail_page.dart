import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/avatar_detail_page_controller.dart';
import 'package:neon3/controllers/pages/avatar_list_page_controller.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/ui/components/src/universal_image.dart';
import 'package:neon3/ui/pages/avatar_detail_page/avatar_edit_sheet.dart';

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
        _buildShowModalButton(context, avatar, ref),
        IconButton(
            onPressed: () async {
              if (avatar == null) {
                return;
              }
              await deleteAndGoToAvatarListCallBack(ref, avatar.id);
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

  Widget _buildShowModalButton(
      BuildContext context, Avatar? avatar, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        if (avatar == null) {
          return;
        }
        final newAvatar = await showAvatarEditSheet(
          context,
          avatar: avatar,
        );
        if (newAvatar == null) return;
        ref
            .read(avatarDetailPageProvider.notifier)
            .update(newAvatar: newAvatar);
      },
      child: const Icon(
        Icons.edit,
        size: 50,
        color: Colors.white,
      ),
    );
  }

  Future<void> deleteAndGoToAvatarListCallBack(
      WidgetRef ref, String avatarId) async {
    await ref
        .read(avatarDetailPageProvider.notifier)
        .deleteAvatar(id: avatarId);
    await ref.read(avatarListPageProvider.notifier).fetchAvatars();
    await ref.read(avatarListPageProvider.notifier).fetchSelectedAvatar();
  }
}
