import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AvatarDetailPage extends StatelessWidget {
  const AvatarDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アバター詳細'),
        leading: IconButton(
            onPressed: () => context.go('/avatar/list'),
            icon: const Icon(Icons.chevron_left)),
      ),
      body: Center(),
    );
  }
}
