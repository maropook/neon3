import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AvatarListPage extends StatelessWidget {
  const AvatarListPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Center(),
    );
  }
}
