import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImportPage extends StatelessWidget {
  const ImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text('importページ(ホームへ))'),
            ),
          ],
        ),
      ),
    );
  }
}
