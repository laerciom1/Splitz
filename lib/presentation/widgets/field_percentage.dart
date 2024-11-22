import 'package:flutter/material.dart';
import 'package:splitz/extensions/widgets.dart';

class PercentageField extends StatelessWidget {
  const PercentageField({
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.focusNode,
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final String text;
  final Color textColor;
  final Color backgroundColor;
  final FocusNode focusNode;
  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 36,
          width: 44,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 10),
            child: TextField(
              focusNode: focusNode,
              controller: controller..text = text,
              keyboardType: TextInputType.number,
              enableInteractiveSelection: false,
              cursorHeight: 16,
              maxLength: 2,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: textColor),
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
              onChanged: onChanged,
              onTapOutside: (_) => focusNode.unfocus(),
              onSubmitted: (_) => focusNode.nextFocus(),
            ),
          ),
        ).withBadge(
          character: '%',
          textColor: textColor,
          badgeColor: backgroundColor,
          badgeBorderColor: textColor,
        ),
      ],
    );
  }
}
