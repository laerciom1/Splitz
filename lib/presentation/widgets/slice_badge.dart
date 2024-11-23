import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:splitz/extensions/strings.dart';

const _minHeight = 8.0;
const _minWidth = _minHeight * 2;

class SliceBadge extends StatelessWidget {
  const SliceBadge({required this.color, this.text, super.key});

  final Color color;
  final String? text;

  Widget? getChild() {
    if (text.isNullOrEmpty) return null;
    double value = int.parse(text!) / 2;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: max(4, value)),
      child: Text(text!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: _minWidth,
        minHeight: _minHeight,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_minWidth),
        color: color,
      ),
      child: getChild(),
    );
  }
}
