import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:splitz/data/models/splitz/group_config.dart';

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

  SpeedDialChild getSpeedDialChild({
    required String label,
    required void Function() onTap,
    required Widget child,
    bool shouldShowBackground = false,
  }) =>
      SpeedDialChild(
        shape: const CircleBorder(),
        elevation: 0,
        backgroundColor: shouldShowBackground ? null : Colors.transparent,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: child,
        ),
        label: label,
        labelStyle: const TextStyle(fontSize: 14),
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      children: [
        ...categories.map(
          (category) => getSpeedDialChild(
            label: category.prefix,
            onTap: () => onSelectCategory(category),
            child: CachedNetworkImage(imageUrl: category.imageUrl),
          ),
        ),
        getSpeedDialChild(
          label: 'Edit group preferences',
          onTap: onEditGroupPreferences,
          child: const Icon(Icons.settings),
          shouldShowBackground: true,
        ),
      ],
      spaceBetweenChildren: 8,
      spacing: 4,
    );
  }
}
