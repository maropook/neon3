import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neon3/config/styles.dart';

class ImportPage extends StatelessWidget {
  const ImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'インポート',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Styles.appBarTitleColor),
        ),
        leading: IconButton(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.chevron_left)),
      ),
      body: Center(),
    );
  }
}
