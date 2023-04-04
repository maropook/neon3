import 'package:flutter/material.dart';
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
                  child: UniversalImage(_avatar.activeImageUrl)),
              SizedBox(
                  width: 150,
                  height: 150,
                  child: UniversalImage(_avatar.stopImageUrl)),
            ],
          ),
          IconButton(
              onPressed: () async {
                await ref
                    .read(avatarListPageProvider.notifier)
                    .deleteAvatar(id: _avatar.id);
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
}
