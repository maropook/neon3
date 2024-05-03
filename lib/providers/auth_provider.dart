import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';

part 'auth_provider.freezed.dart';

@freezed
class AuthState with _$AuthState {
  factory AuthState({
    @Default('') String uid,
  }) = _AuthState;
  AuthState._();
}

final authProvider =
    StateNotifierProvider<UserController, AuthState>((ref) => UserController());

class UserController extends StateNotifier<AuthState> {
  UserController() : super(AuthState()) {
    _login();
  }

  final _auth = firebase.FirebaseAuth.instance;

  Future<void> _login() async {
    var currentUser = _auth.currentUser;

    if (currentUser == null) {
      // final userCredential = await _auth.signInWithEmailAndPassword(
      //   email: 'oshima@buildman.co.jp',
      //   password: 'password',
      // );

      final userCredential = await _auth.signInAnonymously();
      currentUser = userCredential.user;

      state = state.copyWith(uid: currentUser?.uid ?? '');
      return;
    }

    final uid = currentUser.uid;
    state = state.copyWith(uid: uid);
  }
}
