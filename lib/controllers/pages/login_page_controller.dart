import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'login_page_controller.freezed.dart';

@freezed
class LoginPageState with _$LoginPageState {
  const factory LoginPageState({
    @Default(null) String? text,
  }) = _LoginPageState;
}

final loginPageProvider =
    StateNotifierProvider.autoDispose<LoginPageController, LoginPageState>(
        (ref) => LoginPageController());

class LoginPageController extends StateNotifier<LoginPageState> {
  LoginPageController() : super(const LoginPageState()) {
    init();
  }
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> init() async {}
}
