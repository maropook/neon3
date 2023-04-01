import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/controllers/global/user_controller.dart';
import 'package:maropook_neon2/controllers/pages/login_page_controller.dart';

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(loginMessage, style: const TextStyle(fontSize: 16)),
          ),
          _buildTextFields(ref),
          _buildButtonWidget(ref),
        ],
      ),
    );
  }

  Widget _buildTextFields(WidgetRef ref) {
    final isAnonymous = ref.read(userProvider.select((s) => s.isAnonymous));
    if (isAnonymous != null && !isAnonymous) {
      return const SizedBox();
    }
    final emailController =
        ref.watch(loginPageProvider.notifier).emailController;
    final passwordController =
        ref.watch(loginPageProvider.notifier).passwordController;
    return Column(
      children: [
        TextField(
            decoration: const InputDecoration(
              label: Text('mail'),
              icon: Icon(Icons.mail),
            ),
            controller: emailController),
        TextField(
          decoration: const InputDecoration(
            label: Text('Password'),
            icon: Icon(Icons.key),
          ),
          controller: passwordController,
          obscureText: true,
        ),
      ],
    );
  }

  Widget _buildButtonWidget(WidgetRef ref) {
    final isAnonymous = ref.read(userProvider.select((s) => s.isAnonymous));

    final emailController =
        ref.watch(loginPageProvider.notifier).emailController;
    final passwordController =
        ref.watch(loginPageProvider.notifier).passwordController;
    final userController = ref.read(userProvider.notifier);

    switch (isAnonymous) {
      case null:
        return Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await userController.signIn(
                    emailController.text, passwordController.text);
              },
              child: const Text('ログイン'),
            ),
            ElevatedButton(
              onPressed: () async {
                await userController.signUp(
                    emailController.text, passwordController.text);
              },
              child: const Text('アカウントを作成'),
            ),
            ElevatedButton(
              onPressed: () async {
                await userController.signInAnonymously();
              },
              child: const Text('匿名でログイン'),
            ),
          ],
        );
      case true:
        return Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await userController.signIn(
                    emailController.text, passwordController.text);
              },
              child: const Text('ログイン'),
            ),
            ElevatedButton(
              onPressed: () async {
                await userController.linkWithCredential(
                    emailController.text, passwordController.text);
              },
              child: const Text('メールアドレスをリンク'),
            ),
          ],
        );
      case false:
        return ElevatedButton(
          onPressed: () async {
            await userController.signOut();
          },
          child: const Text('ログアウト'),
        );
      default:
        return const SizedBox();
    }
  }
}
