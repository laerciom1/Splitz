import 'package:flutter/material.dart';
import 'package:splitz/application/entities/splitz/group_config_entity.dart';
import 'package:splitz/presentation/theme/util.dart';
import 'package:splitz/presentation/widgets/splitz_image.dart';

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
          border: isSelected ? Border.all(color: ThemeColors.primary) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SplitzImage(imageUrl: category.imageUrl),
        ),
      ),
    );
  }
}
