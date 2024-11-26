import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';

class CategoryImage extends StatelessWidget {
  const CategoryImage({
    required this.category,
    required this.onSelect,
    this.isSelected = false,
    super.key,
  });

  final SplitzCategory category;
  final void Function(SplitzCategory) onSelect;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect(category),
      child: Container(
        height: 60,
        width: 60,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CachedNetworkImage(imageUrl: category.imageUrl),
        ),
      ),
    );
  }
}
