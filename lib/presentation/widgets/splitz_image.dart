import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplitzImage extends StatelessWidget {
  const SplitzImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.fit,
  });

  final String imageUrl;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        imageUrl,
        width: width,
        fit: fit,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      fit: fit,
    );
  }
}
