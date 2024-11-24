import 'package:flutter/material.dart';

class FeedbackMessage extends StatelessWidget {
  const FeedbackMessage({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Text(message, textAlign: TextAlign.center),
      );
}
