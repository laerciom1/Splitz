import 'package:flutter/material.dart';
import 'package:splitz/presentation/theme/util.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/splitz_divider.dart';

class ActionFooter extends StatelessWidget {
  const ActionFooter({
    required this.onAction,
    required this.text,
    this.enabled = true,
    this.leading,
    super.key,
  });

  final String text;
  final void Function() onAction;
  final bool enabled;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SplitzDivider(color: ThemeColors.primary),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PrimaryButton(
                text: text,
                onPressed: onAction,
                enabled: enabled,
              ),
              if (leading != null) leading!,
            ],
          ),
        ),
      ],
    );
  }
}
