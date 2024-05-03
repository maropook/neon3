import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/services/logger.dart';

part 'user_controller.freezed.dart';

@freezed
class UserState with _$UserState {
  factory UserState({
    @Default('') String loginMessage,
    @Default('') String uid,
    @Default(null) User? user,
    @Default(null) bool? isAnonymous, //nullの場合は匿名でもなくログインしていない
  }) = _UserState;
}

// final userProvider =
//     StateNotifierProvider<UserController, UserState>((ref) => UserController());

class UserController extends StateNotifier<UserState> {
  UserController() : super(UserState()) {
    init();
  }

  final User? currentUser = FirebaseAuth.instance.currentUser;

  void anonymous() async {
    state = state.copyWith(isAnonymous: true);
  }

  Future<void> init() async {
    addListen();
  }

  void addListen() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      state = state.copyWith(isAnonymous: user?.isAnonymous, user: user);
      switch (user?.isAnonymous) {
        case null:
          state = state.copyWith(loginMessage: 'ログインしてください');
          break;
        case true:
          state = state.copyWith(loginMessage: '匿名認証中です');
          break;
        case false:
          state = state.copyWith(loginMessage: 'ログイン中です:${user!.email}');
          break;
        default:
          state = state.copyWith(loginMessage: 'call listen:default');
      }
    });
  }

  Future<void> signIn(String id, String pass) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: id, password: pass);

      state = state.copyWith(user: credential.user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          state = state.copyWith(loginMessage: 'メールアドレスが無効です');
          break;
        case 'user-not-found':
          state = state.copyWith(loginMessage: 'ユーザーが存在しません');
          break;
        case 'wrong-password':
          state = state.copyWith(loginMessage: 'パスワードが間違っています');
          break;
        default:
          state = state.copyWith(loginMessage: 'サインインエラー');
      }
    } catch (e) {
      Logger.log("user_controller:sign_in", e.toString());
    }
  }

  Future<void> signUp(String id, String pass) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: id, password: pass);

      state = state.copyWith(
          loginMessage: 'アカウント作成に成功${credential.user!.email!}',
          user: credential.user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          state = state.copyWith(loginMessage: 'パスワードが弱いです');
          break;
        case 'email-already-in-use':
          state = state.copyWith(loginMessage: 'すでに使用されているメールアドレスです');
          break;
        default:
          state = state.copyWith(loginMessage: 'アカウント作成エラー');
      }
    } catch (e) {
      Logger.log("user_controller:sign_up", e.toString());
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    state = state.copyWith(loginMessage: 'サインインまたはアカウントを作成してください');
  }

  Future<void> signInAnonymously() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final credential = await firebaseAuth.signInAnonymously();
      state =
          state.copyWith(user: credential.user, loginMessage: '匿名認証に成功しました');
    } catch (e) {
      state = state.copyWith(loginMessage: '匿名ログインエラー$e');
      Logger.log("user_controller:sign_out", e.toString());
    }
  }

  Future<void> linkWithCredential(String email, String password) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.isAnonymous) {
      try {
        final AuthCredential authCredential =
            EmailAuthProvider.credential(email: email, password: password);
        final credential = await user.linkWithCredential(authCredential);
        state = state.copyWith(
            user: credential.user,
            loginMessage: '匿名アカウントとのリンクに成功${credential.user!.email!}');
      } catch (e) {
        state = state.copyWith(loginMessage: '匿名アカウントのリンクエラー$e');
        Logger.log("user_controller:link_with_credential", e.toString());
      }
    } else {
      state = state.copyWith(
          loginMessage:
              'user != null${user != null} && user.isAnonymous = ${user?.isAnonymous}');
    }
  }
}
