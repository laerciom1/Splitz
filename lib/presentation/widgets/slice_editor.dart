import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/presentation/theme/slice_colors.dart';
import 'package:splitz/presentation/widgets/circle_avatar.dart';
import 'package:splitz/presentation/widgets/field_percentage.dart';
import 'package:splitz/presentation/widgets/slice_badge.dart';
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

  final List<SplitzConfig> splitzConfigs;
  final List<FocusNode> focusNodes;
  final List<TextEditingController> controllers;
  final void Function(List<SplitzConfig>) onEditConfigs;
  final bool enablePayerSelection;

  List<double> getRanges() => [...splitzConfigs.map((e) => e.slice.toDouble())];

  void setRange(SplitzConfig c, int newSlice) => onEditConfigs([
        ...splitzConfigs.asMap().entries.map((e) {
          if (e.value != c) return e.value;
          return e.value.copyWith(slice: newSlice);
        })
      ]);

  void setRanges(List<double> newRanges) => onEditConfigs([
        ...newRanges.asMap().entries.map((e) {
          return splitzConfigs[e.key].copyWith(slice: e.value.round());
        })
      ]);

  void setSelection(SplitzConfig c) => onEditConfigs([
        ...splitzConfigs.asMap().entries.map((e) {
          if (e.value != c) return e.value.copyWith(payer: false);
          return e.value.copyWith(payer: !(e.value.payer ?? false));
        })
      ]);

  Widget getUserInfo(MapEntry<int, SplitzConfig> e, BuildContext ctx) {
    final inverseSurface = Theme.of(ctx).colorScheme.inverseSurface;
    final index = e.key;
    final config = e.value;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PercentageField(
          text: config.slice.toString(),
          textColor: inverseSurface,
          backgroundColor: sliceColors[index],
          focusNode: focusNodes[index],
          controller: controllers[index],
          onChanged: (newValue) => setRange(
            e.value,
            newValue.isNotNullNorEmpty ? int.parse(newValue) : 0,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              config.name,
              style: const TextStyle(fontSize: 16),
            ),
            SliceBadge(color: sliceColors[index]),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ranges = getRanges();
    final sum = ranges.fold(0.0, (accu, curr) => accu + curr);
    return Column(
      children: [
        ...splitzConfigs.asMap().entries.map<Widget>((e) {
          final config = e.value;
          return InkWell(
            onTap: () => setSelection(config),
            child: Container(
              padding: const EdgeInsets.all(_padding),
              decoration: enablePayerSelection && config.payer == true
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(_padding * 2),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
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
                  Focus(child: getUserInfo(e, context)),
                ],
              ),
            ),
          );
        }).intersperse(const SizedBox(height: 4)),
        const SizedBox(height: 8),
        if (sum == 100.0)
          SliceSlider(
            onRangesChanged: setRanges,
            initRangeValues: getRanges(),
          ),
        if (sum != 100.0)
          const Text('The sum of the users\' parts must be 100%'),
      ],
    );
  }
}
