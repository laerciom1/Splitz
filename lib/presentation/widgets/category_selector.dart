import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/presentation/widgets/category_image.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    required this.categories,
    required this.onSelect,
    required this.selectedCategory,
    super.key,
  });

  final List<SplitzCategory> categories;
  final void Function(SplitzCategory) onSelect;
  final SplitzCategory selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          width: 1.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Wrap(
              spacing: 2.0,
              runSpacing: 2.0,
              children: [
                ...categories.map(
                  (c) => CategoryImage(
                    category: c,
                    onSelect: onSelect,
                    isSelected: c.imageUrl == selectedCategory.imageUrl,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
