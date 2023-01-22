import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AvatarListPage extends StatelessWidget {
  const AvatarListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/avatar/list/detail');
              },
              child: const Text('avatar/list(detailへ)'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text('avatar/list(ホームへ)'),
            ),
          ],
        ),
      ),
    );
  }
}
