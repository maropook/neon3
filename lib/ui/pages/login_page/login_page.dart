import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/controllers/global/user_controller.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginMessage = ref.watch(userProvider.select((s) => s.loginMessage));
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                ref.read(userProvider.notifier).anonymous();
                context.go('/');
              },
              child: Text(loginMessage)),
          const Center(child: Text('ログイン画面')),
        ],
      ),
    );
  }
}
