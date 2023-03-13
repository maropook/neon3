import 'package:flutter/material.dart';

class Logger {
  Logger(this.name);

  String name;

  static void log(String name, String message) {
    debugPrint('[$name]: $message');
  }

  static void logError(String name, String code, {String? message}) {
    if (message != null) {
      debugPrint('[$name] Error: $code\nError Message: $message');
    } else {
      debugPrint('[$name] Error: $code');
    }
  }
}
