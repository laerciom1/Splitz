import 'package:flutter/material.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';
import 'package:splitz/presentation/theme/util.dart';
import 'package:splitz/presentation/widgets/circle_avatar.dart';

const _padding = 8.0;
const _userCardHeight = 48.0 + (2 * _padding);

class UserSelector extends StatelessWidget {
  const UserSelector({
    required this.splitzConfigs,
    required this.onChangeSelection,
    this.title,
    this.selection,
    this.enableSelection = true,
    super.key,
  });

  final Map<String, SplitzConfig> splitzConfigs;
  final void Function(SplitzConfig) onChangeSelection;
  final String? title;
  final SplitzConfig? selection;
  final bool enableSelection;

  List<Widget> getUserTiles(BuildContext context, double maxWidth) {
    return splitzConfigs.values.map<Widget>((config) {
      final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(_padding * 2),
        border: Border.all(
          color: ThemeColors.primary.withOpacity(
            selection == config ? 1 : 0,
          ),
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        color: ThemeColors.surfaceBright,
      );
      final child = SizedBox(
        width: maxWidth,
        height: _userCardHeight,
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Container(
            padding: const EdgeInsets.all(_padding),
            decoration: decoration,
            child: Row(
              children: [
                SplitzCircleAvatar(
                  radius: _userCardHeight,
                  avatarUrl: config.avatarUrl,
                ),
                Text(config.name, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      );
      if (!enableSelection) {
        return FocusableActionDetector(child: child);
      }
      return InkWell(
        splashColor: Colors.transparent,
        onTap: () => onChangeSelection(config),
        child: child,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.primary,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        color: ThemeColors.surface,
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        shape: const Border(),
        enableFeedback: false,
        collapsedBackgroundColor: ThemeColors.surfaceBright,
        backgroundColor: ThemeColors.surfaceBright,
        title: Text(title ?? ''),
        children: <Widget>[
          ColoredBox(
            color: ThemeColors.surface,
            child: LayoutBuilder(
              builder: (context, constraints) => Wrap(children: [
                ...getUserTiles(context, constraints.maxWidth / 2)
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
