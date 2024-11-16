import 'package:flutter/material.dart';

extension WidgetX on Widget {
  Widget inSafeArea() => SafeArea(child: this);

  Widget withPadding(EdgeInsetsGeometry padding) =>
      Padding(padding: padding, child: this);
}
