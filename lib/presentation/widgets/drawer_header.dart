import 'package:flutter/material.dart';
import 'package:splitz/presentation/widgets/splitz_divider.dart';

class SplitzDrawerHeader extends StatelessWidget {
  const SplitzDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('Splitz', style: TextStyle(fontSize: 24)),
          ),
          SplitzDivider(color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }
}
