import 'package:flutter/material.dart';
import 'package:splitz/presentation/widgets/splitz_divider.dart';

class SplitzAppBar extends AppBar {
  final Color detailColor;
  final Color bgColor;
  SplitzAppBar({
    required this.detailColor,
    required this.bgColor,
    super.key,
  }) : super(
          title: const Text('Z'),
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          backgroundColor: bgColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child: SplitzDivider(color: detailColor),
          ),
        );
}
