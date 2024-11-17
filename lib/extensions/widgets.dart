import 'package:flutter/material.dart';

extension WidgetX on Widget {
  Widget withPadding(EdgeInsetsGeometry padding) =>
      Padding(padding: padding, child: this);
}
