import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AvatarDetailPage extends StatelessWidget {
  const AvatarDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/avatar/list');
          },
          child: const Text('avatar/list/detail(listへ)'),
        ),
      ),
    );
  }
}
