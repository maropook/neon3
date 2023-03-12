import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecordingPage extends StatelessWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('レコーディング'),
        actions: [
          IconButton(
              onPressed: () => context.go('/import'),
              icon: const Icon(Icons.download_rounded)),
          IconButton(
              onPressed: () => context.go('/edit'),
              icon: const Icon(Icons.chevron_right)),
        ],
        leading: IconButton(
            onPressed: () => context.go('/avatar/list'),
            icon: const Icon(Icons.face)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
