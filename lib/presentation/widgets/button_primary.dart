import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;

  const PrimaryButton({
    required this.text,
    required this.onPressed,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: enabled ? onPressed : null,
      child: Text(text),
    );
  }
}
