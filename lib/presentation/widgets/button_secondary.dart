import 'package:flutter/material.dart';
import 'package:splitz/presentation/theme/util.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;

  const SecondaryButton({
    required this.text,
    required this.onPressed,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(ThemeColors.surface),
      ),
      onPressed: enabled ? onPressed : null,
      child: Text(text),
    );
  }
}
