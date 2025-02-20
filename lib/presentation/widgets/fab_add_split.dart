import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';
import 'package:splitz/presentation/theme/util.dart';
import 'package:splitz/presentation/widgets/fab_anchor.dart';
import 'package:splitz/presentation/widgets/fab_option.dart';

class AddSplitFAB extends StatelessWidget {
  const AddSplitFAB({
    super.key,
    required this.categories,
    required this.onSelectCategory,
    required this.onEditGroupPreferences,
    required this.onAddPayment,
  });

  final List<SplitzCategory> categories;
  final void Function(SplitzCategory) onSelectCategory;
  final void Function() onEditGroupPreferences;
  final void Function() onAddPayment;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      spaceBetweenChildren: 8,
      spacing: 4,
      backgroundColor: ThemeColors.surface,
      children: [
        ...categories.map(
          (category) => FABOption(
            text: category.prefix,
            onPressed: () => onSelectCategory(category),
            chi1d: CachedNetworkImage(imageUrl: category.imageUrl),
          ),
        ),
        FABOption(
          text: 'Add payment',
          onPressed: onAddPayment,
          chi1d: const Icon(Icons.currency_exchange),
          shouldShowBackground: true,
        ),
        FABOption(
          text: 'Edit group preferences',
          onPressed: onEditGroupPreferences,
          chi1d: const Icon(Icons.settings),
          shouldShowBackground: true,
        ),
      ],
      activeChild: FABAnchor(
        backgroundColor: ThemeColors.surface,
        borderColor: ThemeColors.primary,
        child: const Icon(Icons.close),
      ),
      child: FABAnchor(
        backgroundColor: ThemeColors.surface,
        borderColor: ThemeColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
