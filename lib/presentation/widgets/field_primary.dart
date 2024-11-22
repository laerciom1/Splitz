import 'package:flutter/material.dart';
import 'package:splitz/extensions/widgets.dart';

class PrimaryField extends StatelessWidget {
  const PrimaryField({
    this.onChanged,
    super.key,
  });

  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          width: 1.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: TextField(
        decoration: const InputDecoration(border: InputBorder.none),
        textInputAction: TextInputAction.done,
        autocorrect: false,
        onChanged: onChanged,
      ).withPadding(const EdgeInsets.symmetric(horizontal: 12.0)),
    );
  }
}
