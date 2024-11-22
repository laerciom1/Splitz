import 'package:flutter/material.dart';

const _badgeSize = 20.0;

extension WidgetX on Widget {
  Widget withBadge({
    required String character,
    required Color textColor,
    required Color badgeColor,
    required Color badgeBorderColor,
  }) {
    assert(character.length == 1, 'character must have a lenght of 1');
    return Stack(
      clipBehavior: Clip.none,
      children: [
        this,
        Positioned(
          bottom: -1 * _badgeSize * (2 / 4),
          right: -1 * _badgeSize * (2 / 4),
          child: Container(
            height: _badgeSize,
            width: _badgeSize,
            decoration: BoxDecoration(
              border: Border.all(color: badgeBorderColor),
              borderRadius: BorderRadius.circular(10),
              color: badgeColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                character,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  color: textColor,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
