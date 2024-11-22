import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SplitzCircleAvatar extends StatelessWidget {
  const SplitzCircleAvatar({
    required this.radius,
    required this.avatarUrl,
    super.key,
  });

  final double radius;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: CachedNetworkImage(imageUrl: avatarUrl),
    );
  }
}
