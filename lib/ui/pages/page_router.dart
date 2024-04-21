import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/global/user_controller.dart';
import 'package:neon3/controllers/pages/import_sheet_controller.dart';
import 'package:neon3/models/src/active_frame.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/ui/pages/avatar_detail_page/avatar_detail_page.dart';
import 'package:neon3/ui/pages/avatar_list_page/avatar_list_page.dart';
import 'package:neon3/ui/pages/complete_page/complete_page.dart';
import 'package:neon3/ui/pages/edit_page/edit_page.dart';
import 'package:neon3/ui/pages/encoding_page/encode_page.dart';
import 'package:neon3/ui/pages/import_page/import_page.dart';
import 'package:neon3/ui/pages/login_page/login_page.dart';
import 'package:neon3/ui/pages/recording_page/recording_page.dart';
import 'package:neon3/ui/pages/trim_page/trim_page.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider((ref) {
  final bool? isAnonymous =
      ref.watch(userProvider.select((s) => s.isAnonymous));

  return GoRouter(
    initialLocation: '/',
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
          path: '/avatar/list', //頭に/入れないように注意する
          builder: (BuildContext context, GoRouterState state) {
            return const AvatarListPage();
          },
          routes: [
            GoRoute(
              path: 'detail',
              builder: (BuildContext context, GoRouterState state) {
                return AvatarDetailPage(avatar: state.extra as Avatar);
              },
            ),
          ]),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const RecordingPage();
        },
        routes: [
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
        path: '/trim',
        builder: (BuildContext context, GoRouterState state) {
          return TrimPage(state.extra as EditPageArgs);
        },
      ),
      GoRoute(
        path: '/encoding',
        builder: (BuildContext context, GoRouterState state) {
          return EncodePage(encodePageArgs: state.extra as EncodePageArgs);
        },
      ),
      GoRoute(
        path: '/complete',
        builder: (BuildContext context, GoRouterState state) {
          return CompletePage(filePath: state.extra.toString());
        },
      ),
    ],
    redirect: (context, state) {
      if (isAnonymous == null) {
        return state.subloc == '/login' ? null : '/login';
      }
      return null;
      return '/'; //これだと/かloginのページしか行けない(画面遷移ができない)
    },
  );
});

class EditPageArgs {
  EditPageArgs({
    required this.audioFilePath,
    required this.videoFilePath,
    required this.activeFrames,
    required this.avatar,
    required this.recordingType,
  });

  String audioFilePath;
  String videoFilePath;
  List<ActiveFrame> activeFrames;
  Avatar avatar;
  RecordingType recordingType;
}

class SubtitleTimingEditPageArgs {
  SubtitleTimingEditPageArgs(
      {required this.audioFilePath,
      required this.videoFilePath,
      required this.activeFrames,
      required this.subtitleTexts,
      required this.avatar});

  String audioFilePath;
  String videoFilePath;
  List<ActiveFrame> activeFrames;
  List<SubtitleText> subtitleTexts;
  Avatar avatar;
}

class SubtitleEditPageArgs {
  SubtitleEditPageArgs({
    required this.subtitleText,
  });

  SubtitleText subtitleText;
}

class EncodePageArgs {
  EncodePageArgs({
    required this.audioFilePath,
    required this.videoFilePath,
    required this.musicFilePath,
    required this.ttsAudioFilePath,
    required this.activeFrames,
    required this.subtitleTexts,
    required this.avatar,
    required this.recordingType,
  });

  String audioFilePath;
  String videoFilePath;
  String musicFilePath;
  String ttsAudioFilePath;
  List<ActiveFrame> activeFrames;
  List<SubtitleText> subtitleTexts;
  Avatar avatar;
  RecordingType recordingType;
}
