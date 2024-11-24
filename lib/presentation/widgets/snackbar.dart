import 'package:flutter/material.dart';
import 'package:splitz/navigator.dart';

void showToast(
  String message, {
  String? actionLabel,
  void Function()? actionFunction,
}) {
  final scaffold = ScaffoldMessenger.of(AppNavigator.context);
  final action = SnackBarAction(
      label: actionLabel ?? 'HIDE',
      onPressed: () {
        actionFunction?.call();
        scaffold.hideCurrentSnackBar();
      });
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.fixed,
      action: action,
    ),
  );
}
