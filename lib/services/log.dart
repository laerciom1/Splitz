import 'dart:developer';

abstract class Log {
  static void that(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
