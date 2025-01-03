import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:splitz/presentation/theme/util.dart';
import 'package:splitz/presentation/widgets/fab_anchor.dart';
import 'package:splitz/presentation/widgets/fab_option.dart';

class AddCategoryFAB extends StatelessWidget {
  const AddCategoryFAB({
    super.key,
    required this.onAdd,
    required this.onFinish,
    required this.enableActions,
  });

  final void Function() onAdd;
  final void Function() onFinish;
  final bool enableActions;

  Widget getAnchorChild(IconData icon, bool enableActions) => enableActions
      ? Icon(icon)
      : const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        );

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      spaceBetweenChildren: 8,
      spacing: 4,
      backgroundColor: ThemeColors.surface,
      children: [
        FABOption(
          text: 'Add category',
          onPressed: onAdd,
          chi1d: const Icon(Icons.add),
          shouldShowBackground: true,
          shouldShowThisOption: enableActions,
        ),
        FABOption(
          text: 'Finish editing',
          onPressed: onFinish,
          chi1d: const Icon(Icons.done),
          shouldShowBackground: true,
          shouldShowThisOption: enableActions,
        ),
      ],
      activeChild: FABAnchor(
        backgroundColor: ThemeColors.surface,
        borderColor: ThemeColors.primary,
        child: getAnchorChild(Icons.close, enableActions),
      ),
      child: FABAnchor(
        backgroundColor: ThemeColors.surface,
        borderColor: ThemeColors.primary,
        child: getAnchorChild(Icons.add, enableActions),
      ),
    );
  }
}
