import 'package:flutter/widgets.dart';

class SplitzDivider extends StatelessWidget {
  const SplitzDivider({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) =>
      Container(color: color, height: 2.0, width: double.infinity);
}
