import 'package:flutter/material.dart';

class FABAnchor extends StatelessWidget {
  const FABAnchor({
    required this.child,
    required this.backgroundColor,
    required this.borderColor,
    super.key,
  });

  final Widget child;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(
            width: 2.0,
            color: borderColor,
          )),
      height: 56,
      width: 56,
      child: Center(child: child),
    );
  }
}
