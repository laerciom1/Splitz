import 'dart:developer' as dev;

/* The idea behind the log class being a service is that in the future it can be
   used to integrate with observability services, and this integration usually
   comes along with some business rules
*/

abstract class LogService {
  static void log(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    dev.log(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
