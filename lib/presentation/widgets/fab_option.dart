import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

const _circleSize = 46.0;

class FABOption extends SpeedDialChild {
  final String text;
  final void Function() onPressed;
  final Widget chi1d;
  final bool shouldShowBackground;
  final bool shouldShowThisOption;

  FABOption({
    required this.text,
    required this.onPressed,
    required this.chi1d,
    this.shouldShowBackground = false,
    this.shouldShowThisOption = true,
    super.key,
  }) : super(
          shape: const CircleBorder(),
          elevation: 0,
          backgroundColor: shouldShowBackground ? null : Colors.transparent,
          child: Container(
            height: _circleSize,
            width: _circleSize,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: chi1d,
          ),
          label: text,
          labelStyle: const TextStyle(fontSize: 14),
          onTap: onPressed,
          visible: shouldShowThisOption,
        );
}
