import 'package:flutter/material.dart';
import 'package:splitz/extensions/widgets.dart';

class PercentageField extends StatelessWidget {
  const PercentageField({
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    this.onChanged,
    super.key,
  });

  final String text;
  final Color textColor;
  final Color backgroundColor;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        enableInteractiveSelection: false,
        showCursor: false,
        keyboardType: TextInputType.number,
        maxLength: 2,
        style: TextStyle(color: textColor),
        textInputAction: TextInputAction.done,
        autocorrect: false,
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        controller: TextEditingController(text: text)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: text.length),
          ),
      ).withPadding(const EdgeInsets.only(left: 8, bottom: 10)),
    ).withBadge(
      character: '%',
      textColor: textColor,
      badgeColor: backgroundColor,
      badgeBorderColor: textColor,
    );
  }
}
