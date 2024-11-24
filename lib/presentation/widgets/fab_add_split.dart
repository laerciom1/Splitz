import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/presentation/widgets/fab_anchor.dart';
import 'package:splitz/presentation/widgets/fab_option.dart';

class AddSplitFAB extends StatelessWidget {
  const AddSplitFAB({
    super.key,
    required this.categories,
    required this.onSelectCategory,
    required this.onEditGroupPreferences,
  });

  final List<SplitzCategory> categories;
  final void Function(SplitzCategory) onSelectCategory;
  final void Function() onEditGroupPreferences;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).primaryColor;
    final borderColor = Theme.of(context).colorScheme.primary;
    return SpeedDial(
      spaceBetweenChildren: 8,
      spacing: 4,
      backgroundColor: backgroundColor,
      children: [
        ...categories.map(
          (category) => FABOption(
            text: category.prefix,
            onPressed: () => onSelectCategory(category),
            chi1d: CachedNetworkImage(imageUrl: category.imageUrl),
          ),
        ),
        FABOption(
          text: 'Edit group preferences',
          onPressed: onEditGroupPreferences,
          chi1d: const Icon(Icons.settings),
          shouldShowBackground: true,
        ),
      ],
      activeChild: FABAnchor(
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        child: const Icon(Icons.close),
      ),
      child: FABAnchor(
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
