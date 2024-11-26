import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrimaryField extends StatelessWidget {
  const PrimaryField({
    required this.focusNode,
    required this.onChanged,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    super.key,
  });

  final FocusNode focusNode;
  final TextEditingController? controller;
  final void Function(String) onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextField(
          scrollPadding: const EdgeInsets.only(bottom: 32.0),
          inputFormatters: inputFormatters,
          focusNode: focusNode,
          controller: controller,
          onTapOutside: (_) => focusNode.unfocus(),
          decoration: const InputDecoration(border: InputBorder.none),
          textInputAction: TextInputAction.next,
          autocorrect: false,
          onChanged: onChanged,
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}
