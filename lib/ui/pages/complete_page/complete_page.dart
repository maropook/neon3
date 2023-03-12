import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompletePage extends StatelessWidget {
  const CompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('コンプリート'),
        actions: [
          IconButton(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.chevron_right)),
        ],
        leading: IconButton(
            onPressed: () => context.go('/encoding'),
            icon: const Icon(Icons.chevron_left)),
      ),
      body: Center(),
    );
  }
}
