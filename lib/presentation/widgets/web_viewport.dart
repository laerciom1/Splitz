import 'package:flutter/material.dart';

class WebViewport extends StatelessWidget {
  const WebViewport({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        if (availableHeight >= availableWidth) {
          return child;
        }

        final backgroundColor = Theme.of(context).colorScheme.surface;

        const borderRadius = 12.0;
        const borderWidth = 4.0;

        return Container(
          padding: const EdgeInsets.all(8),
          color: backgroundColor,
          child: Center(
            child: Container(
              width: availableWidth / 2,
              height: availableHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: Color.lerp(
                    backgroundColor,
                    Colors.white,
                    0.25,
                  )!,
                  width: 4,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius - borderWidth / 2),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
