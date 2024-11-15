import 'package:flutter/material.dart';

abstract class AppNavigator {
  static final navigator = GlobalKey<NavigatorState>();

  static BuildContext get context => navigator.currentContext!;

  static Future<T?> push<T>(Widget page) {
    return navigator.currentState!.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void replaceAll(List<Widget> screens) {
    if (screens.isEmpty) return;

    navigator.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => screens.first),
      (_) => false,
    );

    for (var i = 1; i < screens.length; i++) {
      navigator.currentState!.push(
        MaterialPageRoute(builder: (context) => screens[i]),
      );
    }
  }

  static void pop<T>([T? result]) {
    navigator.currentState!.pop<T>(result);
  }

  static bool canPop() {
    return navigator.currentState!.canPop();
  }
}
