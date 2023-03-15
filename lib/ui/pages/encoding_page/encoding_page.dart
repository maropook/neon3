import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EncodingPage extends StatelessWidget {
  const EncodingPage({required this.filePath, super.key});

  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('エンコーディング'),
        actions: [
          IconButton(
              onPressed: () => context.go('/complete', extra: filePath),
              icon: const Icon(Icons.chevron_right)),
        ],
        leading: IconButton(
            onPressed: () => context.go('/edit', extra: filePath),
            icon: const Icon(Icons.chevron_left)),
      ),
      body: Center(),
    );
  }
}
