import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecordingPage extends StatelessWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/edit');
              },
              child: const Text('ホーム(edit)'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/encoding');
              },
              child: const Text('ホーム(encoding)'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/complete');
              },
              child: const Text('ホーム(complete)'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/avatar/list');
              },
              child: const Text('ホーム(avatar/list)'),
            ),
          ],
        ),
      ),
    );
  }
}
