import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/avatar_list_page_controller.dart';
import 'package:neon3/gen/assets.gen.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/ui/components/src/universal_image.dart';
import 'package:neon3/ui/pages/avatar_list_page/avatar_add_sheet.dart';

class AvatarListPage extends ConsumerWidget {
  const AvatarListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarList =
        ref.watch(avatarListPageProvider.select((s) => s.avatarList));
    final Avatar selectedAvatar =
        ref.watch(avatarListPageProvider.select((s) => s.selectedAvatar)) ??
            defaultAvatar;

    return Scaffold(
      appBar: AppBar(
        title: const Text('アバター一覧'),
        leading: IconButton(
            onPressed: () {
              context.go('/');
            },
            icon: const Icon(Icons.chevron_left)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10), //4辺すべて同じ値の余白
        itemCount: avatarList.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return Container(
            color: Colors.white,
            child: avatarList.length != index
                ? GestureDetector(
                    onTap: () async {
                      context.go('/avatar/list/detail',
                          extra: avatarList[index]);
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      fit: StackFit.loose,
                      children: [
                        avatarList[index].stopImageUrl.isNotEmpty
                            ? AspectRatio(
                                aspectRatio: 1,
                                child: UniversalImage(
                                  avatarList[index].stopImageUrl,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : UniversalImage(
                                Assets.images.faceSmile,
                                fit: BoxFit.cover,
                              ),
                        if (avatarList[index].id == selectedAvatar.id)
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 30,
                          ),
                      ],
                    ))
                : _buildShowModalButton(context, ref),
          );
        },
      ),
    );
  }

  Widget _buildShowModalButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final newAvatar = await showAvatarAddSheet(
          context,
        );
        if (newAvatar == null) return;
        ref
            .read(avatarListPageProvider.notifier)
            .addNewAvatar(newAvatar: newAvatar);
      },
      child: const Center(child: Icon(Icons.add, size: 80)),
    );
  }
}
