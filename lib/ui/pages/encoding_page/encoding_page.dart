import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EncodingPage extends StatelessWidget {
  const EncodingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/');
          },
          child: const Text('encoding(ホームへ)'),
        ),
      ),
    );
  }
}
