import 'package:flutter/material.dart';

class PrimaryField extends StatelessWidget {
  const PrimaryField({
    required this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    super.key,
  });

  final String labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
    );
  }
}
