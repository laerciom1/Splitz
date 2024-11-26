import 'package:flutter/material.dart';

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

  Widget badge({
    required double size,
    required Widget child,
  }) =>
      Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          Positioned(
            bottom: -1 * size * (2 / 4),
            right: -1 * size * (2 / 4),
            child: Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                border: Border.all(color: textColor),
                borderRadius: BorderRadius.circular(size),
                color: backgroundColor,
              ),
              child: Center(
                child: Text(
                  '%',
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

  @override
  Widget build(BuildContext context) {
    return badge(
      size: 20.0,
      child: Container(
        height: 36,
        width: 44,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 10),
          child: TextField(
            scrollPadding: const EdgeInsets.only(bottom: 32.0),
            focusNode: focusNode,
            controller: controller..text = text,
            keyboardType: TextInputType.number,
            enableInteractiveSelection: false,
            cursorHeight: 16,
            cursorColor: textColor,
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
      ),
    );
  }
}
