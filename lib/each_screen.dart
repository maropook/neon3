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

class CompletePage extends StatelessWidget {
  const CompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/');
          },
          child: const Text('complete(ホームへ)'),
        ),
      ),
    );
  }
}

class AvatarListPage extends StatelessWidget {
  const AvatarListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/avatar/list/detail');
              },
              child: const Text('avatar/list(detailへ)'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text('avatar/list(ホームへ)'),
            ),
          ],
        ),
      ),
    );
  }
}

class AvatarDetailPage extends StatelessWidget {
  const AvatarDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/avatar/list');
          },
          child: const Text('avatar/list/detail(listへ)'),
        ),
      ),
    );
  }
}

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
