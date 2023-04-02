import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/controllers/pages/avatar_list_page_controller.dart';

class AvatarListPage extends ConsumerWidget {
  const AvatarListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FirestoreService firestoreService = FirestoreService();
    final image = ref.watch(avatarListPageProvider.select((s) => s.image));
    return Scaffold(
      appBar: AppBar(
        title: const Text('アバター一覧'),
        actions: [
          IconButton(
              onPressed: () => context.go('/avatar/list/detail'),
              icon: const Icon(Icons.chevron_right)),
        ],
        leading: IconButton(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.chevron_left)),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              ref.read(avatarListPageProvider.notifier).uploadPic();
            },
            child: const Icon(Icons.upload),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(avatarListPageProvider.notifier).downloadPic();
            },
            child: const Icon(Icons.download),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: image == null ? const Text('No Image') : Image.memory(image),
          ),
          TextButton(
            onPressed: () {
              ref.read(avatarListPageProvider.notifier).deletePic();
            },
            child: const Text('画像を削除'),
          ),
          ElevatedButton(
            onPressed: () {
              firestoreService.setDoc();
            },
            child: const Icon(Icons.download),
          ),
          ElevatedButton(
            onPressed: () {
              firestoreService.getDoc();
            },
            child: const Icon(Icons.download),
          ),
          ElevatedButton(
            onPressed: () {
              firestoreService.deleteDoc();
            },
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }
}
