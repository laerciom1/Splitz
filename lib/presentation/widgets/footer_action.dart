import 'package:flutter/material.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/splitz_divider.dart';

class ActionFooter extends StatelessWidget {
  const ActionFooter({
    required this.onAction,
    required this.text,
    this.enabled = true,
    super.key,
  });

  final String text;
  final void Function() onAction;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SplitzDivider(color: Theme.of(context).colorScheme.primary),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: PrimaryButton(
              text: text,
              onPressed: onAction,
              enabled: enabled,
            ),
          ),
        ),
      ],
    );
  }
}
