import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maropook_neon2/ui/pages/avatar_detail_page/avatar_detail_page.dart';
import 'package:maropook_neon2/ui/pages/avatar_list_page/avatar_list_page.dart';
import 'package:maropook_neon2/ui/pages/complete_page/complete_page.dart';
import 'package:maropook_neon2/ui/pages/edit_page/edit_page.dart';
import 'package:maropook_neon2/ui/pages/encoding_page/encode_page.dart';
import 'package:maropook_neon2/ui/pages/import_page/import_page.dart';
import 'package:maropook_neon2/ui/pages/recording_page/recording_page.dart';

class PageRouter {
  static final GoRouter router =
      GoRouter(initialLocation: '/', routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const RecordingPage();
      },
      routes: [
        GoRoute(
            path: 'avatar/list', //頭に/入れないように注意する
            builder: (BuildContext context, GoRouterState state) {
              return const AvatarListPage();
            },
            routes: [
              GoRoute(
                path: 'detail',
                builder: (BuildContext context, GoRouterState state) {
                  return const AvatarDetailPage();
                },
              ),
            ]),
        GoRoute(
          path: 'import',
          builder: (BuildContext context, GoRouterState state) {
            return const ImportPage();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/edit',
      builder: (BuildContext context, GoRouterState state) {
        return EditPage(editPageArgs: state.extra as EditPageArgs);
      },
    ),
    GoRoute(
      path: '/encoding',
      builder: (BuildContext context, GoRouterState state) {
        return EncodePage(filePath: state.extra.toString());
      },
    ),
    GoRoute(
      path: '/complete',
      builder: (BuildContext context, GoRouterState state) {
        return CompletePage(filePath: state.extra.toString());
      },
    ),
  ]);
}
