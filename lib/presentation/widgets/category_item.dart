import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/presentation/theme/slice_colors.dart';
import 'package:splitz/presentation/widgets/slice_badge.dart';

const _cardHeight = 60.0;

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    required this.category,
    required this.splitzConfigs,
    super.key,
  });

  final SplitzCategory category;
  final Map<String, SplitzConfig> splitzConfigs;

  List<Widget> getBadges() {
    int index = 0;
    return splitzConfigs.values
        .map<Widget>((value) =>
            SliceBadge(color: sliceColors[index++], text: '${value.slice}'))
        .intersperse(const SizedBox(width: 4))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: _cardHeight,
          width: _cardHeight,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: CachedNetworkImage(imageUrl: category.imageUrl),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: SizedBox(
            height: _cardHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.prefix,
                  style: const TextStyle(fontSize: 20),
                ),
                Row(
                  children: getBadges(),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
