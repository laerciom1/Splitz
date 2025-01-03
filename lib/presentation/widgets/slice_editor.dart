import 'package:flutter/material.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/presentation/theme/slice_colors.dart';
import 'package:splitz/presentation/theme/util.dart';
import 'package:splitz/presentation/widgets/circle_avatar.dart';
import 'package:splitz/presentation/widgets/field_percentage.dart';
import 'package:splitz/presentation/widgets/slice_slider.dart';

const _padding = 8.0;
const _userCardHeight = 48.0 + (2 * _padding);

class SliceEditor extends StatelessWidget {
  const SliceEditor({
    required this.splitzConfigs,
    required this.focusNodes,
    required this.controllers,
    required this.onEditConfigs,
    this.enablePayerSelection = false,
    super.key,
  });

  final Map<String, SplitzConfig> splitzConfigs;
  final List<FocusNode> focusNodes;
  final List<TextEditingController> controllers;
  final void Function(Map<String, SplitzConfig>) onEditConfigs;
  final bool enablePayerSelection;

  List<double> getRanges() =>
      [...splitzConfigs.values.map((e) => e.slice.toDouble())];

  void setRange(SplitzConfig c, int newSlice) {
    splitzConfigs['${c.id}'] =
        splitzConfigs['${c.id}']!.copyWith(slice: newSlice);
    onEditConfigs(splitzConfigs);
  }

  void setRanges(List<double> newRanges) {
    var keyIterator = splitzConfigs.keys.iterator;
    var valueIterator = newRanges.iterator;
    while (keyIterator.moveNext() && valueIterator.moveNext()) {
      final key = keyIterator.current;
      final value = valueIterator.current;
      splitzConfigs[key] = splitzConfigs[key]!.copyWith(slice: value.round());
    }
    onEditConfigs(splitzConfigs);
  }

  void setSelection(SplitzConfig c) {
    final targeKey = '${c.id}';
    bool isSelected = splitzConfigs[targeKey]!.payer == true;
    for (final key in splitzConfigs.keys) {
      splitzConfigs[key] = splitzConfigs[key]!.copyWith(
        payer: targeKey != key ? false : !isSelected,
      );
    }
    onEditConfigs(splitzConfigs);
  }

  Widget getUserInfo(int index, SplitzConfig config, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PercentageField(
          text: config.slice.toString(),
          textColor: ThemeColors.inverseSurface,
          backgroundColor: sliceColors[index],
          focusNode: focusNodes[index],
          controller: controllers[index],
          onChanged: (newValue) => setRange(
            config,
            newValue.isNotNullNorEmpty ? int.parse(newValue) : 0,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          config.name,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  List<Widget> getUserTiles(BuildContext context) {
    int index = 0;
    return splitzConfigs.values
        .map<Widget>((config) {
          final child = Container(
            padding: const EdgeInsets.all(_padding),
            decoration: enablePayerSelection && config.payer == true
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(_padding * 2),
                    border: Border.all(
                      color: ThemeColors.primary,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  )
                : null,
            height: _userCardHeight,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SplitzCircleAvatar(
                  radius: _userCardHeight,
                  avatarUrl: config.avatarUrl,
                ),
                const SizedBox(width: 12),
                getUserInfo(index++, config, context),
              ],
            ),
          );
          if (!enablePayerSelection) {
            return FocusableActionDetector(child: child);
          }
          return InkWell(
            onTap: () => setSelection(config),
            child: child,
          );
        })
        .intersperse(const SizedBox(height: 4))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ranges = getRanges();
    final sum = ranges.fold(0.0, (accu, curr) => accu + curr);
    final left = 100.0 - sum;
    final hintColor = left < 0 ? ThemeColors.error : null;
    final hintLabel = left < 0 ? 'above' : 'remaining';
    return Column(
      children: [
        SizedBox(
          height: sum != 100.0 ? null : 0,
          child: Column(
            children: [
              Text(
                '${sum.toInt()}% of 100%',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                '${left.toInt().abs()}% $hintLabel',
                style: TextStyle(fontSize: 12, color: hintColor),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        ...getUserTiles(context),
        SizedBox(
          height: sum == 100.0 ? null : 0,
          child: SliceSlider(
            onRangesChanged: setRanges,
            initRangeValues: getRanges(),
          ),
        ),
      ],
    );
  }
}
