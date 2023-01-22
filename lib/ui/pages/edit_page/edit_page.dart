import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/');
          },
          child: const Text('edit(ホームへ)'),
        ),
      ),
    );
  }
}
