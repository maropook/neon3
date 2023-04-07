import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/global/user_controller.dart';
import 'package:neon3/ui/pages/page_router.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setPathUrlStrategy();

  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    ref.listen(userProvider.select((s) => s.isAnonymous), (_, __) {
      router.refresh();
    });

    return MaterialApp.router(
      title: 'neon',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: router,
      builder: (context, child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}
