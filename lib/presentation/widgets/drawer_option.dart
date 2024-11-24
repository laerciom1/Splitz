import 'package:flutter/material.dart';

const _tileHeight = 36.0;

class SplitzDrawerTile extends StatelessWidget {
  const SplitzDrawerTile({
    required this.onTap,
    required this.label,
    this.leading,
    super.key,
  });

  final void Function() onTap;
  final String label;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: _tileHeight,
          width: double.infinity,
          child: Row(
            children: [
              if (leading != null) leading!,
              const SizedBox(width: 12),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
