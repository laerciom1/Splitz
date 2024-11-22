import 'package:flutter/material.dart';
import 'package:splitz/extensions/widgets.dart';

class PrimaryField extends StatelessWidget {
  const PrimaryField({
    required this.focusNode,
    required this.onChanged,
    super.key,
  });

  final FocusNode focusNode;
  final void Function(String) onChanged;

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
        focusNode: focusNode,
        onTapOutside: (_) => focusNode.unfocus(),
        decoration: const InputDecoration(border: InputBorder.none),
        textInputAction: TextInputAction.next,
        autocorrect: false,
        onChanged: onChanged,
      ).withPadding(const EdgeInsets.symmetric(horizontal: 12.0)),
    );
  }
}
